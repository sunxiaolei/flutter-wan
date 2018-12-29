import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:wan/model/dto/login_dto.dart';
import 'package:wan/model/dto/logout_dto.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/model/dto/homebanner_dto.dart';
import 'package:wan/model/dto/articledatas_dto.dart';
import 'package:dio/dio.dart';
import 'package:wan/model/dto/hotkey_dto.dart';
import 'package:wan/model/dto/navi_dto.dart';
import 'package:wan/net/api.dart';
import 'package:wan/net/interceptor.dart';
import 'package:wan/net/request.dart';

///请求
class RequestImpl extends Request {
  Dio _dio;

  RequestImpl() : super.internal() {
    Options options = Options(baseUrl: Api.baseUrl, connectTimeout: 10000);
    _dio = Dio(options);
    LogInterceptor interceptor = LogInterceptor();
    _dio.interceptor.request.onSend = interceptor.onSend;
    _dio.interceptor.response.onSuccess = interceptor.onSuccess;
    _dio.interceptor.response.onError = interceptor.onError;

    _setPersistCookieJar();
  }

  _setPersistCookieJar() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    _dio.cookieJar = new PersistCookieJar(path);
  }

  //获取首页列表
  @override
  Future<ArticleDatasDTO> getHomeList(int page) async {
    String reqAPi = '${Api.homelist}$page/json';
    Response response = await _dio.get(reqAPi);
    return ArticleDatasDTO.fromJson(response.data);
  }

  //获取banner
  @override
  Future<HomeBannerDTO> getHomeBanner() async {
    Response response = await _dio.get(Api.homebanner);
    return HomeBannerDTO.fromJson(response.data);
  }

  //获取导航数据
  @override
  Future<Navi> getNavi() async {
    Response response = await _dio.get(Api.navi);
    return Navi.fromJson(response.data);
  }

  //获取搜索热词
  @override
  Future<HotKeyDTO> getHotKey() async {
    Response response = await _dio.get(Api.hotkey);
    return HotKeyDTO.fromJson(response.data);
  }

  //搜索
  @override
  Future<ArticleDatasDTO> search(int page, String keyword) async {
    Response response = await _dio.post('${Api.search}$page/json',
        data: FormData.from({'k': keyword}));
    return ArticleDatasDTO.fromJson(response.data);
  }

  //获取公众号列表
  @override
  Future<SubscriptionsList> getSubscriptions() async {
    Response response = await _dio.get(Api.subscriptions);
    return SubscriptionsList.fromJson(response.data);
  }

  //获取公众号文章
  @override
  Future<ArticleDatasDTO> getSubscriptionsHis(
      int page, int id, String keyword) async {
    Response response = await _dio
        .get('${Api.subscriptionsHis}$id/$page/json', data: {'k': '$keyword'});
    return ArticleDatasDTO.fromJson(response.data);
  }

  //登录
  @override
  Future<LoginDTO> login(String username, String password) async {
    Response response = await _dio.post(Api.login,
        data: FormData.from({'username': username, 'password': password}));
    return LoginDTO.fromJson(response.data);
  }

  //收藏
  @override
  Future<ArticleDatasDTO> getFavorite(int page) async {
    String reqAPi = '${Api.favorite}$page/json';
    _dio.cookieJar.loadForRequest(Uri.parse(Api.baseUrl + Api.login));
    Response response = await _dio.get(reqAPi);
    return ArticleDatasDTO.fromJson(response.data);
  }

  //登出
  @override
  Future<LogoutDTO> logout() async {
    Response response = await _dio.get(Api.logout);
    return LogoutDTO.fromJson(response.data);
  }
}
