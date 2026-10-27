part of 'native_map.dart';

class _NativeMapState extends State<NativeMap> {
  static const EdgeInsets _boundsPadding = EdgeInsets.all(60);
  static const int _defaultZIndex = 0;
  static const int _selectedZIndex = 1;

  final Map<String, NMarker> _markers = {};
  final Map<String, ({NOverlayImage enable, NOverlayImage disable})> _images = {};
  final Map<String, NaverMarkerViewState> _markerStates = {};
  NaverMapController? _controller;
  String? _selectedId;
  bool _isLoaded = false;
  int _markerRequestId = 0;
  ({PictureInfo enable, PictureInfo disable})? _pins;
  ({NOverlayImage image, Size size})? _userLocationIcon;

  NLatLng get _position => NLatLng(widget.viewState.cameraLocation.latitude, widget.viewState.cameraLocation.longitude);

  @override
  void didUpdateWidget(covariant NativeMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget.viewState;
    final current = widget.viewState;

    final isChangeMarkers = !listEquals(old.markers, current.markers);
    final isChangePoint = widget.onStopCamera == null &&
        current.userLocation == null &&
        !listEquals(_points(old.markers), _points(current.markers));
    final isCameraChanged = isChangePoint ||
        old.userLocation != current.userLocation ||
        old.cameraLocation != current.cameraLocation ||
        old.zoom != current.zoom ||
        old.isLoaded != current.isLoaded ||
        old.cameraRequestId != current.cameraRequestId;

    if (isChangeMarkers) { _updateMarkers(); }
    if (old.userLocation != current.userLocation) { _showUserLocation(); }
    if (isCameraChanged) { _moveCamera(); }
    if (!isChangeMarkers && old.selectedMarkerId != current.selectedMarkerId) { _select(old.selectedMarkerId, current.selectedMarkerId); }
  }

  List<(double, double)> _points(List<NaverMarkerViewState> markers) {
    return [for (final marker in markers) (marker.latitude, marker.longitude)];
  }

  @override
  void dispose() {
    _pins?.enable.picture.dispose();
    _pins?.disable.picture.dispose();
    super.dispose();
  }

  void _select(String? oldId, String? newId) {
    final oldImage = _images[oldId];
    final newImage = _images[newId];

    _selectedId = newId;

    if (oldImage != null) {
      _markers[oldId]
        ?..setIcon(oldImage.disable)
        ..setZIndex(_defaultZIndex);
    }
    if (newImage != null) {
      _markers[newId]
        ?..setIcon(newImage.enable)
        ..setZIndex(_selectedZIndex);
    }
  }

  /// 마커 갱신
  ///
  /// - 이미지를 그리는 동안 더 새로운 갱신이 시작되면(`_markerRequestId` 변경) 중간에 멈추고 마지막 목록만 올림
  /// - 이미 올라간 마커 중 내용이 같은 것은 그대로 두고, 새로 생기거나 바뀐 마커만 그리고 빠진 마커만 지움
  Future<void> _updateMarkers() async {
    final controller = _controller;
    final markers = widget.viewState.markers;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final requestId = ++_markerRequestId;

    if (controller == null) { return; }

    if (markers.isEmpty) {
      await controller.clearOverlays(type: NOverlayType.marker);
      _markers.clear();
      _images.clear();
      _markerStates.clear();
      return;
    }

    final pins = _pins ??= (
      enable: await vg.loadPicture(const SvgAssetLoader(PinSpec.enableAsset), null),
      disable: await vg.loadPicture(const SvgAssetLoader(PinSpec.disableAsset), null),
    );
    final markerOverlays = <String, NMarker>{};
    final images = <String, ({NOverlayImage enable, NOverlayImage disable})>{};

    for (final marker in markers) {
      if (_markerStates[marker.id] == marker) { continue; }

      final enable = await _NativeMapImages.marker(marker, pins.enable.picture, 'enable', pixelRatio, textScaler);
      final disable = await _NativeMapImages.marker(marker, pins.disable.picture, 'disable', pixelRatio, textScaler);

      if (!mounted || requestId != _markerRequestId) { return; }

      final isSelected = marker.id == widget.viewState.selectedMarkerId;
      final overlay = NMarker(
        id: marker.id,
        position: NLatLng(marker.latitude, marker.longitude),
        icon: isSelected ? enable.image : disable.image,
        size: enable.size,
        anchor: NPoint(0.5, enable.tipY / enable.size.height),
      );

      overlay
        ..setZIndex(isSelected ? _selectedZIndex : _defaultZIndex)
        ..setOnTapListener((_) => widget.onMarkerTap?.call(marker.id));
      markerOverlays[marker.id] = overlay;
      images[marker.id] = (enable: enable.image, disable: disable.image);
    }

    final ids = {for (final marker in markers) marker.id};
    final removed = [
      for (final entry in _markers.entries)
        if (!ids.contains(entry.key) || markerOverlays.containsKey(entry.key)) entry.value,
    ];

    _markers.removeWhere((id, _) => !ids.contains(id));
    _images.removeWhere((id, _) => !ids.contains(id));
    _markerStates.removeWhere((id, _) => !ids.contains(id));
    _markers.addAll(markerOverlays);
    _images.addAll(images);
    _markerStates.addAll({for (final marker in markers) marker.id: marker});

    for (final overlay in removed) {
      await controller.deleteOverlay(overlay.info);
    }
    await controller.addOverlayAll(markerOverlays.values.toSet());

    if (mounted && _selectedId != widget.viewState.selectedMarkerId) { _select(_selectedId, widget.viewState.selectedMarkerId); }
  }

  /// 카메라가 멈추면 중심·zoom·화면 범위를 알림
  Future<void> _onStopCamera() async {
    final controller = _controller;

    if (controller == null || widget.onStopCamera == null) { return; }

    final position = await controller.getCameraPosition();
    final bounds = await controller.getContentBounds();

    if (!mounted) { return; }

    widget.onStopCamera?.call(NaverMapCamera(
      center: (latitude: position.target.latitude, longitude: position.target.longitude),
      zoom: position.zoom,
      southWest: (latitude: bounds.southWest.latitude, longitude: bounds.southWest.longitude),
      northEast: (latitude: bounds.northEast.latitude, longitude: bounds.northEast.longitude),
    ));
  }

  /// 카메라 이동
  ///
  /// - 현재 위치가 있으면 현재 위치 중심
  /// - 없으면 매물 전체가 보이게, 매물이 없으면 기본 위치로
  Future<void> _moveCamera() async {
    final controller = _controller;
    final markers = widget.viewState.markers;
    final userLocation = widget.viewState.userLocation;

    if (controller == null || !widget.viewState.isLoaded) { return; }

    if (userLocation != null) {
      await controller.updateCamera(_userCamera(userLocation, widget.viewState.nearbyLocation));
      return;
    }
    if (markers.isEmpty) {
      await controller.updateCamera(NCameraUpdate.scrollAndZoomTo(target: _position, zoom: widget.viewState.zoom));
      return;
    }

    await controller.updateCamera(_fitCamera(markers));
  }

  /// 내 위치 표시
  ///
  /// - 아이콘은 원이 이미지 정가운데라 anchor는 (0.5, 0.5)
  /// - 네이버 기본 방향 아이콘(subIcon)과 정확도 원(circle)은 숨김
  Future<void> _showUserLocation() async {
    final controller = _controller;
    final userLocation = widget.viewState.userLocation;

    if (controller == null) { return; }

    final overlay = controller.getLocationOverlay();

    if (userLocation == null) { return overlay.setIsVisible(false); }

    final icon = _userLocationIcon ??= await _NativeMapImages.userLocation(MediaQuery.devicePixelRatioOf(context));

    if (!mounted) { return; }

    overlay
      ..setIcon(icon.image)
      ..setIconSize(icon.size)
      ..setAnchor(const NPoint(0.5, 0.5))
      ..setSubIcon(null)
      ..setCircleRadius(0)
      ..setPosition(NLatLng(userLocation.latitude, userLocation.longitude))
      ..setIsVisible(true);
  }

  /// 내 위치 중심으로 카메라를 조정하는 함수
  ///
  /// - `nearbyLocation`이 있으면 내 위치를 가운데에 두고 그 위치까지 보이게 대칭 범위로 맞춤
  NCameraUpdate _userCamera(
    ({double latitude, double longitude}) userLocation,
    ({double latitude, double longitude})? nearbyLocation,
  ) {
    final target = NLatLng(userLocation.latitude, userLocation.longitude);

    if (nearbyLocation == null) { return NCameraUpdate.scrollAndZoomTo(target: target, zoom: widget.viewState.zoom); }

    final latitudeDelta = (nearbyLocation.latitude - userLocation.latitude).abs();
    final longitudeDelta = (nearbyLocation.longitude - userLocation.longitude).abs();
    final bounds = NLatLngBounds(
      southWest: NLatLng(userLocation.latitude - latitudeDelta, userLocation.longitude - longitudeDelta),
      northEast: NLatLng(userLocation.latitude + latitudeDelta, userLocation.longitude + longitudeDelta),
    );

    return NCameraUpdate.fitBounds(bounds, padding: _boundsPadding);
  }

  NCameraUpdate _fitCamera(List<NaverMarkerViewState> markers) {
    final points = [for (final marker in markers) NLatLng(marker.latitude, marker.longitude)];

    if (points.length == 1) { return NCameraUpdate.scrollAndZoomTo(target: points.single, zoom: widget.viewState.zoom); }

    return NCameraUpdate.fitBounds(NLatLngBounds.from(points), padding: _boundsPadding);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          forceGesture: true,
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(target: _position, zoom: widget.viewState.zoom),
          ),
          onMapReady: (controller) async {
            await widget.onInit?.call();

            if (!mounted) { return; }

            _controller = controller;
            _updateMarkers();
            _showUserLocation();
            _moveCamera();
          },
          onMapLoaded: () {
            if (mounted) { setState(() => _isLoaded = true); }
          },
          onMapTapped: (_, _) => widget.onMapTap?.call(),
          onCameraIdle: _onStopCamera,
        ),
        if (!_isLoaded) const Positioned.fill(child: MapLoading()),
      ],
    );
  }
}
