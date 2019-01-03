import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan/net/interceptor.dart';
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
    String reqAPi =
        'https://raw.githubusercontent.com/sunxiaolei/test/master/update.cong';
    Dio _dio = Dio();
    LogInterceptor interceptor = LogInterceptor();
    _dio.interceptor.request.onSend = interceptor.onSend;
    _dio.interceptor.response.onSuccess = interceptor.onSuccess;
    _dio.interceptor.response.onError = interceptor.onError;
    Response response = await _dio.get(reqAPi).then((res) {
      setState(() {
        _data = res.data;
      });
    });
  }
}
