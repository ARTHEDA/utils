extension ObjectX on Object? {
  T? cast<T>() {
    if (this is T) {
      return this as T;
    } else {
      return null;
    }
  }
}
