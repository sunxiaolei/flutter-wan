import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wan/model/homedata.dart';
import 'package:wan/ui/article.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ItemListWidget();
  }
}

class ItemListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ItemList();
  }
}

class ItemList extends State<ItemListWidget> {
  List<Datas> listDatas = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //异步加载数据
  Future<Null> loadData() async {
    String dataUrl = "http://www.wanandroid.com/article/list/0/json";
    http.Response response = await http.get(dataUrl);
    HomeData resData = HomeData.fromJson(json.decode(response.body));
    setState(() {
      listDatas = resData.data.datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new ListView.builder(
        itemBuilder: (context, index) {
          return buildItem(listDatas[index]);
        },
        itemCount: listDatas.length,
      ),
      onRefresh: loadData,
    );
  }

  //创建item
  ListTile buildItem(Datas data) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(
          data.chapterName,
          style: new TextStyle(fontSize: 9.0, color: new Color(0xffffffff)),
        ),
        backgroundColor: new Color(0xff1E88E5),
      ),
      title: new Text(
        data.title,
        style: titleTextStyle,
        softWrap: false, //是否自动换行
        overflow: TextOverflow.ellipsis, //截断处理
      ),
      subtitle: new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
            "作者:" + data.author,
            style: subTextStyle,
          )),
          new Text(
            "时间:" + data.niceDate,
            style: subTextStyle,
          ),
        ],
      ),
      trailing: new Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute<Null>(builder: (context) {
          return new ArticlePage(data.link);
        }));
      },
    );
  }

  TextStyle titleTextStyle =
      new TextStyle(color: Color(0xff333333), fontSize: 15.0);
  TextStyle subTextStyle =
      new TextStyle(color: Color(0xff666666), fontSize: 12.0);
}
