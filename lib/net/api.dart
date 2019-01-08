///接口地址
class Api {
  //Base
  static String baseUrl = 'http://www.wanandroid.com/';

  //首页列表
  static String homelist = 'article/list/';

  //首页banner
  static String homebanner = 'banner/json/';

  //导航
  static String navi = 'navi/json';

  //搜索热词
  static String hotkey = '/hotkey/json';

  //搜索
  static String search = 'article/query/';

  //公众号列表
  static String subscriptions = 'wxarticle/chapters/json';

  //查看某个公众号历史数据
  static String subscriptionsHis = 'wxarticle/list/';

  //登录
  static String login = 'user/login';

  //注册
  static String register = 'user/register';

  //登出
  static String logout = 'user/logout/json';

  //收藏文章列表
  static String favoriteList = 'lg/collect/list/';

  //收藏
  static String favorite = 'lg/collect/';

  //取消收藏
  static String favoriteCancel = 'lg/uncollect_originId/';

  //检测更新
  static String checkUpdate =
      'https://raw.githubusercontent.com/sunxiaolei/flutter-wan/master/update.conf';

  //TODO列表
  static String todoList = 'lg/todo/v2/list/';

  //更新TODO状态
  static String updateTodoStatus = 'lg/todo/done/';

  //新增TODO
  static String addTodo = 'lg/todo/add/json';

  //删除TODO
  static String deleteTodo = 'lg/todo/delete/';

  //更新TODO
  static String updateTodo = 'lg/todo/update/';
}
