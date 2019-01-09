import 'package:flutter/material.dart';
import 'package:wan/event/event.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/model/dto/todolist_get_dto.dart';
import 'package:wan/model/vo/todolist_vo.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/todo_detail.dart';
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
  List<TodoItem> _listItems;

  GetTodoListDTO _dto = GetTodoListDTO();

  int _status;

  @override
  void initState() {
    super.initState();
    _dto.type = widget.type;
    _refresh();
    bus.on<EditTodoEvent>().listen((e) {
      if (e.type == widget.type) {
        _dto.type = e.type;
        _refresh();
      }
    });
  }

  Future<Null> _refresh() async {
    index = 1;
    Request().getTodoList(index, _dto).then((data) {
      if (data.datas != null) {
        if (this.mounted) {
          setState(() {
            _listItems = List.from(data.datas
                .map((dto) => TodoItem(
                      dto,
                      key: ObjectKey(dto.status),
                    ))
                .toList());
            index++;
          });
        }
      }
    }).catchError((e) {
      ToastUtils.showShort(e.message);
    });
  }

  //加载数据
  Future<Null> _loadMore() async {
    Request().getTodoList(index, _dto).then((data) {
      setState(() {
        _listItems.addAll(data.datas.map((dto) => TodoItem(dto)).toList());
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
          PopupMenuButton<int>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              _dto.orderby = value;
              _refresh();
            },
            itemBuilder: (context) => <PopupMenuItem<int>>[
                  PopupMenuItem(
                    child: Text('日期顺序'),
                    value: _status == 1 ? 1 : 3,
                  ),
                  PopupMenuItem(
                    child: Text('日期逆序'),
                    value: _status == 1 ? 2 : 4,
                  ),
                ],
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.equalizer),
            onSelected: (value) {
              _status = value;
              _dto.status = value;
              _refresh();
            },
            itemBuilder: (context) => <PopupMenuItem<int>>[
                  PopupMenuItem(
                    child: Text('全部'),
                    value: -1,
                  ),
                  PopupMenuItem(
                    child: Text('未完成'),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text('已完成'),
                    value: 1,
                  ),
                ],
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).cardColor,
        child: Hero(
            tag: widget.vo.name,
            child: _listItems == null
                ? Center(
                    child: Loading(),
                  )
                : Container(
                    child: PullRefresh(
                      key: _key,
                      onRefresh: _refresh,
                      onLoadmore: _loadMore,
                      scrollView: ListView(
                        children: _listItems,
                      ),
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        //新增
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TodoDetailPage(
                        type: widget.type,
                      ),
                  fullscreenDialog: true));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
