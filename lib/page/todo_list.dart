import 'package:flutter/material.dart';
import 'package:wan/event/event.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/model/vo/todolist_vo.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/addtodo.dart';
import 'package:wan/page/todo_item.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/loading.dart';
import 'package:wan/widget/pullrefresh/pullrefresh.dart';

//待办事项列表
class TodoListPage extends StatefulWidget {
  final int type;
  final TodoListVO vo;

  const TodoListPage(this.type, this.vo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoListPage> with TickerProviderStateMixin {
  GlobalKey<PullRefreshState> _key = GlobalKey();
  int index = 1;
  List<TodoDTO> _listDatas;

  @override
  void initState() {
    super.initState();
    _refresh();
    bus.on<EditTodoEvent>().listen((e) {
      if (e.type == widget.type) {
        _refresh();
      }
    });
  }

  Future<Null> _refresh() async {
    index = 1;
    Request().getTodoList(index, widget.type).then((data) {
      if (data.datas != null) {
        setState(() {
          _listDatas = data.datas;
          index++;
        });
      }
    }).catchError((e) {
      ToastUtils.showShort(e.message);
    });
  }

  //加载数据
  Future<Null> _loadMore() async {
    Request().getTodoList(index, widget.type).then((data) {
      setState(() {
        _listDatas.addAll(data.datas);
        index++;
      });
    }).catchError((e) {
      ToastUtils.showShort(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.vo.name),
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TodoDetailPage(
                                type: widget.type,
                              ),
                          fullscreenDialog: true));
                })
          ],
        ),
        body: Container(
          color: Theme.of(context).cardColor,
          child: Hero(
              tag: widget.vo.name,
              child: _listDatas == null
                  ? Center(
                      child: Loading(),
                    )
                  : Container(
                      child: PullRefresh(
                        key: _key,
                        onRefresh: _refresh,
                        onLoadmore: _loadMore,
                        scrollView: ListView(
                          children:
                              _listDatas.map((dto) => TodoItem(dto)).toList(),
                        ),
                      ),
                    )),
        ));
  }
}
