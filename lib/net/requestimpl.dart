import 'package:wan/model/homebanner.dart';
import 'package:wan/model/homedata.dart';
import 'package:dio/dio.dart';
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
  Future<HomeData> getHomeList(int index) async {
    String reqAPi = Api.homelist + index.toString() + "/json";
    Response response = await _dio.get(reqAPi);
    return HomeData.fromJson(response.data);
  }

  //获取banner
  @override
  Future<HomeBanner> getHomeBanner() async {
    String reqAPi = Api.homebanner;
    Response response = await _dio.get(reqAPi);
    return HomeBanner.fromJson(response.data);
  }
}
