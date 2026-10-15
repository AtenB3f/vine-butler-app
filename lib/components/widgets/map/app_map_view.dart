import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:vine_butler/components/components.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart';

class AppMapView extends StatelessWidget {
  final AppMapViewViewState viewState;

  const AppMapView({
    super.key,
    required this.viewState,
  });

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => _NativeMap(viewState: viewState),
      TargetPlatform.macOS => _MacWebMap(viewState: viewState),
      TargetPlatform.windows => _WindowsWebMap(viewState: viewState),
      _ => const ColoredBox(color: BaseColor.light),
    };
  }
}

class _NativeMap extends StatefulWidget {
  final AppMapViewViewState viewState;

  const _NativeMap({required this.viewState});

  @override
  State<_NativeMap> createState() => _NativeMapState();
}

class _NativeMapState extends State<_NativeMap> {
  NaverMapController? _controller;

  NLatLng get _position => NLatLng(widget.viewState.latitude, widget.viewState.longitude);

  @override
  void didUpdateWidget(covariant _NativeMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget.viewState;
    final current = widget.viewState;

    if (old.latitude == current.latitude && old.longitude == current.longitude && old.zoom == current.zoom) { return; }

    _showPosition();
  }

  Future<void> _showPosition() async {
    final controller = _controller;

    if (controller == null) { return; }

    await controller.updateCamera(NCameraUpdate.scrollAndZoomTo(target: _position, zoom: widget.viewState.zoom));
    await controller.clearOverlays(type: NOverlayType.marker);
    await controller.addOverlay(NMarker(id: 'position', position: _position));
  }

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      forceGesture: true,
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(target: _position, zoom: widget.viewState.zoom),
      ),
      onMapReady: (controller) {
        _controller = controller;
        controller.addOverlay(NMarker(id: 'position', position: _position));
      },
    );
  }
}

class _MacWebMap extends StatefulWidget {
  final AppMapViewViewState viewState;

  const _MacWebMap({required this.viewState});

  @override
  State<_MacWebMap> createState() => _MacWebMapState();
}

class _MacWebMapState extends State<_MacWebMap> {
  final WebViewController _controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _MacWebMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_mapHtml(oldWidget.viewState) != _mapHtml(widget.viewState)) { _load(); }
  }

  void _load() {
    _controller.loadHtmlString(_mapHtml(widget.viewState), baseUrl: widget.viewState.webServiceUrl);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

class _WindowsWebMap extends StatefulWidget {
  final AppMapViewViewState viewState;

  const _WindowsWebMap({required this.viewState});

  @override
  State<_WindowsWebMap> createState() => _WindowsWebMapState();
}

class _WindowsWebMapState extends State<_WindowsWebMap> {
  final WebviewController _controller = WebviewController();
  Directory? _folder;
  bool _isReady = false;

  String get _host => Uri.parse(widget.viewState.webServiceUrl).host;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant _WindowsWebMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isReady && _mapHtml(oldWidget.viewState) != _mapHtml(widget.viewState)) { _load(); }
  }

  @override
  void dispose() {
    _controller.dispose();
    _folder?.delete(recursive: true);
    super.dispose();
  }

  /// WebView2 런타임이 없으면 지도 대신 회색 박스를 유지
  ///
  /// - `loadStringContent`로 띄우면 출처가 `about:blank`가 되어 JS 지도 인증이 실패함
  /// - 그래서 임시 폴더의 HTML을 Web 서비스 URL 호스트로 매핑해서 띄움 (WebView2 가상 호스트 매핑)
  Future<void> _initialize() async {
    if (await WebviewController.getWebViewVersion() == null) { return; }

    await _controller.initialize();
    _folder = await Directory.systemTemp.createTemp('vine_butler_map');
    await _controller.addVirtualHostNameMapping(_host, _folder!.path, WebviewHostResourceAccessKind.allow);

    if (!mounted) { return; }

    setState(() => _isReady = true);
    await _load();
  }

  Future<void> _load() async {
    final folder = _folder;

    if (folder == null) { return; }

    await File('${folder.path}/index.html').writeAsString(_mapHtml(widget.viewState));
    await _controller.loadUrl('https://$_host/index.html');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) { return const ColoredBox(color: BaseColor.light); }

    return Webview(_controller);
  }
}

/// NAVER Maps JavaScript API v3로 지도와 마커 하나를 띄우는 HTML
///
/// - `ncpKeyId`: NCP Maps Application의 Client ID (2025년 인증 방식 변경 후 파라미터명, 이전 `ncpClientId`)
/// - `navermap_authFailure`: 인증 실패 시 JS API가 호출하는 전역 함수
String _mapHtml(AppMapViewViewState viewState) {
  final position = '${viewState.latitude}, ${viewState.longitude}';

  return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
<style>html, body, #map { margin: 0; width: 100%; height: 100%; background: #EFEFEF; }</style>
<script src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${viewState.clientId}"></script>
</head>
<body>
<div id="map"></div>
<script>
window.navermap_authFailure = function () { console.log('[MAP] auth failed'); };
var position = new naver.maps.LatLng($position);
var map = new naver.maps.Map('map', { center: position, zoom: ${viewState.zoom.round()} });
new naver.maps.Marker({ position: position, map: map });
</script>
</body>
</html>
''';
}
