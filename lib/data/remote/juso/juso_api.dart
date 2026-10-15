import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vine_butler/data/remote/juso/dto/juso_response_dto.dart';

class JusoApi {
  const JusoApi(this._dio);

  final Dio _dio;

  Future<JusoResponseDto> search({required String keyword, int page = 1, int countPerPage = 10}) async {
    const path = '/addrlink/addrLinkApi.do';

    if (kDebugMode) { debugPrint('[API] → GET $path keyword: $keyword, page: $page'); }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {'keyword': keyword, 'currentPage': page, 'countPerPage': countPerPage},
      );

      if (kDebugMode) { debugPrint('[API] ← ${response.statusCode} $path ${response.data}'); }

      return JusoResponseDto.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      if (kDebugMode) { debugPrint('[API] ✗ ${e.response?.statusCode ?? e.type.name} $path ${e.response?.data ?? e.message}'); }

      rethrow;
    }
  }
}
