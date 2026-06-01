import 'package:dio/dio.dart';

class ApiClient {
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://van.mama.cn/hb/api',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          headers: const {'platformtype': 'h5'},
        ),
      ),
      _handler = null;

  ApiClient.fake(Future<Map<String, dynamic>> Function(String path) handler)
    : _dio = Dio(),
      _handler = handler;

  final Dio _dio;
  final Future<Map<String, dynamic>> Function(String path)? _handler;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final handler = _handler;
    if (handler != null) {
      return handler(path);
    }
    final response = await _dio.get<Object?>(
      path,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw ApiException('接口返回格式异常');
  }
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
