import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/features/map/map_vm.dart';
import 'package:vine_butler/features/map/presentation/map_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

class _FakePropertyRepository implements PropertyRepository {
  final List<PropertySearchCondition> requests = [];
  StreamController<List<Property>> controller = StreamController<List<Property>>();

  @override
  Stream<List<Property>> watchList() => controller.stream;

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) {
    requests.add(condition);
    controller = StreamController<List<Property>>();
    return controller.stream;
  }

  @override
  Future<Property?> getById(String id) async => null;

  @override
  Future<void> save(Property property) async {}

  @override
  Future<void> delete(String id) async {}
}

Property _property(String id, PropertyDeal deal, {String detailAddress = ''}) {
  return Property(
    id: id,
    owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
    propertyType: PropertyType.apartment,
    deal: deal,
    address: Address(
      zipCode: '06236',
      roadAddress: '서울 강남구 테헤란로 1',
      lotAddress: '서울특별시 강남구 역삼동 1-1',
      sido: '서울특별시',
      sigungu: '강남구',
      dongMyeon: '역삼동',
      detailAddress: detailAddress,
      latitude: 37.5006,
      longitude: 127.0364,
    ),
    updatedAt: DateTime(2020),
  );
}

const _rent = PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000);
const _depositOnly = PropertyDeal(transactionType: PropertyTransactionType.depositOnly, price: 300000000);
const _buy = PropertyDeal(transactionType: PropertyTransactionType.buy, price: 1200000000);

void main() {
  late _FakePropertyRepository repository;
  late ProviderContainer container;

  MapViewState state() => container.read(mapVMProvider);
  void action(MapAction action) => container.read(mapVMProvider.notifier).action(action);

  Future<void> emit(List<Property> properties) async {
    repository.controller.add(properties);
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() {
    repository = _FakePropertyRepository();
    container = ProviderContainer(overrides: [propertyRepositoryProvider.overrideWithValue(repository)]);
    container.listen(mapVMProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('매물마다 좌표와 가격 라벨, 거래 유형별 라벨 색의 마커를 만든다', () async {
    await emit([_property('rent', _rent), _property('deposit', _depositOnly), _property('buy', _buy)]);

    final markers = state().markers;

    expect(markers.map((marker) => marker.id), ['rent', 'deposit', 'buy']);
    expect(markers.map((marker) => marker.label), ['1000만원 | 50만원', '3억원', '12억원']);
    expect(markers.map((marker) => marker.backgroundColor), [PrimaryColor.light, SecondaryColor.light, TertiaryColor.light]);
    expect(markers.map((marker) => marker.borderColor), [PrimaryColor.dark, SecondaryColor.dark, TertiaryColor.dark]);
    expect(markers.first.latitude, 37.5006);
    expect(markers.first.longitude, 127.0364);
  });

  test('마커를 선택하면 카드 정보를 만든다', () async {
    await emit([_property('rent', _rent, detailAddress: '202호')]);

    action(const MapAction.select('rent'));

    final selected = state().selected!;

    expect(selected.id, 'rent');
    expect(selected.address, '강남구 역삼동 1-1 202호');
    expect(selected.transactionType, PropertyTransactionType.rent);
    expect(selected.amount, 10000000);
    expect(selected.monthlyAmount, 500000);
  });

  test('상세 주소가 없으면 시/도를 뺀 지번 주소만 쓴다', () async {
    await emit([_property('buy', _buy)]);

    action(const MapAction.select('buy'));

    expect(state().selected!.address, '강남구 역삼동 1-1');
  });

  test('선택을 해제하면 카드가 사라진다', () async {
    await emit([_property('rent', _rent)]);
    action(const MapAction.select('rent'));

    action(const MapAction.clear());

    expect(state().selected, isNull);
  });

  test('선택한 매물이 목록에서 사라지면 선택을 해제한다', () async {
    await emit([_property('rent', _rent), _property('buy', _buy)]);
    action(const MapAction.select('rent'));

    await emit([_property('buy', _buy)]);

    expect(state().selected, isNull);
    expect(state().markers.map((marker) => marker.id), ['buy']);
  });

  test('검색어와 필터로 조건을 바꿔 다시 구독하고 그 결과로 마커를 바꾼다', () async {
    await emit([_property('rent', _rent), _property('buy', _buy)]);

    action(const MapAction.search(' 역삼 '));
    action(const MapAction.filtering(PropertyFilterData(transactionType: PropertyTransactionType.buy, price: 1500000000)));
    await emit([_property('buy', _buy)]);

    expect(
      repository.requests.last,
      const PropertySearchCondition(transactionType: PropertyTransactionType.buy, price: 1500000000, keyword: '역삼'),
    );
    expect(state().markers.map((marker) => marker.id), ['buy']);
    expect(state().bndStatus, AppBndSearchStatus.enable);
  });

  test('검색 결과는 검색어가 있을 때만 최대 5개까지 만든다', () async {
    await emit([for (var i = 0; i < 7; i++) _property('$i', _rent)]);

    expect(state().searchResults, isEmpty);

    action(const MapAction.search('역삼'));
    await emit([for (var i = 0; i < 7; i++) _property('$i', _rent)]);

    expect(state().searchResults.length, MapViewState.maxPanelResultCount);
  });

  test('검색 결과를 고르면 그 매물을 선택하고 패널을 닫는다', () async {
    action(const MapAction.search('역삼'));
    action(const MapAction.panel(true));
    await emit([_property('rent', _rent), _property('buy', _buy)]);

    action(const MapAction.select('buy'));

    expect(state().selected!.id, 'buy');
    expect(state().status, PropertySearchStatus.select);
    expect(state().bndStatus, AppBndSearchStatus.search);
  });

  test('확정한 뒤 검색어를 바꾸면 확정이 풀린다', () async {
    action(const MapAction.search('역삼'));
    await emit([_property('buy', _buy)]);
    action(const MapAction.select('buy'));

    action(const MapAction.search('역삼동'));

    expect(state().status, PropertySearchStatus.close);
    expect(state().bndStatus, AppBndSearchStatus.enable);
  });

  test('필터 결과에서 빠진 선택 매물은 카드를 닫는다', () async {
    await emit([_property('rent', _rent), _property('buy', _buy)]);
    action(const MapAction.select('rent'));

    action(const MapAction.filtering(PropertyFilterData(transactionType: PropertyTransactionType.buy)));
    await emit([_property('buy', _buy)]);

    expect(state().selected, isNull);
    expect(state().bndStatus, AppBndSearchStatus.filter);
  });
}
