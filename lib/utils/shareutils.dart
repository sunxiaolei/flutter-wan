import 'package:flutter/services.dart';

class ShareUtils {
  static const String CHANNEL_SHARE = "channel_share";
  static const String METHOD_SHARE = "method_share";

  static void share(String msg) {
    MethodChannel(CHANNEL_SHARE).invokeMethod(METHOD_SHARE, msg);
  }
}
