class Log {
  static bool openLog = true;

  static void i(String msg) {
    if (openLog) {
      if (msg.length > 4000) {
        for (int i = 0; i < msg.length; i += 4000) {
          if (i + 4000 < msg.length)
            print(msg.substring(i, i + 4000));
          else
            print(msg.substring(i, msg.length));
        }
      } else {
        print(msg);
      }
    }
  }
}
