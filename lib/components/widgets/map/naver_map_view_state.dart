import 'package:flutter/painting.dart';

class NaverMapViewState {
  final ({double latitude, double longitude}) cameraLocation;
  final ({double latitude, double longitude})? userLocation;
  final double zoom;
  final String clientId;
  final String webServiceUrl;
  final List<NaverMarkerViewState> markers;
  final String? selectedMarkerId;
  final bool isLoaded;
  final int cameraRequestId;

  const NaverMapViewState({
    required this.clientId,
    required this.webServiceUrl,
    required this.cameraLocation,
    this.userLocation,
    this.zoom = 16,
    this.markers = const [],
    this.selectedMarkerId,
    this.isLoaded = true,
    this.cameraRequestId = 0,
  });
}

class NaverMarkerViewState {
  final String id;
  final double latitude;
  final double longitude;
  final String label;
  final Color backgroundColor;
  final Color borderColor;

  const NaverMarkerViewState({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  bool operator ==(Object other) =>
      other is NaverMarkerViewState &&
      other.id == id &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.label == label &&
      other.backgroundColor == backgroundColor &&
      other.borderColor == borderColor;

  @override
  int get hashCode => Object.hash(id, latitude, longitude, label, backgroundColor, borderColor);
}
