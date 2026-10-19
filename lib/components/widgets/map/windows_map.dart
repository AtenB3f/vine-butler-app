import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/map/map_loading.dart';
import 'package:vine_butler/components/widgets/map/web_map_html.dart';
import 'package:webview_windows/webview_windows.dart';

class WindowsMap extends StatefulWidget {
  final NaverMapViewState viewState;
  final ValueChanged<String>? onMarkerTap;
  final VoidCallback? onMapTap;

  const WindowsMap({super.key, required this.viewState, this.onMarkerTap, this.onMapTap});

  @override
  State<WindowsMap> createState() => _WindowsMapState();
}

class _WindowsMapState extends State<WindowsMap> {
  final WebviewController _controller = WebviewController();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Directory? _folder;
  PinSvgs? _pins;
  bool _isReady = false;
  bool _isLoaded = false;
  bool _isUnavailable = false;

  String get _host => Uri.parse(widget.viewState.webServiceUrl).host;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant WindowsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final pins = _pins;

    if (!_isReady || pins == null) { return; }

    if (webMapHtml(oldWidget.viewState, pins) != webMapHtml(widget.viewState, pins)) {
      _load();
    } else if (oldWidget.viewState.selectedMarkerId != widget.viewState.selectedMarkerId) {
      _select();
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _controller.dispose();
    _folder?.delete(recursive: true);
    super.dispose();
  }

  /// WebView2 런타임이 없으면 지도 대신 회색 박스를 유지 (스피너 없이)
  ///
  /// - `loadStringContent`로 띄우면 출처가 `about:blank`가 되어 JS 지도 인증이 실패함
  /// - 그래서 임시 폴더의 HTML을 Web 서비스 URL 호스트로 매핑해서 띄움 (WebView2 가상 호스트 매핑)
  Future<void> _initialize() async {
    if (await WebviewController.getWebViewVersion() == null) {
      if (mounted) { setState(() => _isUnavailable = true); }

      return;
    }

    await _controller.initialize();
    _subscriptions.addAll([
      _controller.webMessage.listen(
        (message) => handleMapMessage('$message', onMarkerTap: widget.onMarkerTap, onMapTap: widget.onMapTap, onReady: _onReady),
      ),
      _controller.loadingState.listen((state) {
        if (state == LoadingState.navigationCompleted) { _select(); }
      }),
    ]);
    _folder = await Directory.systemTemp.createTemp('vine_butler_map');
    _pins = await loadPinSvgs();
    await _controller.addVirtualHostNameMapping(_host, _folder!.path, WebviewHostResourceAccessKind.allow);

    if (!mounted) { return; }

    setState(() => _isReady = true);
    await _load();
  }

  Future<void> _load() async {
    final folder = _folder;
    final pins = _pins;

    if (folder == null || pins == null) { return; }

    setState(() => _isLoaded = false);
    await File('${folder.path}/index.html').writeAsString(webMapHtml(widget.viewState, pins));
    await _controller.loadUrl('https://$_host/index.html');
  }

  void _onReady() {
    if (mounted) { setState(() => _isLoaded = true); }
  }

  void _select() {
    _controller.executeScript(selectMarkerScript(widget.viewState.selectedMarkerId));
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnavailable) { return const ColoredBox(color: BaseColor.light); }
    if (!_isReady) { return const MapLoading(); }

    return Stack(
      children: [
        Webview(_controller),
        if (!_isLoaded) const Positioned.fill(child: MapLoading()),
      ],
    );
  }
}
