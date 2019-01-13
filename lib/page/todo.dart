import 'package:flutter/material.dart';
import 'package:wan/conf/constant.dart';
import 'package:wan/conf/imgs.dart';
import 'package:wan/model/vo/todolist_vo.dart';
import 'package:wan/page/todo_detail.dart';
import 'package:wan/page/todo_list.dart';
import 'package:wan/utils/sp_utils.dart';

///TODO页面
class TodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoState();
  }
}

class TodoState extends State<TodoPage> {
  double _width;
  double _height;
  List<TodoListVO> vos;
  List<IconData> ics;

  String _name;

  @override
  void initState() {
    super.initState();
    SpUtils.getString(Constant.spUserName).then((str) {
      setState(() {
        _name = str;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    vos = [TodoListVO(0, '工作'), TodoListVO(1, '学习'), TodoListVO(2, '生活')];
    ics = [Icons.work, Icons.school, Icons.camera];

    return Container(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('TODO'),
          elevation: 0,
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 50.0, right: 60.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Image.asset(
                              'images/avatar.png',
                              width: 70,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: new Text(
                              _name == null ? '嗨' : '嗨,' + _name,
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            ),
                          ),
                          Text(
                            "如果我们总是等待绝对的一切就绪，那我们将永远无法开始。",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    //TODO类别
                    Container(
                      height: 350,
                      width: _width,
                      child: _buildTodoList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var bgs = [ImagePath.bgCardWork, ImagePath.bgCardStudy, ImagePath.bgCardLife];

  _buildTodoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return TodoListPage(index + 1, vos[index]);
                      },
                      transitionDuration: Duration(milliseconds: 500)),
                ),
            child: Hero(
              tag: vos[index].name,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 20.0, bottom: 30.0),
                child: Card(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    ics[index],
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    vos[index].name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TodoDetailPage(
                                                type: index + 1,
                                              )));
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Image.asset(bgs[index]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      },
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      scrollDirection: Axis.horizontal,
      itemExtent: _width - 80,
      itemCount: 3,
    );
  }
}
