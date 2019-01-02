import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonUtils {
  static void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Card(
                color: Theme.of(context).backgroundColor,
                child: Container(
                  child: SpinKitCircle(
                    size: 50.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  width: 70,
                  height: 70,
                ),
                elevation: 5,
              ),
            ),
          );
        });
  }
}
