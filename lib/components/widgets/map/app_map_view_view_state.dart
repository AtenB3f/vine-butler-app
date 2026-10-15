class AppMapViewViewState {
  final double latitude;
  final double longitude;
  final double zoom;
  final String clientId;
  final String webServiceUrl;

  const AppMapViewViewState({
    required this.clientId,
    required this.webServiceUrl,
    required this.latitude,
    required this.longitude,
    this.zoom = 16,
  });
}
