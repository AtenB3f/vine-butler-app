import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';

final applyPropertyAddressVMProvider =
    NotifierProvider<ApplyPropertyAddressVM, ApplyPropertyAddressViewState>(ApplyPropertyAddressVM.new);

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

  void search(String query) {
    final keyword = _normalize(query);
    state = ApplyPropertyAddressViewState(
      query: query,
      results: keyword.isEmpty
          ? const []
          : [for (final item in _mockAddresses) if (_normalize(item.address).contains(keyword)) item],
    );
  }

  void select(AddressResultViewState address) {
    state = state.copyWith(
      results: const [],
      selected: () => address,
    );
  }

  void next() {
    if (!state.isMapVisible) {
      return;
    }
    state = state.copyWith(navigateTo: () => const ApplyPropertyOwnerRoute().location);
  }

  void popNavigation() {
    state = state.copyWith(navigateTo: () => null);
  }

  void reset() {
    state = const ApplyPropertyAddressViewState();
  }

  String _normalize(String text) => text.replaceAll(' ', '');
}
