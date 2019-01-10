import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wan/net/interceptor.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/progress_loading.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestWidget(),
    );
  }
}

class TestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestState();
  }
}

class TestState extends State<TestWidget> {
  String _data = 'null';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    GlobalKey<ProgressLoadingState> _key = GlobalKey();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ProgressLoading(
                        key: _key,
                      );
                    });
                downloadApk((int received, int total) {
                  setState(() {
                    _data = 'received=>' +
                        received.toString() +
                        '\ntotal=>' +
                        total.toString();
                    int p = received * 100 ~/ total;
                    _key.currentState.setProgress(p);
                  });
                  if (received == total) {
                    _install();
                  }
                });
              },
              child: Text('download'),
            ),
            Text(_data),
          ],
        ),
      ),
    );
  }

  Future<Null> downloadApk(progress) async {
    String url =
        'https://file-1254067164.cos.ap-shanghai.myqcloud.com/wan-flutter/app-release-v1.1.apk';
    Directory dir = await getExternalStorageDirectory();
    String path = dir.path + '/wanflutter.apk';
    Dio _dio = Dio();
    LogInterceptor interceptor = LogInterceptor();
    _dio.interceptor.request.onSend = interceptor.onSend;
    _dio.interceptor.response.onSuccess = interceptor.onSuccess;
    _dio.interceptor.response.onError = interceptor.onError;
    Response response = await _dio
        .download(
      url,
      path,
      onProgress: progress,
    )
        .catchError((e) {
      ToastUtils.showShort(e.message);
    });
  }

  _install() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.path + '/wanflutter.apk';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String pkgName = packageInfo.packageName;
    InstallPlugin.installApk(path, pkgName).then((result) {
      print('install apk $result');
    }).catchError((error) {
      print('install apk error: $error');
    });
  }
}
