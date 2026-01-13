import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i(
      '--- API REQUEST ---\n'
      'URL: ${options.baseUrl}${options.path}\n'
      'Method: ${options.method}\n'
      'Headers: ${options.headers}\n'
      'Query Params: ${options.queryParameters}\n'
      'Body: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      '--- API RESPONSE ---\n'
      'Status Code: ${response.statusCode}\n'
      'URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}\n'
      'Data: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '--- API ERROR ---\n'
      'Error: ${err.error}\n'
      'Message: ${err.message}\n'
      'Path: ${err.requestOptions.path}\n'
      'Response: ${err.response?.data}',
    );
    super.onError(err, handler);
  }
}
