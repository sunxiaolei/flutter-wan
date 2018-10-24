import 'package:http/http.dart' as http;
import 'package:wan/model/homebanner.dart';
import 'package:wan/model/homedata.dart';
import 'package:wan/net/api.dart';
import 'dart:convert';

import 'package:wan/utils/logutils.dart';

class Request {
  //获取首页列表
  static Future<HomeData> getHomeList(int index) async {
    String reqAPi = Api.homelist + index.toString() + "/json";
    Log.i('getHomeList:::request==>' + reqAPi);
    http.Response response = await http.get(reqAPi);
    Log.i('getHomeList:::response==>' + response.body.toString());
    return HomeData.fromJson(json.decode(response.body));
  }

  //获取banner
  static Future<HomeBanner> getHomeBanner() async {
    String reqAPi = Api.homebanner;
    Log.i('getHomeBanner:::request==>' + reqAPi);
    http.Response response = await http.get(reqAPi);
    Log.i('getHomeBanner:::response==>' + response.body.toString());
    return HomeBanner.fromJson(json.decode(response.body));
  }
}
