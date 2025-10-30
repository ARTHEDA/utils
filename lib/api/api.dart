import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:utils/api/models.dart';
import 'package:utils/api/types.dart';
import 'package:utils/src/extensions/object_extensions.dart';

typedef ShouldRefresh = bool Function(Response<dynamic>? response);

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
    final isRefresh = _comparePath(options, refreshPath);
    final credentials = credentialsGetter();
    final token = isRefresh ? credentials.refreshToken : credentials.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({
    required this.credentialsGetter,
    required this.refreshPath,
    required this.refreshGetter,
    this.shouldRefresh = _defaultShouldRefresh,
  });

  final ValueGetter<ICredentialsService> credentialsGetter;
  final String refreshPath;
  final ValueGetter<FutureE<TokenPairModel>> refreshGetter;
  final ShouldRefresh shouldRefresh;

  Completer<bool>? completer;

  Future<bool> refreshToken() async {
    final credentials = credentialsGetter();
    if (credentials.refreshToken == null) {
      log('refresh is null');
      await credentials.logout();
      return false;
    }
    final res = await refreshGetter();
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
    return (Dio(
      BaseOptions(
        baseUrl: requestOptions.baseUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
      ),
    )..interceptors.add(
            BearerInterceptor(
              credentialsGetter: credentialsGetter,
              refreshPath: refreshPath,
            ),
          ))
        .fetch(
      requestOptions.data is FormData ? _recreateOptions(requestOptions) : requestOptions,
    );
  }

  RequestOptions _recreateOptions(RequestOptions options) {
    final formData = options.data as FormData;
    final newFormData = formData.clone();
    return options.copyWith(data: newFormData);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!shouldRefresh(err.response) || _comparePath(err.requestOptions, refreshPath)) {
      return handler.next(err);
    }
    if (completer != null) {
      final res = await completer!.future;
      if (!res) {
        return handler.next(err);
      }
    } else {
      log('refreshing token');
      completer = Completer();
      if (!await refreshToken()) {
        completer?.complete(false);
        completer = null;
        return handler.next(err);
      }
      completer?.complete(true);
      completer = null;
    }

    final res = await safe(() => _retry(err.requestOptions));
    if (res.isLeft) {
      final e = res.left.value;
      return handler.next(
        e is DioException
            ? e
            : DioException(
                requestOptions: err.requestOptions,
                error: e,
              ),
      );
    }

    handler.resolve(res.right);
  }

  static bool _defaultShouldRefresh(Response<dynamic>? response) {
    return response?.statusCode == 401;
  }
}
