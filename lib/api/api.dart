import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:utils/api/models.dart';
import 'package:utils/api/types.dart';
import 'package:utils/src/extensions/object_extensions.dart';

bool _comparePath(RequestOptions options, String path) {
  return options.path == path;
}

class BearerInterceptor extends Interceptor {
  BearerInterceptor({
    required this.credentialsGetter,
    required this.refreshPath,
  });

  final ValueGetter<ICredentialsService> credentialsGetter;
  final String refreshPath;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.headers['Authorization'] != null ||
        (options.extra['secure'] as List).firstWhereOrNull(
              (e) => e is Map<String, String> && e['name'] == 'BearerAuth',
            ) !=
            null) {
      final isRefresh = _comparePath(options, refreshPath);
      final credentials = credentialsGetter();
      final token = isRefresh ? credentials.refreshToken : credentials.token;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    super.onRequest(options, handler);
  }
}

class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({
    required this.baseUrl,
    required this.credentialsGetter,
    required this.refreshPath,
    required this.refreshGetter,
  });

  final ValueGetter<ICredentialsService> credentialsGetter;
  final String refreshPath;
  final String baseUrl;
  final ValueGetter<FutureE<TokenPairModel> Function()> refreshGetter;

  Completer<bool>? completer;

  Future<bool> refreshToken() async {
    final credentials = credentialsGetter();
    if (credentials.refreshToken == null) {
      log('refresh is null');
      await credentials.logout();
      return false;
    }
    final res = await refreshGetter().call();
    if (res.isRight) {
      await credentials.setToken(res.right);
      return true;
    } else {
      final statusCode =
          res.left.value.cast<DioException>()?.response?.statusCode ?? res.left.value.cast<int>();
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        log('refresh failed');
        await credentials.logout();
      }
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return (Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
      ),
    )..interceptors.add(
            BearerInterceptor(
              credentialsGetter: credentialsGetter,
              refreshPath: refreshPath,
            ),
          ))
        .request<dynamic>(
      requestOptions.path,
      data: requestOptions.data is FormData
          ? (requestOptions.data as FormData).clone()
          : requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_comparePath(err.requestOptions, refreshPath)) {
      if (completer != null) {
        final res = await completer!.future;
        if (!res) {
          return handler.reject(err);
        }
      } else {
        log('refreshing token');
        completer = Completer();
        if (!await refreshToken()) {
          completer?.complete(false);
          completer = null;
          return handler.reject(err);
        }
        completer?.complete(true);
        completer = null;
      }

      final res = await safe(() => _retry(err.requestOptions));
      if (res.isLeft) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: res.left.value,
          ),
        );
      }

      return handler.resolve(res.right);
    }
    handler.next(err);
  }
}
