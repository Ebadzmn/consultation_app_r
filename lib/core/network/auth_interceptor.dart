import 'package:dio/dio.dart';
import 'token_storage.dart';
import 'api_client.dart';
import '../config/app_routes.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  Future<String?>? _refreshFuture;

  AuthInterceptor(this._tokenStorage, this._dio);

  bool _isAuthPath(RequestOptions options) {
    return options.path == ApiClient.login ||
        options.path == ApiClient.refreshToken;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    if (statusCode == 401 &&
        !_isAuthPath(requestOptions) &&
        requestOptions.extra['retry'] != true) {
      final refreshToken = _tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        await _tokenStorage.clearAuth();
        appRouter.go(AppRoutes.signIn);
        super.onError(err, handler);
        return;
      }

      try {
        _refreshFuture ??= _performTokenRefresh(refreshToken);
        final newAccessToken = await _refreshFuture;
        _refreshFuture = null;

        if (newAccessToken != null) {
          await _tokenStorage.saveToken(newAccessToken);
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          requestOptions.extra['retry'] = true;
          final response = await _dio.fetch(requestOptions);
          handler.resolve(response);
          return;
        } else {
          await _tokenStorage.clearAuth();
          appRouter.go(AppRoutes.signIn);
          super.onError(err, handler);
          return;
        }
      } catch (_) {
        _refreshFuture = null;
        await _tokenStorage.clearAuth();
        appRouter.go(AppRoutes.signIn);
        super.onError(err, handler);
        return;
      }
    }

    super.onError(err, handler);
  }

  Future<String?> _performTokenRefresh(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiClient.refreshToken,
        data: {'refresh': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final access = data['access'] as String?;
        final newRefresh = data['refresh'] as String?;

        if (newRefresh != null && newRefresh.isNotEmpty) {
          await _tokenStorage.saveRefreshToken(newRefresh);
        }

        return access;
      }
    } catch (_) {}

    return null;
  }
}
