import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_item_view_state.dart';

enum MapEvent {
  locationPermission
}

class MapViewState {
  static const double defaultLatitude = 37.5666;
  static const double defaultLongitude = 126.9784;
  static const double defaultZoom = 11;
  static const double userLocationZoom = 14;
  static const int maxPanelResultCount = 5;

  final List<NaverMarkerViewState> markers;
  final MapPropertyCardViewState? selected;
  final String query;
  final PropertySearchStatus status;
  final PropertyFilterData filter;
  final List<PropertyListItemViewState> searchResults;
  final ({double latitude, double longitude})? userLocation;
  final int cameraRequestId;
  final bool isLoaded;
  final MapEvent? event;

  const MapViewState({
    this.markers = const [],
    this.selected,
    this.query = '',
    this.status = PropertySearchStatus.close,
    this.filter = const PropertyFilterData(),
    this.searchResults = const [],
    this.userLocation,
    this.cameraRequestId = 0,
    this.isLoaded = false,
    this.event,
  });

  AppBndSearchStatus get bndStatus => status.bndStatus(query: query, isFilterApplied: filter.isApplied);

  MapViewState copyWith({
    List<NaverMarkerViewState>? markers,
    MapPropertyCardViewState? Function()? selected,
    String? query,
    PropertySearchStatus? status,
    PropertyFilterData? filter,
    List<PropertyListItemViewState>? searchResults,
    ({double latitude, double longitude})? Function()? userLocation,
    int? cameraRequestId,
    bool? isLoaded,
    MapEvent? Function()? event,
  }) {
    return MapViewState(
      markers: markers ?? this.markers,
      selected: selected != null ? selected() : this.selected,
      query: query ?? this.query,
      status: status ?? this.status,
      filter: filter ?? this.filter,
      searchResults: searchResults ?? this.searchResults,
      userLocation: userLocation != null ? userLocation() : this.userLocation,
      cameraRequestId: cameraRequestId ?? this.cameraRequestId,
      isLoaded: isLoaded ?? this.isLoaded,
      event: event != null ? event() : this.event,
    );
  }
}
