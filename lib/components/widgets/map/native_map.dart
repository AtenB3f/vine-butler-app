import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/map/map_loading.dart';
import 'package:vine_butler/components/widgets/map/map_pin_spec.dart';

class NativeMap extends StatefulWidget {
  final NaverMapViewState viewState;
  final ValueChanged<String>? onMarkerTap;
  final VoidCallback? onMapTap;

  const NativeMap({super.key, required this.viewState, this.onMarkerTap, this.onMapTap});

  @override
  State<NativeMap> createState() => _NativeMapState();
}

class _NativeMapState extends State<NativeMap> {
  static const EdgeInsets _boundsPadding = EdgeInsets.all(60);
  static const int _defaultZIndex = 0;
  static const int _selectedZIndex = 1;

  final Map<String, NMarker> _markers = {};
  final Map<String, ({NOverlayImage enable, NOverlayImage disable})> _images = {};
  NaverMapController? _controller;
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

    final isMarkerChanged = !listEquals(old.markers, current.markers);
    final isPointChanged = current.userLocation == null && !listEquals(_points(old.markers), _points(current.markers));
    final isCameraChanged = isPointChanged ||
        old.userLocation != current.userLocation ||
        old.cameraLocation != current.cameraLocation ||
        old.zoom != current.zoom ||
        old.isLoaded != current.isLoaded ||
        old.cameraRequestId != current.cameraRequestId;

    if (isMarkerChanged) { _updateMarkers(); }
    if (old.userLocation != current.userLocation) { _showUserLocation(); }
    if (isCameraChanged) { _moveCamera(); }
    if (!isMarkerChanged && old.selectedMarkerId != current.selectedMarkerId) { _select(old.selectedMarkerId, current.selectedMarkerId); }
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
      await controller.addOverlay(NMarker(id: 'position', position: _position));
      return;
    }

    final pins = _pins ??= (
      enable: await vg.loadPicture(const SvgAssetLoader(PinSpec.enableAsset), null),
      disable: await vg.loadPicture(const SvgAssetLoader(PinSpec.disableAsset), null),
    );
    final markerOverlays = <String, NMarker>{};
    final images = <String, ({NOverlayImage enable, NOverlayImage disable})>{};

    for (final marker in markers) {
      final enable = await _markerImage(marker, pins.enable.picture, 'enable', pixelRatio, textScaler);
      final disable = await _markerImage(marker, pins.disable.picture, 'disable', pixelRatio, textScaler);

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
    await controller.clearOverlays(type: NOverlayType.marker);

    if (!mounted || requestId != _markerRequestId) { return; }

    _markers
      ..clear()
      ..addAll(markerOverlays);
    _images
      ..clear()
      ..addAll(images);
    await controller.addOverlayAll(markerOverlays.values.toSet());
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

    final icon = _userLocationIcon ??= await _userLocationImage(MediaQuery.devicePixelRatioOf(context));

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
          onMapReady: (controller) {
            _controller = controller;
            _updateMarkers();
            _showUserLocation();
            _moveCamera();
          },
          onMapLoaded: () {
            if (mounted) { setState(() => _isLoaded = true); }
          },
          onMapTapped: (_, _) => widget.onMapTap?.call(),
        ),
        if (!_isLoaded) const Positioned.fill(child: MapLoading()),
      ],
    );
  }
}

Future<({NOverlayImage image, Size size})> _userLocationImage(double pixelRatio) async {
  const size = Size(58, 58);
  final center = size.center(Offset.zero);
  final recorder = ui.PictureRecorder();

  Paint strokePaint(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
  }

  Canvas(recorder)
    ..scale(pixelRatio)
    ..drawCircle(center, 11, Paint()..color = MainColor.medium..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6))
    ..drawCircle(center, 11, Paint()..color = StateColor.dimmed..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2))
    ..drawCircle(center, 11, Paint()..color = MainColor.medium)
    ..drawCircle(center, 10.5, strokePaint(MainColor.dark))
    ..drawCircle(center, 4.8, Paint()..color = StateColor.white)
    ..drawCircle(center, 4.3, strokePaint(MainColor.dark));

  final image = await recorder.endRecording().toImage((size.width * pixelRatio).ceil(), (size.height * pixelRatio).ceil());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

  image.dispose();
  return (
    image: await NOverlayImage.fromByteArray(bytes!.buffer.asUint8List(), cacheKey: 'user_location_$pixelRatio'),
    size: size,
  );
}

/// 모바일용 매물 마커 이미지 (라벨 + 핀)
Future<({NOverlayImage image, Size size, double tipY})> _markerImage(
  NaverMarkerViewState marker,
  ui.Picture pin,
  String pinState,
  double pixelRatio,
  TextScaler textScaler,
) async {
  final text = TextPainter(
    text: TextSpan(text: marker.label, style: AppFontStyle.sub1.style(TextColor.dark)),
    textDirection: TextDirection.ltr,
    textScaler: textScaler,
  )..layout();
  final labelSize = Size(text.width + 22, text.height + 10);
  final size = Size(
    math.max(labelSize.width, PinSpec.shape.width).ceilToDouble(),
    (labelSize.height + PinSpec.labelGap + PinSpec.shape.height).ceilToDouble(),
  );
  final labelRect = RRect.fromRectAndRadius(
    Rect.fromLTWH((size.width - labelSize.width) / 2 + 0.5, 0.5, labelSize.width - 1, labelSize.height - 1),
    const Radius.circular(4),
  );
  final pinLeft = (size.width - PinSpec.shape.width) / 2;
  final pinTop = labelSize.height + PinSpec.labelGap;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(pixelRatio);

  canvas
    ..drawRRect(labelRect, Paint()..color = marker.backgroundColor)
    ..drawRRect(
      labelRect,
      Paint()
        ..color = marker.borderColor
        ..style = PaintingStyle.stroke,
    );
  text.paint(canvas, Offset((size.width - text.width) / 2, (labelSize.height - text.height) / 2));
  canvas
    ..save()
    ..translate(pinLeft - PinSpec.shape.left, pinTop - PinSpec.shape.top)
    ..drawPicture(pin)
    ..restore();

  final image = await recorder.endRecording().toImage((size.width * pixelRatio).ceil(), (size.height * pixelRatio).ceil());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final cacheKey = [
    marker.id,
    marker.label,
    marker.backgroundColor.toARGB32(),
    marker.borderColor.toARGB32(),
    pinState,
    pixelRatio,
    textScaler.scale(1),
  ].join('_');

  text.dispose();
  image.dispose();
  return (
    image: await NOverlayImage.fromByteArray(bytes!.buffer.asUint8List(), cacheKey: cacheKey),
    size: size,
    tipY: pinTop + PinSpec.tipY - PinSpec.shape.top,
  );
}
