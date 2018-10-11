import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wan/model/homedata.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new ItemListWidget(),
      onRefresh: loadData,
    );
  }

  Future<Null> loadData() async {}
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

  void loadData() async {
    String dataUrl = "http://www.wanandroid.com/article/list/0/json";
    http.Response response = await http.get(dataUrl);
    HomeData data = HomeData.fromJson(json.decode(response.body));
    setState(() {
      listDatas = data.data.datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, index) {
        return buildItem(listDatas[index]);
      },
      itemCount: listDatas.length,
    );
  }

  ListTile buildItem(Datas data) {
    return new ListTile(
      leading: new CircleAvatar(),
      title: new Text(data.title),
      subtitle: new Text(data.desc),
      trailing: new Icon(Icons.keyboard_arrow_right),
      onTap: () {},
    );
  }
}
