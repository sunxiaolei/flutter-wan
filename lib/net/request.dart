import 'package:wan/model/dto/todo_add_dto.dart';
import 'package:wan/model/dto/login_dto.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/model/dto/homebanner_dto.dart';
import 'package:wan/model/dto/articledatas_dto.dart';
import 'package:wan/model/dto/hotkey_dto.dart';
import 'package:wan/model/dto/navi_dto.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/model/dto/todo_update_dto.dart';
import 'package:wan/model/dto/todolist_dto.dart';
import 'package:wan/model/dto/todolist_get_dto.dart';
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
  Future<TodoListDTO> getTodoList(int index, GetTodoListDTO dto);

  //更新Todo状态
  Future<TodoDTO> updateTodoStatus(int id, int status);

  //新增TODO
  Future<TodoDTO> addTodo(AddTodoDTO param);

  //删除TODO
  Future<Null> deleteTodo(int id);

  //新增TODO
  Future<TodoDTO> updateTodo(TodoUpdateDTO param);
}
