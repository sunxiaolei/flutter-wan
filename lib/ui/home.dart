import 'package:flutter/material.dart';
import 'package:wan/ui/articlelist.dart';

///首页列表
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HomeWidget();
  }
}

class _HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<_HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return ArticleListWidget(true);
  }
}
