import 'package:flutter/material.dart';
import 'package:wan/model/vo/todolist_vo.dart';

class TodoListPage extends StatefulWidget {
  final TodoListVO vo;

  const TodoListPage(this.vo, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoListPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.vo.name),
          elevation: 0,
        ),
        body: Container(
          child: Hero(
              tag: widget.vo.name,
              child: Container(
                color: Theme.of(context).cardColor,
              )),
        ));
  }
}
