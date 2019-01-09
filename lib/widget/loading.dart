import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoadingState();
  }
}

class LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
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
    );
  }
}
