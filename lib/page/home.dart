import 'package:flutter/material.dart';
import 'package:wan/net/request.dart';
import 'package:wan/widget/articlelist.dart';
import 'package:wan/page/search.dart';
import 'package:wan/utils/toastutils.dart';

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
  GlobalKey<ArticleListWidgetState> _listKey = GlobalKey();
  int index = 1;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  //刷新
  Future<Null> _refresh() async {
    index = 0;
    Request().getHomeList(0).then((data) {
      _listKey.currentState.setData(data.data.datas);
    }).catchError((e) {
      debugPrint('error::' + e.toString());
      ToastUtils.showShort("获取数据失败，请检查网路");
    });
    setState(() {});
  }

  //加载数据
  Future<Null> _loadMore(int index) async {
    Request().getHomeList(index).then((data) {
      _listKey.currentState.addData(data.data.datas);
      index++;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //标题栏
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
      ),
      body: ArticleListWidget(
        key: _listKey,
        hasBanner: true,
        onLoadRefresh: (refresh) {
          if (refresh) {
            _refresh();
          } else {
            _loadMore(index);
          }
        },
      ),
    );
  }
}
