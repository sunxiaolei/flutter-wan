import 'package:flutter/material.dart';
import 'package:wan/conf/pagestatus.dart';
import 'package:wan/model/dto/subscriptionslist_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/search.dart';
import 'package:wan/page/subscription_list.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/error_view.dart';
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
  TabController _tabController;
  List<Tab> _tabs;
  int _currentIndex;

  List<SubscriptionList> _tabpages;

  Widget _appbar;
  PageStatus status = PageStatus.LOADING;

  @override
  void initState() {
    super.initState();
    _appbar = AppBar(
      title: Text('WanFlutter'),
    );
    _getData();
  }

  _getData() async {
    Request().getSubscriptions().then((datas) {
      _tabController = TabController(length: datas.length, vsync: this);
      _tabController.addListener(() {
        _currentIndex = _tabpages[_tabController.index].id;
      });
      _tabs = datas
          .map<Tab>((SubscriptionsDTO d) => Tab(
                text: d.name,
              ))
          .toList();
      _tabpages = datas
          .map<SubscriptionList>((SubscriptionsDTO d) => SubscriptionList(
                id: d.id,
              ))
          .toList();

      setState(() {
        _currentIndex = _tabpages[_tabController.index].id;
        _appbar = _buildAppBar();
        status = PageStatus.DATA;
      });
    }).catchError((e) {
      ToastUtils.showShort(e.message);
      setState(() {
        status = PageStatus.ERROR;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
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

  _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
        break;
      case PageStatus.DATA:
        return TabBarView(
          children: _tabpages,
          controller: _tabController,
        );
        break;
      case PageStatus.ERROR:
      default:
        return ErrorView(
          onClick: () {
            _getData();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar,
      body: _buildBody(),
    );
  }
}
