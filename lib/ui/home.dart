import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wan/model/homedata.dart';
import 'package:wan/net/request.dart';
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
    loadData(1);
  }

  Future<Null> refresh() async {
    HomeData data = await Request.getHomeList(0);
    setState(() {
      listDatas = data.data.datas;
    });
    return null;
  }

  void loadData(int index) async {
    HomeData data = await Request.getHomeList(index);
    setState(() {
      listDatas = data.data.datas;
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
      onRefresh: refresh, //下拉刷新
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
        Navigator.of(context)
            .push(new MaterialPageRoute<Null>(builder: (context) {
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
