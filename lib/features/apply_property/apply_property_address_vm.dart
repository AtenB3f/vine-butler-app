import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';

final applyPropertyAddressVMProvider =
    NotifierProvider<ApplyPropertyAddressVM, ApplyPropertyAddressViewState>(ApplyPropertyAddressVM.new);

sealed class ApplyPropertyAddressAction {
  const ApplyPropertyAddressAction();

  const factory ApplyPropertyAddressAction.search(String query) = _Search;
  const factory ApplyPropertyAddressAction.select(AddressResultViewState address) = _Select;
  const factory ApplyPropertyAddressAction.next() = _Next;
  const factory ApplyPropertyAddressAction.reset() = _Reset;
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

class ApplyPropertyAddressVM extends Notifier<ApplyPropertyAddressViewState> {
  static const List<AddressResultViewState> _mockAddresses = [
    AddressResultViewState(zipCode: '00000', address: '서울 동작구 장승배기로 70 동작구청', lotAddress: '상도동 123-4'),
    AddressResultViewState(zipCode: '00000', address: '서울 동작구 만양로3길 80 동작구 보건소', lotAddress: '상도동 56-7'),
    AddressResultViewState(zipCode: '00000', address: '서울 동작구 장승배기로 70 3층, 동작구의회', lotAddress: '상도동 123-4'),
    AddressResultViewState(zipCode: '00000', address: '서울 동작구 여의대방로16길 53 동작구민체육센터', lotAddress: '본동 78-9'),
    AddressResultViewState(zipCode: '00000', address: '서울 동작구 성대로2길 5-5 지1층 A-2호', lotAddress: '상도동 21-3'),
    AddressResultViewState(zipCode: '00000', address: '서울 동작구 양녕로25가길 24', lotAddress: '노량진동 45-6'),
    AddressResultViewState(zipCode: '00000', address: '서울 동작구 매봉로 37', lotAddress: '사당동 10-2'),
  ];

  @override
  ApplyPropertyAddressViewState build() => const ApplyPropertyAddressViewState();

  void action(ApplyPropertyAddressAction action) {
    switch (action) {
      case _Search(:final query):
        final keyword = _normalize(query);
        state = ApplyPropertyAddressViewState(
          query: query,
          results: keyword.isEmpty
              ? const []
              : [for (final item in _mockAddresses) if (_normalize(item.address).contains(keyword)) item],
        );
      case _Select(:final address):
        state = state.copyWith(
          results: const [],
          selected: () => address,
        );
      case _Next():
        if (!state.isMapVisible) {
          return;
        }
        state = state.copyWith(navigateTo: () => const ApplyPropertyOwnerRoute().location);
      case _Reset():
        state = const ApplyPropertyAddressViewState();
    }
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: () => null);
  }

  String _normalize(String text) => text.replaceAll(' ', '');
}
