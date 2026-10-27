import 'dart:math' as math;

/// 두 좌표 사이 거리(m)
///
/// - 하버사인 공식, 지구 반지름 6,371,000m
double distanceMeters(({double latitude, double longitude}) a, ({double latitude, double longitude}) b) {
  const earthRadius = 6371000.0;

  double radians(double degree) => degree * math.pi / 180;

  final latitudeDelta = radians(b.latitude - a.latitude);
  final longitudeDelta = radians(b.longitude - a.longitude);
  final h = math.pow(math.sin(latitudeDelta / 2), 2) +
      math.cos(radians(a.latitude)) * math.cos(radians(b.latitude)) * math.pow(math.sin(longitudeDelta / 2), 2);

  return 2 * earthRadius * math.asin(math.sqrt(h));
}
