import 'package:http/http.dart' as http;
import 'package:wan/model/homedata.dart';
import 'package:wan/net/api.dart';
import 'dart:convert';

import 'package:wan/utils/logutils.dart';

class Request {
  static Future<HomeData> getHomeList(int index) async {
    String reqAPi = Api.homelist + index.toString() + "/json";
    Log.i('getHomeList:::request==>' + reqAPi);
    http.Response response = await http.get(reqAPi);
    Log.i('getHomeList:::response==>' + response.body.toString());
    return HomeData.fromJson(json.decode(response.body));
  }
}
