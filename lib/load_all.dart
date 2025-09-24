import 'dart:async';

import 'package:utils/api/types.dart';

Future<List<T>> loadAll<T, O>(
  FutureOr<(List<T>, O?)> Function(int limitPerCall, O offset) future,
  O initialOffset,
) async {
  final list = <T>[];
  O? offset = initialOffset;
  const limitPerCall = 100;

  FutureE<(List<T>, O?)> getWithOffset(O offset) {
    return safe(() => future(limitPerCall, offset));
  }

  while (true) {
    if (offset == null) {
      break;
    }
    final res = await getWithOffset(offset);

    if (res.isRight) {
      offset = res.right.$2;
      list.addAll(res.right.$1);
      if (res.right.$1.length < limitPerCall) {
        break;
      }
    } else {
      throw res.left;
    }
  }

  return list;
}
