import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressLoading extends StatefulWidget {
  const ProgressLoading({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProgressLoadingState();
  }
}

class ProgressLoadingState extends State<ProgressLoading> {
  int _p = 0;

  setProgress(int p) {
    setState(() {
      _p = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: SpinKitCircle(
                size: 50.0,
                color: Theme.of(context).primaryColor,
              ),
              width: 90,
              height: 70,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text('下载中...' + _p.toString() + "%"),
            )
          ],
        ),
        elevation: 5,
      ),
    );
  }
}
