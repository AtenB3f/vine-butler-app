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
import 'package:vine_butler/domain/repository/location_repository.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/features/map/map_vm.dart';
import 'package:vine_butler/features/map/presentation/map_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

class _FakeLocationRepository implements LocationRepository {
  final Completer<({double latitude, double longitude})?> completer = Completer();

  bool isDenied = false;
  int openSettingsCount = 0;

  @override
  Future<({double latitude, double longitude})?> current() => completer.future;

  @override
  Future<bool> isPermanentlyDenied() async => isDenied;

  @override
  Future<void> openSettings() async => openSettingsCount++;
}

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

Property _property(String id, PropertyDeal deal, {String detailAddress = '', double latitude = 37.5006, double longitude = 127.0364}) {
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
      latitude: latitude,
      longitude: longitude,
    ),
    updatedAt: DateTime(2020),
  );
}

const _rent = PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000);
const _depositOnly = PropertyDeal(transactionType: PropertyTransactionType.depositOnly, price: 300000000);
const _buy = PropertyDeal(transactionType: PropertyTransactionType.buy, price: 1200000000);

void main() {
  late _FakePropertyRepository repository;
  late _FakeLocationRepository location;
  late ProviderContainer container;

  MapViewState state() => container.read(mapVMProvider);
  void action(MapAction action) => container.read(mapVMProvider.notifier).action(action);

  Future<void> emit(List<Property> properties) async {
    repository.controller.add(properties);
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() {
    repository = _FakePropertyRepository();
    location = _FakeLocationRepository()..completer.complete(null);
    container = ProviderContainer(
      overrides: [
        propertyRepositoryProvider.overrideWithValue(repository),
        locationRepositoryProvider.overrideWithValue(location),
      ],
    );
    container.listen(mapVMProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('매물 목록을 처음 받기 전에는 불러오지 않은 상태이고, 빈 목록이라도 받으면 불러온 상태가 된다', () async {
    expect(state().isLoaded, isFalse);

    await emit([]);

    expect(state().isLoaded, isTrue);
    expect(state().markers, isEmpty);
  });

  group('현재 위치', () {
    late _FakeLocationRepository pending;

    setUp(() {
      container.dispose();
      pending = _FakeLocationRepository();
      container = ProviderContainer(
        overrides: [
          propertyRepositoryProvider.overrideWithValue(repository),
          locationRepositoryProvider.overrideWithValue(pending),
        ],
      );
      container.listen(mapVMProvider, (_, _) {});
    });

    test('가장 가까운 매물이 1km보다 멀면 그 위치를 첫 카메라에 함께 보여줄 위치로 둔다', () async {
      pending.completer.complete((latitude: 37.5666, longitude: 126.9784));
      await emit([
        _property('far', _rent, latitude: 37.4, longitude: 127.2),
        _property('near', _rent),
      ]);

      expect(state().isLoaded, isTrue);
      expect(state().nearbyLocation, (latitude: 37.5006, longitude: 127.0364));
    });

    test('1km 안에 매물이 있으면 함께 보여줄 위치가 없다', () async {
      pending.completer.complete((latitude: 37.5010, longitude: 127.0364));
      await emit([_property('near', _rent)]);

      expect(state().isLoaded, isTrue);
      expect(state().nearbyLocation, isNull);
    });

    test('내 위치 버튼을 누르면 함께 보여줄 위치를 비운다', () async {
      pending.completer.complete((latitude: 37.5666, longitude: 126.9784));
      await emit([_property('near', _rent)]);

      expect(state().nearbyLocation, isNotNull);

      action(const MapAction.locate());
      await Future<void>.delayed(Duration.zero);

      expect(state().nearbyLocation, isNull);
    });

    test('매물 목록과 현재 위치를 모두 받아야 불러온 상태가 된다', () async {
      await emit([]);

      expect(state().isLoaded, isFalse);

      pending.completer.complete((latitude: 37.5, longitude: 127.0));
      await Future<void>.delayed(Duration.zero);

      expect(state().isLoaded, isTrue);
      expect(state().userLocation, (latitude: 37.5, longitude: 127.0));
    });

    test('내 위치 버튼을 누르면 위치를 갱신하고 카메라 이동을 요청한다', () async {
      pending.completer.complete((latitude: 37.5, longitude: 127.0));
      await Future<void>.delayed(Duration.zero);

      action(const MapAction.locate());
      await Future<void>.delayed(Duration.zero);

      expect(state().userLocation, (latitude: 37.5, longitude: 127.0));
      expect(state().cameraRequestId, 1);
    });

    test('내 위치 버튼을 눌러도 위치를 못 얻으면 카메라 이동을 요청하지 않는다', () async {
      pending.completer.complete(null);
      await Future<void>.delayed(Duration.zero);

      action(const MapAction.locate());
      await Future<void>.delayed(Duration.zero);

      expect(state().cameraRequestId, 0);
      expect(state().event, isNull);
    });

    test('다시 묻지 않음으로 거부된 상태면 설정 팝업 이벤트를 보내고, 소비하면 비운다', () async {
      pending
        ..isDenied = true
        ..completer.complete(null);
      await Future<void>.delayed(Duration.zero);

      action(const MapAction.locate());
      await Future<void>.delayed(Duration.zero);

      expect(state().event, MapEvent.locationPermission);
      expect(state().cameraRequestId, 0);

      action(const MapAction.consumeEvent());

      expect(state().event, isNull);
    });

    test('설정 열기를 누르면 앱 설정 화면을 연다', () {
      action(const MapAction.openSettings());

      expect(pending.openSettingsCount, 1);
    });

    test('현재 위치를 못 얻으면 위치 없이 불러온 상태가 된다', () async {
      pending.completer.complete(null);
      await Future<void>.delayed(Duration.zero);

      expect(state().isLoaded, isFalse);

      await emit([]);

      expect(state().isLoaded, isTrue);
      expect(state().userLocation, isNull);
    });
  });

  test('매물마다 좌표와 가격 라벨, 거래 유형별 라벨 색의 마커를 만든다', () async {
    await emit([_property('rent', _rent), _property('deposit', _depositOnly), _property('buy', _buy)]);

    final markers = state().markers;

    expect(markers.map((marker) => marker.id), ['rent', 'deposit', 'buy']);
    expect(markers.map((marker) => marker.label), ['1,000만원 | 50만원', '3억원', '12억원']);
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

  group('zoom별 마커 개수', () {
    final properties = [for (var i = 0; i < 25; i++) _property('p$i', _rent, latitude: 37.50 + i * 0.01, longitude: 127.0)];

    NaverMapCamera camera(double zoom) => NaverMapCamera(
          center: (latitude: 37.50, longitude: 127.0),
          zoom: zoom,
          southWest: (latitude: 37.50, longitude: 126.99),
          northEast: (latitude: 37.525, longitude: 127.01),
        );

    NaverMapCamera wideCamera(double zoom) => NaverMapCamera(
          center: (latitude: 37.50, longitude: 127.0),
          zoom: zoom,
          southWest: (latitude: 37.0, longitude: 126.5),
          northEast: (latitude: 38.0, longitude: 127.5),
        );

    List<String> markerIds() => state().markers.map((marker) => marker.id).toList();
    List<String> nearest(int count) => [for (var i = 0; i < count; i++) 'p$i'];

    test('카메라 정보를 받기 전에는 전체 마커를 올린다', () async {
      await emit(properties);

      expect(markerIds(), hasLength(25));
    });

    test('화면 범위를 상하좌우 50% 넓힌 영역 안의 매물만 올린다', () async {
      await emit(properties);

      action(MapAction.camera(camera(16)));

      expect(markerIds(), ['p0', 'p1', 'p2', 'p3']);
    });

    test('범위 안 매물이 zoom별 상한을 넘으면 카메라 중심에서 가까운 순으로 상한만큼 올린다', () async {
      await emit(properties);

      action(MapAction.camera(wideCamera(9.5)));

      expect(markerIds(), nearest(10));

      action(MapAction.camera(wideCamera(12)));

      expect(markerIds(), nearest(15));

      action(MapAction.camera(wideCamera(14)));

      expect(markerIds(), nearest(20));

      action(MapAction.camera(wideCamera(15)));

      expect(markerIds(), hasLength(25));
    });

    test('카메라 중심과 거리가 같으면 목록 순서(금액 가까운 순)대로 상한만큼 올린다', () async {
      await emit([for (var i = 0; i < 12; i++) _property('same$i', _rent, latitude: 37.51, longitude: 127.0)]);

      action(MapAction.camera(wideCamera(9.5)));

      expect(markerIds(), [for (var i = 0; i < 10; i++) 'same$i']);
    });

    test('선택한 매물은 범위 밖이어도 마커를 유지하고, 선택을 해제하면 뺀다', () async {
      await emit(properties);
      action(MapAction.camera(camera(12)));

      action(const MapAction.select('p24'));

      expect(markerIds(), ['p0', 'p1', 'p2', 'p3', 'p24']);

      action(const MapAction.clear());

      expect(markerIds(), ['p0', 'p1', 'p2', 'p3']);
    });

    test('내 위치 없이 매물 구성이 바뀌면 전체 마커를 올리고 카메라 이동을 요청한다', () async {
      await emit(properties);
      action(MapAction.camera(camera(12)));

      await emit([...properties, _property('new', _buy, latitude: 37.60)]);

      expect(markerIds(), hasLength(26));
      expect(state().cameraRequestId, 1);
    });
  });
}
