import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/exception/api_exception.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';

final applyPropertyAddressVMProvider = NotifierProvider.autoDispose<ApplyPropertyAddressVM, ApplyPropertyAddressViewState>(
  ApplyPropertyAddressVM.new,
);

sealed class ApplyPropertyAddressAction {
  const ApplyPropertyAddressAction();

  const factory ApplyPropertyAddressAction.search(String query) = _Search;
  const factory ApplyPropertyAddressAction.select(AddressResultViewState address) = _Select;
  const factory ApplyPropertyAddressAction.next() = _Next;
  const factory ApplyPropertyAddressAction.reset() = _Reset;
  const factory ApplyPropertyAddressAction.clearError() = _ClearError;
  const factory ApplyPropertyAddressAction.loadMore() = _LoadMore;
  const factory ApplyPropertyAddressAction.inputDetail(String detailAddress) = _InputDetail;
}

class _Search extends ApplyPropertyAddressAction {
  final String query;

  const _Search(this.query);
}

class _Select extends ApplyPropertyAddressAction {
  final AddressResultViewState address;

  const _Select(this.address);
}

class _Next extends ApplyPropertyAddressAction {
  const _Next();
}

class _Reset extends ApplyPropertyAddressAction {
  const _Reset();
}

class _ClearError extends ApplyPropertyAddressAction {
  const _ClearError();
}

class _LoadMore extends ApplyPropertyAddressAction {
  const _LoadMore();
}

class _InputDetail extends ApplyPropertyAddressAction {
  final String detailAddress;

  const _InputDetail(this.detailAddress);
}

class ApplyPropertyAddressVM extends Notifier<ApplyPropertyAddressViewState> {
  static const _debounceDuration = Duration(milliseconds: 500);
  static const _errorMessage = '주소를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
  static const _locateErrorMessage = '주소 위치를 찾지 못했어요. 다시 입력해 주세요.';

  Timer? _debounce;
  int _requestId = 0;

  @override
  ApplyPropertyAddressViewState build() {
    ref.onDispose(_cancelSearch);
    return const ApplyPropertyAddressViewState();
  }

  void action(ApplyPropertyAddressAction action) {
    switch (action) {
      case _Search(:final query):
        const minQueryLength = 3;
        final requestId = _cancelSearch();

        if (query.trim().length < minQueryLength) {
          state = ApplyPropertyAddressViewState(query: query);
          return;
        }
        state = state.copyWith(query: query, isSearching: true, isLoading: false);
        _debounce = Timer(_debounceDuration, () => _fetch(query, requestId));

      case _Select(:final address):
        final requestId = _cancelSearch();

        state = state.copyWith(
          results: const [],
          isSearching: false,
          isLoading: false,
          page: 0,
          totalCount: 0,
          selected: () => address,
          located: () => null,
          detailAddress: '',
          isLocating: true,
        );
        _locate(address, requestId);

      case _Next():
        if (!state.canProceed) { return; }

        state = state.copyWith(navigateTo: () => const ApplyPropertyOwnerRoute().location);

      case _Reset():
        _cancelSearch();
        state = const ApplyPropertyAddressViewState();

      case _ClearError():
        state = state.copyWith(errorMessage: () => null);

      case _LoadMore():
        if (state.isSearching || state.isLoading || !state.hasMore) { return; }

        state = state.copyWith(isLoading: true);
        _fetchNextPage(state.query, state.page + 1, _requestId);

      case _InputDetail(:final detailAddress):
        state = state.copyWith(detailAddress: detailAddress);
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: () => null);
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
