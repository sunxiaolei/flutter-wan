import 'package:flutter/material.dart';
import 'package:wan/model/dto/navi_dto.dart';
import 'package:wan/model/vo/flowitem_vo.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article.dart';
import 'package:wan/widget/flowitems.dart';
import 'package:wan/widget/loading.dart';

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
  List<FlowItemsWidget> _tabpages = List();
  FlowItemsWidget _selectedPage;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Null> getData() async {
    return Request().getNavi().then((datas) {
      _controller = TabController(length: datas.length, vsync: this);
      _tabs = datas
          .map<Tab>((NaviDTO d) => Tab(
                text: d.name,
              ))
          .toList();
      _tabpages = datas
          .map<FlowItemsWidget>((NaviDTO d) => FlowItemsWidget(
              items: d.articles
                  .map((a) => FlowItemVO(a.id, a.title, a.link))
                  .toList(),
              onPress: (item) {
                Navigator.of(context)
                    .push(MaterialPageRoute<Null>(builder: (context) {
                  return ArticlePage(item.link, item.id);
                }));
              }))
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
      return Scaffold(
        appBar: AppBar(
          title: Text('WanFlutter'),
        ),
        body: Center(
          // Loading
          child: Loading(),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('WanFlutter'),
          bottom: TabBar(
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
