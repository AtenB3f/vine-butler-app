import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';
import 'package:vine_butler/features/map/presentation/map_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_item_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

final mapVMProvider = NotifierProvider<MapVM, MapViewState>(MapVM.new);

class MapVM extends Notifier<MapViewState> {
  List<Property> _properties = const [];
  StreamSubscription<List<Property>>? _subscription;
  NaverMapCamera? _camera;
  bool _isPropertyLoaded = false;
  bool _isLocationLoaded = false;

  @override
  MapViewState build() {
    const initial = MapViewState();
    final isMobile = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;

    ref.onDispose(() => _subscription?.cancel());
    _filtering(initial);
    _isLocationLoaded = !isMobile;

    if (isMobile) { _loadUserLocation(); }

    return initial;
  }

  void action(MapAction action) {
    switch (action) {
      case _Select(:final id):
        state = state.copyWith(
          markers: _markers(selectedId: id),
          selected: () => _card(id),
          status: PropertySearchStatus.select,
        );

      case _Clear():
        state = state.copyWith(markers: _markers(selectedId: null), selected: () => null);

      case _Search(:final query):
        state = state.copyWith(
          query: query,
          status: state.status == PropertySearchStatus.select ? PropertySearchStatus.close : null,
        );
        _filtering(state);

      case _Panel(:final isPresented):
        state = state.copyWith(status: isPresented ? PropertySearchStatus.open : PropertySearchStatus.close);

      case _Filtering(:final data):
        state = state.copyWith(filter: data);
        _filtering(state);

      case _Locate():
        _locate();

      case _Camera(:final camera):
        _camera = camera;
        state = state.copyWith(markers: _markers(selectedId: state.selected?.id));

      case _OpenSettings():
        ref.read(locationRepositoryProvider).openSettings();

      case _ConsumeEvent():
        state = state.copyWith(event: () => null);
    }
  }

  /// 내 위치 버튼
  ///
  /// - 다시 묻지 않음으로 거부된 상태면 설정 이동 팝업 이벤트
  /// - 위치를 받으면 카메라 이동 요청 번호를 올려 지도를 내 위치로 옮김
  Future<void> _locate() async {
    final repository = ref.read(locationRepositoryProvider);

    if (await repository.isPermanentlyDenied()) {
      if (ref.mounted) { state = state.copyWith(event: () => MapEvent.locationPermission); }

      return;
    }

    final location = await repository.current();

    if (!ref.mounted || location == null) { return; }

    state = state.copyWith(
      userLocation: () => location,
      nearbyLocation: () => null,
      cameraRequestId: state.cameraRequestId + 1,
    );
  }

  Future<void> _loadUserLocation() async {
    final location = await ref.read(locationRepositoryProvider).current();

    if (!ref.mounted) { return; }

    _isLocationLoaded = true;
    state = state.copyWith(userLocation: () => location);
    _completeLoad();
  }

  /// 첫 로드 완료 (매물 목록과 내 위치를 모두 받은 순간 한 번)
  ///
  /// - 가장 가까운 매물이 `nearbyDistance`보다 멀면 그 위치를 `nearbyLocation`에 담아 첫 카메라에 함께 보여줌
  void _completeLoad() {
    if (state.isLoaded || !_isPropertyLoaded || !_isLocationLoaded) { return; }

    state = state.copyWith(
      nearbyLocation: () => _nearbyLocation(),
      isLoaded: true,
    );
  }

  ({double latitude, double longitude})? _nearbyLocation() {
    final userLocation = state.userLocation;

    if (userLocation == null || _properties.isEmpty) { return null; }

    final locations = [
      for (final property in _properties) (latitude: property.address.latitude, longitude: property.address.longitude),
    ];
    final nearest = locations.reduce((a, b) => distanceMeters(userLocation, a) <= distanceMeters(userLocation, b) ? a : b);

    return distanceMeters(userLocation, nearest) > MapViewState.nearbyDistance ? nearest : null;
  }

  void _filtering(MapViewState target) {
    final condition = target.filter.toCondition(target.query);

    _subscription?.cancel();
    _subscription = ref.read(propertyUseCaseProvider).watchFilter(condition).listen(_update);
  }

  /// 매물 목록 갱신
  ///
  /// - 내 위치 없이 목록 구성이 바뀌면 전체 마커를 올리고 전체가 보이게 카메라 이동 요청 (카메라가 멈추면 다시 zoom별로 줄임)
  void _update(List<Property> properties) {
    final selectId = state.selected?.id;
    final isUpdate = state.isLoaded && 
        state.userLocation == null &&
        !setEquals({for (final property in _properties) property.id}, {for (final property in properties) property.id});

    _properties = properties;
    _isPropertyLoaded = true;

    final selected = selectId == null ? null : _card(selectId);

    state = state.copyWith(
      markers: isUpdate ? properties.map(_marker).toList() : _markers(selectedId: selected?.id),
      selected: () => selected,
      searchResults: state.query.isEmpty
          ? const []
          : properties.take(MapViewState.maxPanelResultCount).map(PropertyListItemViewState.fromDomain).toList(),
      cameraRequestId: isUpdate ? state.cameraRequestId + 1 : null,
    );
    _completeLoad();
  }

  /// 카메라 zoom에 따라 지도에 올릴 마커
  ///
  /// - 화면 범위의 `boundsMarginRatio`배 만큼 넓힌 영역에서 매물 표기 개수 상한 제한함
  /// - 상한을 넘으면 카메라 중심과 가까운 순, 거리가 같으면 목록 순서(금액 가까운 순 → 최근 수정 순)로 남김
  /// - 선택한 매물은 범위 밖이어도 포함
  List<NaverMarkerViewState> _markers({required String? selectedId}) {
    final camera = _camera;

    if (camera == null || !state.isLoaded) { return _properties.map(_marker).toList(); }

    final visible = _limit(_inBounds(camera), camera);
    final selected = _properties.where((property) => property.id == selectedId && !visible.contains(property));

    return [...visible, ...selected].map(_marker).toList();
  }

  /// zoom Level별 마커 최대 개수
  ///
  /// returns:
  /// - null: 제한 없음
  /// - ~ 9: 10개
  /// - 10 ~ 13: 15개
  /// - 13 ~ 15: 20개
  /// - 15 ~ : 제한 없음
  int? _maxMarkerCount(double zoom) {
    if (zoom < 10) { return 10; }
    if (zoom < 13) { return 15; }
    if (zoom < 15) { return 20; }

    return null;
  }

  List<Property> _limit(List<Property> properties, NaverMapCamera camera) {
    final maxCount = _maxMarkerCount(camera.zoom);

    if (maxCount == null || properties.length <= maxCount) { return properties; }

    final distances = [
      for (final property in properties)
        distanceMeters(camera.center, (latitude: property.address.latitude, longitude: property.address.longitude)),
    ];
    final indexes = [for (var i = 0; i < properties.length; i++) i]
      ..sort((a, b) {
        final compare = distances[a].compareTo(distances[b]);

        return compare != 0 ? compare : a.compareTo(b);
      });

    return [for (final index in indexes.take(maxCount)) properties[index]];
  }

  List<Property> _inBounds(NaverMapCamera camera) {
    final latitudeMargin = (camera.northEast.latitude - camera.southWest.latitude) * MapViewState.boundsMarginRatio;
    final longitudeMargin = (camera.northEast.longitude - camera.southWest.longitude) * MapViewState.boundsMarginRatio;

    return _properties.where((property) {
      final latitude = property.address.latitude;
      final longitude = property.address.longitude;

      return latitude >= camera.southWest.latitude - latitudeMargin &&
          latitude <= camera.northEast.latitude + latitudeMargin &&
          longitude >= camera.southWest.longitude - longitudeMargin &&
          longitude <= camera.northEast.longitude + longitudeMargin;
    }).toList();
  }

  MapPropertyCardViewState? _card(String id) {
    final property = _properties.where((property) => property.id == id).firstOrNull;

    return property == null ? null : MapPropertyCardViewState.fromDomain(property);
  }

  NaverMarkerViewState _marker(Property property) {
    final deal = property.deal;
    final monthlyRent = deal.monthlyRent;

    return NaverMarkerViewState(
      id: property.id,
      latitude: property.address.latitude,
      longitude: property.address.longitude,
      label: monthlyRent == null ? deal.price.formattedKRW : '${deal.price.formattedKRW} | ${monthlyRent.formattedKRW}',
      backgroundColor: switch (deal.transactionType) {
        PropertyTransactionType.rent => PrimaryColor.light,
        PropertyTransactionType.depositOnly => SecondaryColor.light,
        PropertyTransactionType.buy => TertiaryColor.light,
      },
      borderColor: switch (deal.transactionType) {
        PropertyTransactionType.rent => PrimaryColor.dark,
        PropertyTransactionType.depositOnly => SecondaryColor.dark,
        PropertyTransactionType.buy => TertiaryColor.dark,
      },
    );
  }
}

sealed class MapAction {
  const MapAction();

  const factory MapAction.select(String id) = _Select;
  const factory MapAction.clear() = _Clear;
  const factory MapAction.search(String query) = _Search;
  const factory MapAction.panel(bool isPresented) = _Panel;
  const factory MapAction.filtering(PropertyFilterData data) = _Filtering;
  const factory MapAction.locate() = _Locate;
  const factory MapAction.camera(NaverMapCamera camera) = _Camera;
  const factory MapAction.openSettings() = _OpenSettings;
  const factory MapAction.consumeEvent() = _ConsumeEvent;
}

class _Select extends MapAction {
  final String id;

  const _Select(this.id);
}

class _Clear extends MapAction {
  const _Clear();
}

class _Search extends MapAction {
  final String query;

  const _Search(this.query);
}

class _Panel extends MapAction {
  final bool isPresented;

  const _Panel(this.isPresented);
}

class _Filtering extends MapAction {
  final PropertyFilterData data;

  const _Filtering(this.data);
}

class _Locate extends MapAction {
  const _Locate();
}

class _Camera extends MapAction {
  final NaverMapCamera camera;

  const _Camera(this.camera);
}

class _OpenSettings extends MapAction {
  const _OpenSettings();
}

class _ConsumeEvent extends MapAction {
  const _ConsumeEvent();
}
