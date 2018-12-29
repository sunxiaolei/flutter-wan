import 'package:flutter/material.dart';
import 'package:wan/net/request.dart';

class Test extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestState();
  }
}

class TestState extends State<Test> {
  String _data = 'null';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(_data),
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
  }
}
