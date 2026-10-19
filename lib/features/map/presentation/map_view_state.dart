import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';

class MapViewState {
  static const double defaultLatitude = 37.5666;
  static const double defaultLongitude = 126.9784;
  static const double defaultZoom = 11;

  final List<NaverMarkerViewState> markers;
  final MapPropertyCardViewState? selected;

  const MapViewState({
    this.markers = const [],
    this.selected,
  });

  MapViewState copyWith({
    List<NaverMarkerViewState>? markers,
    MapPropertyCardViewState? Function()? selected,
  }) {
    return MapViewState(
      markers: markers ?? this.markers,
      selected: selected != null ? selected() : this.selected,
    );
  }
}
