import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/shared/utils/utils.dart';

void main() {
  test('같은 좌표는 0m이다', () {
    expect(distanceMeters((latitude: 37.5, longitude: 127.0), (latitude: 37.5, longitude: 127.0)), 0);
  });

  test('위도 1도 차이는 약 111km이다', () {
    expect(distanceMeters((latitude: 37, longitude: 127), (latitude: 38, longitude: 127)), closeTo(111195, 111195 * 0.005));
  });

  test('서울시청과 강남역은 약 8.8km 떨어져 있다', () {
    expect(distanceMeters((latitude: 37.5666, longitude: 126.9784), (latitude: 37.4979, longitude: 127.0276)), closeTo(8800, 8800 * 0.01));
  });
}
