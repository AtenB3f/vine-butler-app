import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/map/map_loading.dart';
import 'package:vine_butler/components/widgets/map/web_map_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MacMap extends StatefulWidget {
  final NaverMapViewState viewState;
  final ValueChanged<String>? onMarkerTap;
  final VoidCallback? onMapTap;

  const MacMap({super.key, required this.viewState, this.onMarkerTap, this.onMapTap});

  @override
  State<MacMap> createState() => _MacMapState();
}

class _MacMapState extends State<MacMap> {
  final WebViewController _controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  PinSvgs? _pins;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller
      ..addJavaScriptChannel(
        mapChannel,
        onMessageReceived: (message) => handleMapMessage(
          message.message,
          onMarkerTap: widget.onMarkerTap,
          onMapTap: widget.onMapTap,
          onReady: _onReady,
        ),
      )
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) => _select()));
    _initialize();
  }

  @override
  void didUpdateWidget(covariant MacMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final pins = _pins;

    if (pins == null) { return; }

    if (webMapHtml(oldWidget.viewState, pins) != webMapHtml(widget.viewState, pins)) {
      _load();
    } else if (oldWidget.viewState.selectedMarkerId != widget.viewState.selectedMarkerId) {
      _select();
    }
  }

  Future<void> _initialize() async {
    final pins = await loadPinSvgs();

    if (!mounted) { return; }

    _pins = pins;
    _load();
  }

  void _load() {
    final pins = _pins;

    if (pins == null) { return; }

    setState(() => _isLoaded = false);
    _controller.loadHtmlString(webMapHtml(widget.viewState, pins), baseUrl: widget.viewState.webServiceUrl);
  }

  void _onReady() {
    if (mounted) { setState(() => _isLoaded = true); }
  }

  void _select() {
    _controller.runJavaScript(selectMarkerScript(widget.viewState.selectedMarkerId));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (!_isLoaded) const Positioned.fill(child: MapLoading()),
      ],
    );
  }
}
