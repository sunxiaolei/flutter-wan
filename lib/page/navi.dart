import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wan/model/navi.dart';
import 'package:wan/net/request.dart';

///导航
class NaviPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _NaviWidget();
  }
}

class _NaviWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NaviState();
  }
}

class _NaviState extends State<_NaviWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TabController _controller;

  List<Tab> _tabs = List();
  List<_TabWidget> _tabpages = List();
  _TabWidget _selectedPage;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 10, vsync: this);
    _controller.addListener(_handleTabSelection);
    getData();
  }

  _handleTabSelection() {
    setState(() {
      _selectedPage = _tabpages.elementAt(_controller.index);
    });
  }

  Future<Null> getData() async {
    return Request().getNavi().then((data) {
      Navi navi = data;
      _tabs = navi.data
          .map<Tab>((Data d) => Tab(
                text: d.name,
              ))
          .toList();
      _tabpages = navi.data
          .map<_TabWidget>((Data d) => _TabWidget(d.articles))
          .toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.length == 0) {
      return Center(
        // Loading
        child: new CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: TabBar(
            tabs: _tabs,
            controller: _controller,
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: _tabpages,
          controller: _controller,
        ),
      );
    }
  }
}

///子类页面
class _TabWidget extends StatefulWidget {
  final List<Articles> articles;

  _TabWidget(this.articles);

  @override
  State<StatefulWidget> createState() {
    return _TabState();
  }
}

class _TabState extends State<_TabWidget> {
  final List<Widget> children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    List<Widget> _tags = widget.articles
        .map((article) => RaisedButton(
              child: Text(article.title),
              onPressed: () {},
              color: _randomColor(article.title),
              shape: StadiumBorder(),
            ))
        .toList();

    if (_tags.isNotEmpty) {
      children.add(Wrap(
        children: _tags.map((Widget widget) {
          return Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
            child: widget,
          );
        }).toList(),
      ));
    } else {
      children.add(Center(
        child: Text('暂无数据'),
      ));
    }

    return Card(
      child: ListView(
        children: children,
      ),
    );
  }

  Color _randomColor(name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }
}
