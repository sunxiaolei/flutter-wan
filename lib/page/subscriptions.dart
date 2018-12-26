import 'package:flutter/material.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/model/vo/flowitem_vo.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article.dart';
import 'package:wan/page/search.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/articlelist.dart';
import 'package:wan/widget/flowitems.dart';
import 'package:wan/widget/loading.dart';

///微信公众号
class SubscriptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SubscriptionsWidget();
  }
}

class _SubscriptionsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubscriptionsState();
  }
}

class _SubscriptionsState extends State<_SubscriptionsWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TabController _tabController;
  PageController _controller;

  List<Tab> _tabs = List();

  List<ArticleListWidget> _tabpages = List();
  ArticleListWidget _selectedPage;
  GlobalKey<ArticleListWidgetState> _listKey = GlobalKey();
  List<GlobalKey<ArticleListWidgetState>> _listKeys = List();

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(_handleTabSelection);
    getData();
  }

  _handleTabSelection() {
//    setState(() {
//      _selectedPage = _tabpages.elementAt(index);
//    });
  }

  Future<Null> getData() async {
    return Request().getSubscriptions().then((data) {
      _tabController = TabController(length: data.data.length, vsync: this);
      SubscriptionsList subscriptions = data;
      _tabs = subscriptions.data
          .map<Tab>((Data d) => Tab(
                text: d.name,
              ))
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            tabs: _tabs,
            controller: _tabController,
            isScrollable: true,
          ),
        ),
        body: PageView(
          children: _tabpages,
          controller: _controller,
        ),
      );
    }
  }
}
