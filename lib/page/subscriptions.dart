import 'package:flutter/material.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/search.dart';
import 'package:wan/page/subscription_list.dart';
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
  List<Tab> _tabs;
  int _currentIndex;

  List<SubscriptionList> _tabpages;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Null> getData() async {
    return Request().getSubscriptions().then((data) {
      _tabController = TabController(length: data.data.length, vsync: this);
      _tabController.addListener(() {
        _currentIndex = _tabpages[_tabController.index].id;
      });
      SubscriptionsList subscriptions = data;
      _tabs = subscriptions.data
          .map<Tab>((Data d) => Tab(
                text: d.name,
              ))
          .toList();
      _tabpages = subscriptions.data
          .map<SubscriptionList>((Data d) => SubscriptionList(
                id: d.id,
              ))
          .toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _buildAppBar() {
    return AppBar(
      title: Text('WanFlutter'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchWidget(
                          1,
                          sId: _currentIndex,
                        )));
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs == null) {
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
        appBar: _buildAppBar(),
        body: TabBarView(
          children: _tabpages,
          controller: _tabController,
        ),
      );
    }
  }
}
