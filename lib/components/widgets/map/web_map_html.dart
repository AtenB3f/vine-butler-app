import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/map/map_pin_spec.dart';

typedef PinSvgs = ({String enable, String disable});

Future<PinSvgs> loadPinSvgs() async {
  final svgs = await Future.wait([rootBundle.loadString(PinSpec.enableAsset), rootBundle.loadString(PinSpec.disableAsset)]);

  return (enable: svgs[0], disable: svgs[1]);
}

/// 지도 HTML에서 Flutter로 메시지를 보내는 JavaScript 채널 이름 (macOS `webview_flutter`)
const String mapChannel = 'VineButler';

/// 지도 HTML이 보낸 메시지 처리 함수
///
/// - `marker:<id>`: 마커 클릭
/// - `map`: 지도 빈 곳 클릭
/// - `ready`: 지도 초기화 완료 (`naver.maps` 지도 `init` 이벤트)
/// - 그 외: 무시
void handleMapMessage(String message, {ValueChanged<String>? onMarkerTap, VoidCallback? onMapTap, VoidCallback? onReady}) {
  const markerPrefix = 'marker:';

  if (message.startsWith(markerPrefix)) {
    onMarkerTap?.call(message.substring(markerPrefix.length));
  } else if (message == 'map') {
    onMapTap?.call();
  } else if (message == 'ready') {
    onReady?.call();
  }
}

/// 데스크톱 WebView 지도 라벨용 Pretendard 웹폰트 (orioncactus/pretendard 공식 배포, jsDelivr CDN)
const String pretendardCss = 'https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css';

/// HTML `<script>` 안에 넣을 JSON 문자열
///
/// - `jsonEncode`는 `<`를 그대로 두므로 값에 `</script>`가 있으면 스크립트가 끊김 → `<`를 `\u003c`로 바꿈 (JSON·JS 문자열에서 같은 글자)
String _scriptJson(Object? value) => jsonEncode(value).replaceAll('<', r'\u003c');

String selectMarkerScript(String? id) => 'select(${jsonEncode(id ?? '')});';

/// NAVER Maps JavaScript API v3로 지도와 마커를 띄우는 HTML
///
/// - `ncpKeyId`: NCP Maps Application의 Client ID
/// - `navermap_authFailure`: 인증 실패 시 JS API가 호출하는 전역 함수
/// - `VineButler.postMessage`: macOS `webview_flutter` 채널, `window.chrome.webview.postMessage`: Windows WebView2 채널
/// - `markers`가 비어 있으면 지도 중심에 기본 마커 하나, 있으면 라벨+핀 마커들을 그리고 모두 보이게 범위를 맞춤
/// - `select(id)`: 선택된 마커 ID
/// - 마커 클릭은 라벨+핀 DOM 요소에 직접 등록
/// - `pointer-events`: 라벨 박스와 핀 모양(SVG path·circle)만 클릭을 받고, 마커 안 빈 공간은 지도와 뒤의 마커로 통과
/// - `lastMarkerClick`: 마커 클릭 직후 지도 클릭 이벤트가 같이 오면 무시하기 위한 시각
String webMapHtml(NaverMapViewState viewState, PinSvgs pins) {
  final position = '${viewState.latitude}, ${viewState.longitude}';
  final markers = _scriptJson([
    for (final marker in viewState.markers)
      {
        'id': marker.id,
        'lat': marker.latitude,
        'lng': marker.longitude,
        'label': marker.label,
        'background': marker.backgroundColor.hexCode,
        'border': marker.borderColor.hexCode,
      },
  ]);

  return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
<style>
html, body, #map { margin: 0; width: 100%; height: 100%; background: #EFEFEF; }
.marker { display: flex; flex-direction: column; align-items: center; gap: ${PinSpec.labelGap}px; transform: translate(-50%, calc(-100% + ${PinSpec.size - PinSpec.tipY}px)); pointer-events: none; }
.label { pointer-events: auto; cursor: pointer; padding: 4px 10px; border: 1px solid; border-radius: 4px; color: #111111; font-family: 'Pretendard', sans-serif; font-size: 18px; font-weight: 500; line-height: 26px; letter-spacing: -0.0025em; white-space: nowrap; }
.pin { width: ${PinSpec.size}px; height: ${PinSpec.size}px; }
.pin svg { display: block; }
.pin svg path, .pin svg circle { pointer-events: visiblePainted; cursor: pointer; }
.pin .enable, .marker.selected .pin .disable { display: none; }
.marker.selected .pin .enable { display: block; }
</style>
<link rel="stylesheet" href="$pretendardCss">
<script src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${viewState.clientId}"></script>
</head>
<body>
<div id="map"></div>
<script>
window.navermap_authFailure = function () { console.log('[MAP] auth failed'); };

function send(message) {
  if (window.$mapChannel) { $mapChannel.postMessage(message); }
  else if (window.chrome && window.chrome.webview) { window.chrome.webview.postMessage(message); }
}

var pinEnable = ${_scriptJson(pins.enable)};
var pinDisable = ${_scriptJson(pins.disable)};
var position = new naver.maps.LatLng($position);
var map = new naver.maps.Map('map', { center: position, zoom: ${viewState.zoom.round()} });
var markers = $markers;
var elements = {};
var overlays = {};
var bounds = null;
var lastMarkerClick = 0;

function select(id) {
  Object.keys(elements).forEach(function (key) {
    elements[key].classList.toggle('selected', key === id);
    overlays[key].setZIndex(key === id ? 1 : 0);
  });
}

markers.forEach(function (item) {
  var latLng = new naver.maps.LatLng(item.lat, item.lng);
  var element = document.createElement('div');
  var label = document.createElement('div');
  var pin = document.createElement('div');

  element.className = 'marker';
  label.className = 'label';
  label.style.background = item.background;
  label.style.borderColor = item.border;
  label.textContent = item.label;
  pin.className = 'pin';
  pin.innerHTML = '<div class="enable">' + pinEnable + '</div><div class="disable">' + pinDisable + '</div>';
  element.appendChild(label);
  element.appendChild(pin);

  var marker = new naver.maps.Marker({ position: latLng, map: map, icon: { content: element, anchor: new naver.maps.Point(0, 0) } });

  element.addEventListener('click', function (event) {
    event.stopPropagation();
    lastMarkerClick = Date.now();
    send('marker:' + item.id);
  });
  if (marker.getElement) { marker.getElement().style.pointerEvents = 'none'; }
  elements[item.id] = element;
  overlays[item.id] = marker;
  bounds = bounds ? bounds.extend(latLng) : new naver.maps.LatLngBounds(latLng, latLng);
});

if (markers.length === 0) { new naver.maps.Marker({ position: position, map: map }); }
if (markers.length === 1) { map.setCenter(bounds.getCenter()); }
if (markers.length > 1) { map.fitBounds(bounds, { top: 60, right: 60, bottom: 60, left: 60 }); }

naver.maps.Event.once(map, 'init', function () { send('ready'); });

naver.maps.Event.addListener(map, 'click', function () {
  if (Date.now() - lastMarkerClick > 300) { send('map'); }
});
</script>
</body>
</html>
''';
}
