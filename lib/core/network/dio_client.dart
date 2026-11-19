import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app/config/environment.dart';
import 'api_exceptions.dart';

/// Thin wrapper around [Dio] with automatic error mapping.
class DioClient {
  late final Dio _dio;

  DioClient(AppConfig config) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.connectTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  String get baseUrl => _dio.options.baseUrl;

  void updateBaseUrl(String newUrl) {
    _dio.options.baseUrl = newUrl;
  }

  static const List<String> _localFallbacks = [
    'https://rebs-hrms.onrender.com',
    'http://127.0.0.1:3000',
    'http://192.168.1.8:3000',
    'http://10.0.2.2:3000',
  ];

  Future<Response<T>?> _tryCandidateFallbacks<T>(
    Future<Response<T>> Function(Dio client) requestRunner,
  ) async {
    final current = _dio.options.baseUrl;
    for (final candidate in _localFallbacks) {
      if (candidate == current) continue;
      try {
        final candidateDio = Dio(
          _dio.options.copyWith(
            baseUrl: candidate,
            connectTimeout: const Duration(milliseconds: 1500),
            sendTimeout: const Duration(milliseconds: 1500),
            receiveTimeout: const Duration(milliseconds: 2000),
          ),
        );
        final res = await requestRunner(candidateDio);
        _dio.options.baseUrl = candidate;
        return res;
      } catch (_) {
        // Try next candidate
      }
    }
    return null;
  }

  /// HTTP GET with automatic physical-device/emulator loopback fallback.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        final fallbackRes = await _tryCandidateFallbacks<T>(
          (client) => client.get<T>(
            path,
            queryParameters: queryParameters,
            options: options,
          ),
        );
        if (fallbackRes != null) return fallbackRes;
      }
      throw _mapDioError(e);
    }
  }

  /// HTTP POST with optional idempotency key and automatic fallback.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Options? options,
  }) async {
    try {
      final headers = <String, dynamic>{};
      if (idempotencyKey != null) {
        headers['Idempotency-Key'] = idempotencyKey;
      }

      return await _dio.post<T>(
        path,
        data: data,
        options: (options ?? Options()).copyWith(headers: headers),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        final fallbackRes = await _tryCandidateFallbacks<T>(
          (client) {
            final headers = <String, dynamic>{};
            if (idempotencyKey != null) {
              headers['Idempotency-Key'] = idempotencyKey;
            }
            return client.post<T>(
              path,
              data: data,
              options: (options ?? Options()).copyWith(headers: headers),
            );
          },
        );
        if (fallbackRes != null) return fallbackRes;
      }
      throw _mapDioError(e);
    }
  }

  /// Map [DioException] to typed [AppException].
  AppException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Request timed out connecting to ${_dio.options.baseUrl}. '
          'Please ensure mock server is running and check API Base URL in Settings.',
          e,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'Cannot connect to mock server at ${_dio.options.baseUrl}. '
          'Please ensure mock server is running and check API Base URL in Settings.',
          e,
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        String message = 'Server error';
        String? code;
        if (responseData is Map) {
          final errObj = responseData['error'];
          if (errObj is Map) {
            message = errObj['message']?.toString() ?? message;
            code = errObj['code']?.toString();
          } else if (responseData['message'] != null) {
            message = responseData['message'].toString();
          }
        }

        if (statusCode == 409) {
          return ConflictException(message,
              statusCode: statusCode, originalError: e);
        }
        if (statusCode == 422) {
          return ValidationException(message,
              errorCode: code, statusCode: statusCode, originalError: e);
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerException(message.toString(),
              statusCode: statusCode, originalError: e);
        }
        return ServerException(message.toString(),
            statusCode: statusCode, originalError: e);

      default:
        return NetworkException(
            e.message ?? 'Unknown network error', e);
    }
  }
}
