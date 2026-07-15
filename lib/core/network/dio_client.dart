import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the configured Dio HTTP client.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  dio.interceptors.addAll([
    LoggingInterceptor(),
  ]);

  return dio;
});

/// Logs request/response details in debug mode.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('[DIO] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[DIO] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('[DIO] ERROR ${err.type} — ${err.message}');
    handler.next(err);
  }
}

/// Simple in-memory cache for API responses.
class ResponseCache {
  final _cache = <String, CacheEntry>{};
  final Duration defaultTtl;

  ResponseCache({this.defaultTtl = const Duration(minutes: 5)});

  Response? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cache.remove(key);
      return null;
    }
    return entry.response;
  }

  void set(String key, Response response, {Duration? ttl}) {
    _cache[key] = CacheEntry(
      response: response,
      expiresAt: DateTime.now().add(ttl ?? defaultTtl),
    );
  }

  void invalidate(String key) => _cache.remove(key);
  void clear() => _cache.clear();
}

class CacheEntry {
  final Response response;
  final DateTime expiresAt;

  CacheEntry({required this.response, required this.expiresAt});
}
