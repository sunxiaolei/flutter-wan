import 'package:flutter/material.dart';
import 'package:wan/page/favorite_list.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoriteState();
  }
}

class FavoriteState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: FavoriteList(),
    );
  }
}
