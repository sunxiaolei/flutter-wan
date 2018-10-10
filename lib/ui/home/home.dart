import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new ItemListWidget(),
      onRefresh: loadData,
    );
  }

  Future<Null> loadData() async {
    return null;
  }
}

class ItemListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ItemList();
  }
}

class ItemList extends State<ItemListWidget> {
  @override
  Widget build(BuildContext context) {
    List<ListTile> items = new List();
    for (var i = 0; i < 10; i++) {
      items.add(buildItem(i));
    }
    return new ListView.builder(
      itemBuilder: (context, index) {
        return items[index];
      },
      itemCount: items.length,
    );
  }

  ListTile buildItem(pos) {
    return new ListTile(
      leading: new CircleAvatar(),
      title: new Text('Item' + pos.toString()),
      subtitle: new Text('ItemSubTitle'),
      trailing: new Icon(Icons.keyboard_arrow_right),
      onTap: () {},
    );
  }
}
