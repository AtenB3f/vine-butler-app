import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vine_butler/data/remote/naver/dto/geocode_response_dto.dart';

class GeocodeApi {
  const GeocodeApi(this._dio);

  final Dio _dio;

  Future<GeocodeResponseDto> geocode({
    required String query,
    ({double latitude, double longitude})? coordinate,
    int page = 1,
    int count = 10,
  }) async {
    const path = '/map-geocode/v2/geocode';
    final queryParameters = {
      'query': query,
      if (coordinate != null) 'coordinate': '${coordinate.longitude},${coordinate.latitude}',
      'page': page,
      'count': count,
    };
    if (kDebugMode) {
      debugPrint('[API] → GET $path $queryParameters');
    }
    try {
      final response = await _dio.get<Map<String, dynamic>>(path, queryParameters: queryParameters);
      if (kDebugMode) {
        debugPrint('[API] ← ${response.statusCode} $path ${response.data}');
      }
      return GeocodeResponseDto.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[API] ✗ ${e.response?.statusCode ?? e.type.name} $path ${e.response?.data ?? e.message}');
      }
      rethrow;
    }
  }
}
