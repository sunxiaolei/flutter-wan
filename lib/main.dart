import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wan/app.dart';

///程序入口
void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //竖屏
        .then((_) {
      runApp(new WanApp());
    });
