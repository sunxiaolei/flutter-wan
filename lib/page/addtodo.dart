import 'package:flutter/material.dart';
import 'package:wan/widget/date.dart';

class AddTodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddTodoState();
  }
}

class AddTodoState extends State<AddTodoPage> {
  DateTime _fromDateTime = DateTime.now();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '标题',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: '必填',
                  ),
                ),
                Divider(),
                Text(
                  '详情',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: '非必填',
                  ),
                  maxLines: 5,
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
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
