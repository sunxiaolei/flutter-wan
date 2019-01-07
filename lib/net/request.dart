import 'package:wan/model/dto/addtodo_dto.dart';
import 'package:wan/model/dto/login_dto.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/model/dto/homebanner_dto.dart';
import 'package:wan/model/dto/articledatas_dto.dart';
import 'package:wan/model/dto/hotkey_dto.dart';
import 'package:wan/model/dto/navi_dto.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/model/dto/todolist_dto.dart';
import 'package:wan/model/dto/update_dto.dart';
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
  Future<ArticleDatasDTO> getHomeList(int index);

  //获取banner
  Future<List<BannerDataDTO>> getHomeBanner();

  //获取导航数据
  Future<List<NaviDTO>> getNavi();

  //获取搜索热词
  Future<List<HotKeyDTO>> getHotKey();

  //搜索
  Future<ArticleDatasDTO> search(int page, String keyword);

  //获取公众号列表
  Future<List<SubscriptionsDTO>> getSubscriptions();

  //获取某个公众号历史文章
  Future<ArticleDatasDTO> getSubscriptionsHis(int page, int id, String keyword);

  //登录
  Future<LoginDTO> login(String username, String password);

  //注册
  Future<LoginDTO> register(
      String username, String password, String repassword);

  //登出
  Future<Null> logout();

  //获取收藏列表
  Future<ArticleDatasDTO> getFavorite(int index);

  //收藏文章
  Future<Null> favorite(int id);

  //取消收藏
  Future<Null> favoriteCancel(int id);

  //检测更新
  Future<UpdateDTO> checkUpdate();

  //获取TODO列表
  ///页码从1开始，拼接在url 上
  //	status 状态， 1-完成；0未完成; 默认全部展示；
  //	type 创建时传入的类型, 默认全部展示
  //	priority 创建时传入的优先级；默认全部展示
  //	orderby 1:完成日期顺序；2.完成日期逆序；3.创建日期顺序；4.创建日期逆序(默认)；
  Future<TodoListDTO> getTodoList(int index, int type);

  //更新Todo状态
  Future<TodoDTO> updateTodoStatus(int id, int status);

  //新增TODO
  Future<TodoDTO> addTodo(AddTodoDTO param);
}
