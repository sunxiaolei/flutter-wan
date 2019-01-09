import 'package:flutter/material.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/todo_detail.dart';
import 'package:wan/utils/commonutils.dart';
import 'package:wan/utils/toastutils.dart';

class TodoItem extends StatefulWidget {
  final TodoDTO todo;

  const TodoItem(this.todo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodoState();
  }
}

class TodoState extends State<TodoItem> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.todo.status == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Theme(
                  data: Theme.of(context).copyWith(
                    toggleableActiveColor: Theme.of(context).highlightColor,
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    onChanged: (bool) {
                      _updateStatus(bool);
                    },
                    value: _checked,
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.todo.title == null ? '' : widget.todo.title,
                    overflow: TextOverflow.ellipsis,
                    style: _checked
                        ? TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          )
                        : TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.todo.dateStr == null
                        ? ''
                        : '预计完成时间：' + widget.todo.dateStr,
                    overflow: TextOverflow.ellipsis,
                    style: _checked
                        ? TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          )
                        : TextStyle(fontSize: 13, color: Colors.white),
                  )
                ],
              )),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TodoDetailPage(
                                dto: widget.todo,
                              )));
                },
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '详情',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  //更改完成状态
  _updateStatus(bool) {
    CommonUtils.showLoading(context);
    Request().updateTodoStatus(widget.todo.id, bool ? 1 : 0).then((data) {
      Navigator.pop(context);
      setState(() {
        _checked = bool;
        widget.todo.status = _checked ? 1 : 0;
      });
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }
}
