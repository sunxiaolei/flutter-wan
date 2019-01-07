import 'package:flutter/material.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/net/request.dart';
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
    return Card(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
              onChanged: (bool) {
                _updateStatus(bool);
              },
              value: _checked,
            ),
            Expanded(
                child: Text(
              widget.todo.title == null ? '' : widget.todo.title,
              overflow: TextOverflow.ellipsis,
              style: _checked
                  ? TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    )
                  : TextStyle(fontSize: 16),
            )),
          ],
        ),
      ),
    );
  }

  _updateStatus(bool) {
    CommonUtils.showLoading(context);
    Request().updateTodoStatus(widget.todo.id, bool ? 1 : 0).then((data) {
      Navigator.pop(context);
      setState(() {
        _checked = bool;
      });
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }
}
