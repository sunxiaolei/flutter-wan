class Log {
  static bool openLog = true;

  static void i(Object msg) {
    if (openLog) {
      print(msg);
    }
  }
}
