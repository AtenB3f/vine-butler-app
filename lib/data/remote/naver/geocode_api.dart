import 'package:dio/dio.dart';
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
    final response = await _dio.get<Map<String, dynamic>>(
      '/map-geocode/v2/geocode',
      queryParameters: {
        'query': query,
        if (coordinate != null) 'coordinate': '${coordinate.longitude},${coordinate.latitude}',
        'page': page,
        'count': count,
      },
    );
    return GeocodeResponseDto.fromJson(response.data ?? const {});
  }
}
