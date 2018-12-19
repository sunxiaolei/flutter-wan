import 'package:wan/model/homebanner.dart';
import 'package:wan/model/homedata.dart';
import 'package:wan/net/requestimpl.dart';

abstract class Request {
  static RequestImpl _impl;

  Request.internal();

  factory Request() {
    if (_impl == null) {
      _impl = RequestImpl();
    }
    return _impl;
  }

  //获取首页列表
  Future<HomeData> getHomeList(int index);

  //获取banner
  Future<HomeBanner> getHomeBanner();
}
