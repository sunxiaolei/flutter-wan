import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:wan/model/dto/addtodo_dto.dart';
import 'package:wan/model/dto/base_dto.dart';
import 'package:wan/model/dto/login_dto.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/model/dto/homebanner_dto.dart';
import 'package:wan/model/dto/articledatas_dto.dart';
import 'package:dio/dio.dart';
import 'package:wan/model/dto/hotkey_dto.dart';
import 'package:wan/model/dto/navi_dto.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/model/dto/todolist_dto.dart';
import 'package:wan/model/dto/update_dto.dart';
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

  _handleRes(Response response) {
    Map<String, dynamic> resJson;
    if (response.data is String) {
      resJson = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      resJson = response.data;
    } else {
      throw DioError(message: '数据解析错误');
    }
    BaseDTO base = BaseDTO.fromJson(resJson);
    if (base.errorCode == 0) {
      return base.data;
    } else {
      throw DioError(message: base.errorMsg);
    }
  }

  //获取首页列表
  @override
  Future<ArticleDatasDTO> getHomeList(int page) async {
    String reqAPi = '${Api.homelist}$page/json';
    Response response = await _dio.get(reqAPi);
    return ArticleDatasDTO.fromJson(_handleRes(response));
  }

  //获取banner
  @override
  Future<List<BannerDataDTO>> getHomeBanner() async {
    Response response = await _dio.get(Api.homebanner);
    List<BannerDataDTO> data = new List<BannerDataDTO>();
    _handleRes(response).forEach((v) {
      data.add(new BannerDataDTO.fromJson(v));
    });
    return data;
  }

  //获取导航数据
  @override
  Future<List<NaviDTO>> getNavi() async {
    Response response = await _dio.get(Api.navi);
    List<NaviDTO> data = new List<NaviDTO>();
    _handleRes(response).forEach((v) {
      data.add(new NaviDTO.fromJson(v));
    });
    return data;
  }

  //获取搜索热词
  @override
  Future<List<HotKeyDTO>> getHotKey() async {
    Response response = await _dio.get(Api.hotkey);
    List<HotKeyDTO> data = new List<HotKeyDTO>();
    _handleRes(response).forEach((v) {
      data.add(new HotKeyDTO.fromJson(v));
    });
    return data;
  }

  //搜索
  @override
  Future<ArticleDatasDTO> search(int page, String keyword) async {
    Response response = await _dio.post('${Api.search}$page/json',
        data: FormData.from({'k': keyword}));
    return ArticleDatasDTO.fromJson(_handleRes(response));
  }

  //获取公众号列表
  @override
  Future<List<SubscriptionsDTO>> getSubscriptions() async {
    Response response = await _dio.get(Api.subscriptions);
    List<SubscriptionsDTO> data = new List<SubscriptionsDTO>();
    _handleRes(response).forEach((v) {
      data.add(new SubscriptionsDTO.fromJson(v));
    });
    return data;
  }

  //获取公众号文章
  @override
  Future<ArticleDatasDTO> getSubscriptionsHis(
      int page, int id, String keyword) async {
    Response response = await _dio
        .get('${Api.subscriptionsHis}$id/$page/json', data: {'k': '$keyword'});
    return ArticleDatasDTO.fromJson(_handleRes(response));
  }

  //登录
  @override
  Future<LoginDTO> login(String username, String password) async {
    Response response = await _dio.post(Api.login,
        data: FormData.from({'username': username, 'password': password}));
    return LoginDTO.fromJson(_handleRes(response));
  }

  //注册
  @override
  Future<LoginDTO> register(
      String username, String password, String repassword) async {
    Response response = await _dio.post(Api.register,
        data: FormData.from({
          'username': username,
          'password': password,
          'repassword': repassword
        }));
    return LoginDTO.fromJson(_handleRes(response));
  }

  //收藏列表
  @override
  Future<ArticleDatasDTO> getFavorite(int page) async {
    String reqAPi = '${Api.favoriteList}$page/json';
    Response response = await _dio.get(reqAPi);
    return ArticleDatasDTO.fromJson(_handleRes(response));
  }

  //登出
  @override
  Future<Null> logout() async {
    Response response = await _dio.get(Api.logout);
    return _handleRes(response);
  }

  //收藏
  @override
  Future<Null> favorite(int id) async {
    String reqAPi = '${Api.favorite}$id/json';
    Response response = await _dio.post(reqAPi);
    return _handleRes(response);
  }

  //取消收藏
  @override
  Future<Null> favoriteCancel(int id) async {
    String reqAPi = '${Api.favoriteCancel}$id/json';
    Response response = await _dio.post(reqAPi);
    return _handleRes(response);
  }

  //检测更新
  @override
  Future<UpdateDTO> checkUpdate() async {
    String reqAPi = Api.checkUpdate;
    Dio _dio = Dio();
    LogInterceptor interceptor = LogInterceptor();
    _dio.interceptor.request.onSend = interceptor.onSend;
    _dio.interceptor.response.onSuccess = interceptor.onSuccess;
    _dio.interceptor.response.onError = interceptor.onError;
    Response response = await _dio.get(reqAPi);
    return UpdateDTO.fromJson(json.decode(response.data));
  }

  //获取todo列表
  @override
  Future<TodoListDTO> getTodoList(int index, int type) async {
    String reqAPi = '${Api.todoList}$index/json';
    Response response = await _dio.get(reqAPi, data: {'type': type});
    return TodoListDTO.fromJson(_handleRes(response));
  }

  //更新todo状态
  @override
  Future<TodoDTO> updateTodoStatus(int id, int status) async {
    String reqAPi = '${Api.updateTodoStatus}$id/json';
    Response response = await _dio.post(reqAPi,
        data: FormData.from({
          'status': status,
        }));
    return TodoDTO.fromJson(_handleRes(response));
  }

  //新增TODO
  @override
  Future<TodoDTO> addTodo(AddTodoDTO param) async {
    String reqAPi = Api.addTodo;
    Response response = await _dio.post(reqAPi,
        data: FormData.from(param.toJson()));
    return TodoDTO.fromJson(_handleRes(response));
  }
}
