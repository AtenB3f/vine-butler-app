import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/network/api_exception.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_address_view_state.dart';

final editPropertyAddressVMProvider =
    NotifierProvider.autoDispose.family<EditPropertyAddressVM, EditPropertyAddressViewState, String>(
  EditPropertyAddressVM.new,
);

sealed class EditPropertyAddressAction {
  const EditPropertyAddressAction();

  const factory EditPropertyAddressAction.inputDetail(String detailAddress) = _InputDetail;
  const factory EditPropertyAddressAction.resetAddress() = _ResetAddress;
  const factory EditPropertyAddressAction.search(String query) = _Search;
  const factory EditPropertyAddressAction.loadMore() = _LoadMore;
  const factory EditPropertyAddressAction.select(AddressResultViewState address) = _Select;
  const factory EditPropertyAddressAction.retry() = _Retry;
  const factory EditPropertyAddressAction.saveDetail() = _SaveDetail;
  const factory EditPropertyAddressAction.saveAddress() = _SaveAddress;
  const factory EditPropertyAddressAction.clearError() = _ClearError;
}

class _Search extends EditPropertyAddressAction {
  final String query;

  const _Search(this.query);
}

class _LoadMore extends EditPropertyAddressAction {
  const _LoadMore();
}

class _Select extends EditPropertyAddressAction {
  final AddressResultViewState address;

  const _Select(this.address);
}

class _InputDetail extends EditPropertyAddressAction {
  final String detailAddress;

  const _InputDetail(this.detailAddress);
}

class _ResetAddress extends EditPropertyAddressAction {
  const _ResetAddress();
}

class _Retry extends EditPropertyAddressAction {
  const _Retry();
}

class _SaveDetail extends EditPropertyAddressAction {
  const _SaveDetail();
}

class _SaveAddress extends EditPropertyAddressAction {
  const _SaveAddress();
}

class _ClearError extends EditPropertyAddressAction {
  const _ClearError();
}

class EditPropertyAddressVM extends Notifier<EditPropertyAddressViewState> {
  EditPropertyAddressVM(this.id);

  static const _debounceDuration = Duration(milliseconds: 500);
  static const _errorMessage = '주소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
  static const _locateErrorMessage = '주소 위치를 찾지 못했어요. 다시 입력해 주세요.';
  static const _saveErrorMessage = '주소를 저장하지 못했어요. 다시 시도해 주세요.';

  final String id;
  Timer? _debounce;
  int _requestId = 0;

  @override
  EditPropertyAddressViewState build() {
    final currentAddress = ref.read(editPropertyVMProvider(id)).address;

    ref.onDispose(_cancelSearch);
    return EditPropertyAddressViewState(currentAddress: currentAddress, detailAddress: currentAddress?.detailAddress ?? '');
  }

  void action(EditPropertyAddressAction action) {
    switch (action) {
      case _InputDetail(:final detailAddress):
        state = state.copyWith(detailAddress: detailAddress);

      case _ResetAddress():
        state = state.copyWith(step: EditPropertyAddressStep.search);

      case _Search(:final query):
        const minQueryLength = 3;
        final requestId = _cancelSearch();

        if (query.trim().length < minQueryLength) {
          state = state.copyWith(query: query, results: const [], isSearching: false, isLoading: false, page: 0, totalCount: 0);
          return;
        }
        state = state.copyWith(query: query, isSearching: true, isLoading: false);
        _debounce = Timer(_debounceDuration, () => _fetch(query, requestId));

      case _LoadMore():
        if (state.isSearching || state.isLoading || !state.hasMore) { return; }

        state = state.copyWith(isLoading: true);
        _fetchNextPage(state.query, state.page + 1, _requestId);

      case _Select(:final address):
        final requestId = _cancelSearch();

        state = state.copyWith(
          step: EditPropertyAddressStep.confirm,
          isSearching: false,
          isLoading: false,
          selected: () => address,
          located: () => null,
          detailAddress: '',
          isLocating: true,
        );
        _locate(address, requestId);

      case _Retry():
        _cancelSearch();
        state = state.copyWith(
          step: EditPropertyAddressStep.search,
          selected: () => null,
          located: () => null,
          detailAddress: '',
          isLocating: false,
        );

      case _SaveDetail():
        final currentAddress = state.currentAddress;

        if (currentAddress == null) { return; }

        _save(currentAddress.copyWith(detailAddress: state.detailAddress.trim()));

      case _SaveAddress():
        final located = state.located;

        if (located == null) { return; }

        _save(located.copyWith(detailAddress: state.detailAddress.trim()));

      case _ClearError():
        state = state.copyWith(errorMessage: () => null);
    }
  }

  void consumeCompleted() {
    state = state.copyWith(isCompleted: false);
  }

  Future<void> _save(Address address) async {
    if (state.isSaving) { return; }

    state = state.copyWith(isSaving: true);

    final isSaved = await ref.read(editPropertyVMProvider(id).notifier).saveAddress(address);

    if (!ref.mounted) { return; }

    state = isSaved
        ? state.copyWith(isSaving: false, isCompleted: true)
        : state.copyWith(isSaving: false, errorMessage: () => _saveErrorMessage);
  }

  int _cancelSearch() {
    _debounce?.cancel();
    return ++_requestId;
  }

  Future<void> _fetch(String query, int requestId) async {
    try {
      final result = await ref.read(addressUseCaseProvider).search(query);

      if (requestId != _requestId) { return; }

      state = state.copyWith(
        results: [for (final address in result.addresses) AddressResultViewState.fromDomain(address)],
        isSearching: false,
        page: 1,
        totalCount: result.totalCount,
      );
    } on ApiException {
      if (requestId != _requestId) { return; }

      state = state.copyWith(
        results: const [],
        isSearching: false,
        page: 0,
        totalCount: 0,
        errorMessage: () => _errorMessage,
      );
    }
  }

  Future<void> _fetchNextPage(String query, int page, int requestId) async {
    try {
      final result = await ref.read(addressUseCaseProvider).search(query, page: page);

      if (requestId != _requestId) { return; }

      state = state.copyWith(
        results: [...state.results, for (final address in result.addresses) AddressResultViewState.fromDomain(address)],
        isLoading: false,
        page: page,
        totalCount: result.addresses.isEmpty ? state.results.length : result.totalCount,
      );
    } on ApiException {
      if (requestId != _requestId) { return; }

      state = state.copyWith(isLoading: false, errorMessage: () => _errorMessage);
    }
  }

  Future<void> _locate(AddressResultViewState address, int requestId) async {
    try {
      final located = await ref.read(addressUseCaseProvider).locate(address.source);

      if (requestId != _requestId) { return; }

      state = state.copyWith(
        located: () => located,
        isLocating: false,
        errorMessage: located == null ? () => _locateErrorMessage : null,
      );
    } on ApiException {
      if (requestId != _requestId) { return; }

      state = state.copyWith(isLocating: false, errorMessage: () => _locateErrorMessage);
    }
  }
}
