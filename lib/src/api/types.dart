import 'dart:async';
import 'dart:developer';

import 'package:async/async.dart';
import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:retry/retry.dart' as r;
import 'package:utils/src/utils/extensions/closures.dart';

enum ApiState {
  loaded,
  pending,
  error;

  bool get isPending => this == ApiState.pending;
  bool get isLoaded => this == ApiState.loaded;
  bool get isError => this == ApiState.error;
  bool get isNotPending => this != ApiState.pending;
  bool get isNotLoaded => this != ApiState.loaded;
  bool get isNotError => this != ApiState.error;
}

typedef Err = Object?;

class ApiException implements Exception {
  const ApiException(this.value);
  final Err value;

  @override
  String toString() {
    return value.toString();
  }
}

typedef FutureE<T> = Future<Either<ApiException, T>>;

class RxV<T> {
  RxV(T initial, {ApiState state = ApiState.loaded})
      : selectData = initial.obs,
        selectState = state.obs,
        selectError = Rx(null);

  final Rx<ApiState> selectState;
  final Rx<Err> selectError;
  final Rx<T> selectData;

  CancelableOperation<Either<ApiException, T>>? _completerExecution;
  DateTime _lastExecution = DateTime.now();

  ApiState get state => selectState.value;
  T get data => selectData.value;
  Err get error => selectError.value;

  bool get isPending => state.isPending;
  bool get isLoaded => state.isLoaded;
  bool get isError => state.isError;
  bool get isNotPending => state.isNotPending;
  bool get isNotLoaded => state.isNotLoaded;
  bool get isNotError => state.isNotError;

  void map<CustomErrorType>({
    void Function(T)? onData,
    void Function(Err)? onError,
  }) {
    if (isLoaded) {
      onData?.call(data);
    } else if (isError) {
      onError?.call(error);
    }
  }

  void setState([ApiState state = ApiState.pending]) => selectState.value = state;

  set data(T data) {
    selectData.value = data;
    selectState.value = ApiState.loaded;
    selectError.value = null;
  }

  set error(Err error) {
    selectError.value = error;
    selectState.value = ApiState.error;
  }

  void fromEither(Either<ApiException, T> resp) {
    resp.isLeft ? error = resp.left.value : data = resp.right;
  }

  Future<void> executeOnce(FutureE<T> Function() func, {bool retry = false}) async {
    if (isPending) {
      return;
    }
    setState();
    fromEither(await (retry ? retryE(func) : func()));
  }

  /// Debounce call with delay, cancels previous executions
  Future<void> execute(
    FutureE<T> Function() func, {
    bool retry = false,
    Duration delay = const Duration(
      milliseconds: 50,
    ),
  }) async {
    setState();
    final localTime = DateTime.now();
    _lastExecution = localTime;
    await Future.delayed(delay);
    if (localTime != _lastExecution) {
      return;
    }

    await _completerExecution?.cancel();

    _completerExecution = CancelableOperation.fromFuture(retry ? retryE(func) : func());

    await _completerExecution!.then(
      (value) {
        value.either((e) {
          error = e.value;
        }, (v) {
          data = v;
        });
      },
    ).valueOrCancellation();
  }
}

class RxVn<T> extends RxV<T?> {
  RxVn({T? initial, ApiState state = ApiState.loaded}) : super(initial, state: state);
}

class _RxVLoadMore<T, O> extends RxV<T> {
  _RxVLoadMore(super.initial, {required this.initialOffset, super.state}) : offset = initialOffset;

  O initialOffset;
  O? offset;
}

extension type RxVm<T extends Iterable, Offset extends Object>._(_RxVLoadMore<T, Offset> _)
    implements _RxVLoadMore<T, Offset> {
  /// Use for lists with infinity loading
  RxVm(T initial, {required Offset initialOffset, ApiState state = ApiState.loaded})
      : this._(_RxVLoadMore(initial, initialOffset: initialOffset, state: state));

  @redeclare
  @Deprecated('Use execute')
  Future<void> executeOnce() async {}

  @redeclare
  Future<void> execute(
    FutureE<({T data, Offset? offset})> Function(Offset offset) func, {
    required bool loadingMore,
    bool emptyBeforeReload = true,
    bool retry = false,
  }) async {
    if (!loadingMore) {
      if (emptyBeforeReload) {
        _.data = const Iterable.empty() as T;
      }
      _.offset = _.initialOffset;
    }
    if (_.offset == null) {
      return;
    }
    await _.execute(
      () => func(_.offset!).mapRight((v) {
        _.offset = v.data.isEmpty ? null : v.offset;
        return [if (loadingMore) ..._.data, ...v.data] as T;
      }),
      retry: retry,
    );
  }
}

FutureE<T> retryE<T>(
  FutureE<T> Function() func, {
  FutureOr<bool> Function(Err)? retryIf,
}) async {
  return safe(
    () => r.retry(
      maxAttempts: 5,
      () async {
        final res = await func();
        if (res.isLeft) {
          throw res.left;
        }
        return res.right;
      },
      retryIf: retryIf.let((f) => (e) => f((e as ApiException).value)),
      onRetry: (e) {
        log('retry');
      },
    ),
  );
}

/// Catches Exceptions and returns either an error or data
FutureE<T> safe<T>(FutureOr<T> Function() future) async {
  try {
    return Right(await future());
  } on ApiException catch (e) {
    log(e.value.toString());
    return Left(e);
  } on Exception catch (e, s) {
    log(e.toString(), stackTrace: s);
    return Left(ApiException(e));
  } on Object catch (e, s) {
    log(e.toString(), stackTrace: s);
    return Left(ApiException(e));
  }
}

/// [safe] for mock functions
FutureE<T> safeMock<T>(
  T value, {
  Duration delay = const Duration(milliseconds: 500),
}) async {
  return safe<T>(() => Future.delayed(delay, () => value));
}
