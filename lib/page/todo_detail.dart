import 'package:flutter/material.dart';
import 'package:wan/event/event.dart';
import 'package:wan/model/dto/todo_add_dto.dart';
import 'package:wan/model/dto/todo_dto.dart';
import 'package:wan/model/dto/todo_update_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/utils/commonutils.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/date.dart';

//待办详情
class TodoDetailPage extends StatefulWidget {
  final int type;
  final TodoDTO dto;

  const TodoDetailPage({Key key, this.type, this.dto}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddTodoState();
  }
}

class AddTodoState extends State<TodoDetailPage> {
  GlobalKey<FormState> _form = GlobalKey();
  DateTime _fromDateTime = DateTime.now(); //计划完成时间
  String _title; //标题
  String _content; //详情

  bool _isAdd = false; //是否是新增
  bool _isEdit = false; //是否是编辑
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerContent = TextEditingController();
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _isAdd = widget.dto == null;
    _controllerTitle.addListener(() {});
    if (!_isAdd) {
      setState(() {
        _controllerTitle.text = widget.dto.title;
        _controllerContent.text = widget.dto.content;
        _checked = widget.dto.status == 1;
        _fromDateTime = DateTime.fromMillisecondsSinceEpoch(widget.dto.date);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controllerTitle.dispose();
    _controllerContent.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdd ? '添加待办清单' : '待办事项'),
      ),
      body: _buildAdd(),
    );
  }

  _buildAdd() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '标题',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: '必填',
                    ),
                    onSaved: (str) {
                      _title = str;
                    },
                    controller: _controllerTitle,
                    enabled: _isAdd || _isEdit,
                  ),
                  Divider(),
                  Text(
                    '详情',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: '非必填',
                    ),
                    maxLines: 5,
                    onSaved: (str) {
                      _content = str;
                    },
                    controller: _controllerContent,
                    enabled: _isAdd || _isEdit,
                  ),
                  Divider(),
                  Text(
                    '计划完成时间',
                    style: TextStyle(fontSize: 18),
                  ),
                  DateItem(
                      dateTime: _fromDateTime,
                      onChanged: (DateTime value) {
                        setState(() {
                          _fromDateTime = value;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  _buildBtns()
                ],
              )),
        ),
      ),
    );
  }

  _buildBtns() {
    return _isAdd
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'),
                color: Colors.grey,
              ),
              RaisedButton(
                onPressed: () {
                  _addTodo();
                },
                child: Text('确定'),
              )
            ],
          )
        : Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isEdit ? _checked : widget.dto.status == 1,
                    onChanged: (bool) {
                      if (_isEdit) {
                        setState(() {
                          _checked = bool;
                        });
                      }
                    },
                  ),
                  Text(_isEdit
                      ? _checked ? '已完成' : '未完成'
                      : widget.dto.status == 1 ? '已完成' : '未完成')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text('确定删除这条待办事项？'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('取消'),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteTodo();
                                    },
                                    child: Text('确定'),
                                  )
                                ],
                              ));
                    },
                    child: Text('删除'),
                    color: Colors.grey,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _isEdit = !_isEdit;
                      });
                    },
                    child: Text(_isEdit ? '取消' : '编辑'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_isEdit) {
                        _updateTodo();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(_isEdit ? '更新' : '返回'),
                  )
                ],
              )
            ],
          );
  }

  //新增待办事项
  _addTodo() {
    _form.currentState.save();
    if (_title == null || _title.isEmpty) {
      ToastUtils.showShort('请填写标题');
      return;
    }
    CommonUtils.showLoading(context);
    String date = _fromDateTime.year.toString() +
        '-' +
        _fromDateTime.month.toString() +
        '-' +
        _fromDateTime.day.toString();
    AddTodoDTO dto = AddTodoDTO(_title, date, widget.type,
        content: _content == null || _content.isEmpty ? '' : _content,
        priority: 0);
    Request().addTodo(dto).then((todo) {
      bus.fire(EditTodoEvent(widget.type));
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }

  //删除待办事项
  _deleteTodo() {
    CommonUtils.showLoading(context);
    Request().deleteTodo(widget.dto.id).then((todo) {
      bus.fire(EditTodoEvent(widget.dto.type));
      ToastUtils.showShort('删除成功');
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }

  //更新待办事项
  _updateTodo() {
    _form.currentState.save();
    if (_title == null || _title.isEmpty) {
      ToastUtils.showShort('请填写标题');
      return;
    }
    CommonUtils.showLoading(context);
    String date = _fromDateTime.year.toString() +
        '-' +
        _fromDateTime.month.toString() +
        '-' +
        _fromDateTime.day.toString();
    TodoUpdateDTO dto = TodoUpdateDTO(
        title: _title,
        date: date,
        type: widget.dto.type,
        content: _content == null || _content.isEmpty ? '' : _content,
        priority: 0,
        id: widget.dto.id,
        status: _checked ? 1 : 0);
    Request().updateTodo(dto).then((todo) {
      bus.fire(EditTodoEvent(widget.dto.type));
      ToastUtils.showShort('更新成功');
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }
}
