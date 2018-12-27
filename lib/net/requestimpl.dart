import 'package:wan/model/dto/subscriptions_dto.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/model/homebanner_dto.dart';
import 'package:wan/model/articledatas_dto.dart';
import 'package:dio/dio.dart';
import 'package:wan/model/hotkey_dto.dart';
import 'package:wan/model/navi_dto.dart';
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

  @override
  Future<SubscriptionsList> getSubscriptions() async {
    Response response = await _dio.get(Api.subscriptions);
    return SubscriptionsList.fromJson(response.data);
  }

  @override
  Future<ArticleDatasDTO> getSubscriptionsHis(int page, int id) async {
    Response response = await _dio.get('${Api.subscriptionsHis}$id/$page/json');
    return ArticleDatasDTO.fromJson(response.data);
  }
}
