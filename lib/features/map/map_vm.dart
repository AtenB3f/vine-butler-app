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

sealed class MapAction {
  const MapAction();

  const factory MapAction.select(String id) = _Select;
  const factory MapAction.clear() = _Clear;
  const factory MapAction.search(String query) = _Search;
  const factory MapAction.panel(bool isPresented) = _Panel;
  const factory MapAction.filtering(PropertyFilterData data) = _Filtering;
  const factory MapAction.locate() = _Locate;
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

class _OpenSettings extends MapAction {
  const _OpenSettings();
}

class _ConsumeEvent extends MapAction {
  const _ConsumeEvent();
}

class MapVM extends Notifier<MapViewState> {
  List<Property> _properties = const [];
  StreamSubscription<List<Property>>? _subscription;
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
          selected: () => _card(id),
          status: PropertySearchStatus.select,
        );

      case _Clear():
        state = state.copyWith(selected: () => null);

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

  void _update(List<Property> properties) {
    final selectedId = state.selected?.id;

    _properties = properties;
    _isPropertyLoaded = true;
    state = state.copyWith(
      markers: properties.map(_marker).toList(),
      selected: () => selectedId == null ? null : _card(selectedId),
      searchResults: state.query.isEmpty
          ? const []
          : properties.take(MapViewState.maxPanelResultCount).map(PropertyListItemViewState.fromDomain).toList(),
    );
    _completeLoad();
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
