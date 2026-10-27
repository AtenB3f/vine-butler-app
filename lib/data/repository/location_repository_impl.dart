import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vine_butler/domain/repository/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl();

  /// 현재 위치 조회
  ///
  /// - `denied`: 권한을 요청하고 거부되면 null
  /// - 조회 시간 제한 10초
  @override
  Future<({double latitude, double longitude})?> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) { return null; }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) { permission = await Geolocator.requestPermission(); }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) { return null; }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 10)),
      );

      return (latitude: position.latitude, longitude: position.longitude);
    } catch (error) {
      if (kDebugMode) { debugPrint('[Location] $error'); }

      return null;
    }
  }

  @override
  Future<bool> isPermanentlyDenied() async => await Geolocator.checkPermission() == LocationPermission.deniedForever;

  @override
  Future<void> openSettings() => Geolocator.openAppSettings();
}
