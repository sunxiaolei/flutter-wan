import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showShort(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        bgcolor: "#000000",
        textcolor: '#ffffff');
  }
}
