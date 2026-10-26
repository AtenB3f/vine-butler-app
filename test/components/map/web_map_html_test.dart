import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/map/web_map_html.dart';

const _pins = (enable: '<svg id="enable"></svg>', disable: '<svg id="disable"></svg>');

void main() {
  group('handleMapMessage', () {
    late List<String> calls;

    void handle(String message) => handleMapMessage(
          message,
          onMarkerTap: (id) => calls.add('marker $id'),
          onMapTap: () => calls.add('map'),
          onReady: () => calls.add('ready'),
        );

    setUp(() => calls = []);

    test('marker 접두어면 마커 id로 마커 클릭을 알린다', () {
      handle('marker:a1');

      expect(calls, ['marker a1']);
    });

    test('map이면 지도 클릭을 알린다', () {
      handle('map');

      expect(calls, ['map']);
    });

    test('ready면 지도 준비 완료를 알린다', () {
      handle('ready');

      expect(calls, ['ready']);
    });

    test('알 수 없는 메시지는 무시한다', () {
      handle('');
      handle('unknown');

      expect(calls, isEmpty);
    });
  });

  group('webMapHtml', () {
    const marker = NaverMarkerViewState(
      id: 'a1',
      latitude: 37.5,
      longitude: 127.0,
      label: '<script>alert(1)</script>',
      backgroundColor: PrimaryColor.light,
      borderColor: PrimaryColor.dark,
    );

    String html({List<NaverMarkerViewState> markers = const []}) => webMapHtml(
          NaverMapViewState(clientId: 'client', webServiceUrl: 'https://example.com', cameraLocation: (latitude: 37.5, longitude: 127.0), markers: markers),
          _pins,
        );

    test('마커 클릭·지도 클릭·준비 완료 메시지를 보낸다', () {
      final result = html(markers: [marker]);

      expect(result, contains("send('marker:' + item.id)"));
      expect(result, contains("send('map')"));
      expect(result, contains("naver.maps.Event.once(map, 'init', function () { send('ready'); });"));
    });

    test('마커 데이터는 JSON으로, 색은 헥사 코드로 넣는다', () {
      final result = html(markers: [marker]);

      expect(result, contains('"id":"a1"'));
      expect(result, contains('"background":"#cbceff"'));
      expect(result, contains('"border":"#7446ff"'));
    });

    test('라벨에 </script>가 있어도 스크립트가 끊기지 않고 textContent로 넣는다', () {
      final result = html(markers: [marker]);

      expect(result, isNot(contains('<script>alert(1)</script>')));
      expect(result, contains(r'\u003cscript>alert(1)\u003c/script>'));
      expect(result, contains('label.textContent = item.label;'));
    });

    test('선택 스크립트는 id를 문자열로 넘기고 선택이 없으면 빈 문자열을 넘긴다', () {
      expect(selectMarkerScript('a1'), 'select("a1");');
      expect(selectMarkerScript(null), 'select("");');
    });
  });
}
