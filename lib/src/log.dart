class Log {
  static void e(Object TAG, String msg, [Object? e]) {
    print("E:$TAG -> $msg $e");
  }

  static void d(Object TAG, String msg) {
    print("D:$TAG -> $msg");
  }
}
