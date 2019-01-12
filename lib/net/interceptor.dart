import 'package:dio/dio.dart';
import 'package:wan/utils/logutils.dart';

///拦截器
class LogInterceptor {
  onSend(Options options) {
    Log.i('Log\n' +
        '\n:::request===========================================================================' +
        '\napi:' +
        (options.baseUrl + options.path) +
        '\nheaders:' +
        options.headers.toString() +
        '\ndata:' +
        options.data.toString() +
        '\n:::request============================================================================');
    return options;
  }

  onSuccess(Response response) {
    Log.i('Log\n' +
        '\n:::response============================================================================' +
        '\nheaders:' +
        response.headers.toString() +
        '\ndata:' +
        response.data.toString() +
        '\n:::response============================================================================');
    return response;
  }

  onError(DioError error) {
    Log.i(":::error:" + error.toString());
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        throw DioError(message: '连接超时');
        break;
      case DioErrorType.RESPONSE:
        throw DioError(message: '网络错误：' + error.response.statusCode.toString());
        break;
      default:
        throw DioError(message: '网络错误');
        break;
    }
  }
}
