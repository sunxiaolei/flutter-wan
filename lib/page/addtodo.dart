import 'package:flutter/material.dart';
import 'package:wan/event/event.dart';
import 'package:wan/model/dto/addtodo_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/utils/commonutils.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/date.dart';

class AddTodoPage extends StatefulWidget {
  final int type;

  const AddTodoPage(
    this.type, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddTodoState();
  }
}

class AddTodoState extends State<AddTodoPage> {
  GlobalKey<FormState> _form = GlobalKey();
  DateTime _fromDateTime = DateTime.now();
  String _title;
  String _content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加待办清单'),
      ),
      body: Container(
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
                    Row(
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
                  ],
                )),
          ),
        ),
      ),
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
      Navigator.pop(context);
      Navigator.pop(context);
      bus.fire(AddTodoEvent());
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }
}
