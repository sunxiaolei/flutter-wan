import 'package:flutter/material.dart';
import 'package:wan/model/dto/todo_dto.dart';

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
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
              onChanged: (bool) {
                setState(() {
                  _checked = bool;
                });
              },
              value: _checked,
            ),
            Expanded(
                child: Text(
              widget.todo.title == null ? '' : widget.todo.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            )),
          ],
        ),
      ),
    );
  }
}
