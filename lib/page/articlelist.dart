import 'package:flutter/material.dart';
import 'package:wan/model/homebanner.dart';
import 'package:wan/model/homedata.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article.dart';
import 'package:wan/widget/tags.dart';
import 'dart:ui' as ui;

import 'package:wan/widget/totopfab.dart';

class ArticleListWidget extends StatefulWidget {
  final bool hasBanner;
  final LoadCallBack onLoad;

  ArticleListWidget({Key key, this.hasBanner, this.onLoad}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArticleListWidgetState();
  }
}

class ArticleListWidgetState extends State<ArticleListWidget> {
  List<BannerData> _listBanners;
  PageView _bannerViews;
  List<Datas> _listDatas;
  int _currentPage = 0;
  double _screenHeight;
  ScrollController _controller = ScrollController();
  GlobalKey<ToTopFloatActionState> _toTopKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.hasBanner) {
      _getbanner();
    }
  }

  setData(List<Datas> data) {
    _listDatas = data;
    setState(() {});
  }

  addData(List<Datas> data) {
    _listDatas.addAll(data);
    setState(() {});
  }

  //banner
  Future<Null> _getbanner() async {
    Request().getHomeBanner().then((data) {
      _listBanners = data.data;
    }).catchError((e) {
      print(e.toString());
    });
    setState(() {});
  }

  Future<Null> _refresh() async {
    widget.onLoad(true);
  }

  bool onScrollNotification(ScrollNotification scrollNotification) {
    if (scrollNotification.metrics.pixels >=
        scrollNotification.metrics.maxScrollExtent) {
      // 滑动到最底部了
      _currentPage++;
      widget.onLoad(false);
    }
    if (null == _screenHeight || _screenHeight <= 0) {
      _screenHeight = MediaQueryData.fromWindow(ui.window).size.height;
    }
    if (scrollNotification.metrics.axisDirection == AxisDirection.down &&
        _screenHeight >= 10 &&
        scrollNotification.metrics.pixels >= _screenHeight) {
      _toTopKey.currentState.setVisible(true);
    } else {
      _toTopKey.currentState.setVisible(false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_listBanners != null) {
      _bannerViews = PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _buildBanner(index);
        },
        itemCount: _listBanners.length,
      );
    }
    if (_listDatas == null) {
      return new Center(
        // Loading
        child: new CircularProgressIndicator(),
      );
    } else {
      var body = NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildItem(index);
            },
            itemCount: _listDatas.length,
            //如果ListView的内容不足一屏，要设置ListView的physics属性为const AlwaysScrollableScrollPhysics()
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
          ),
          onRefresh: _refresh, //下拉刷新
        ),
      );
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: body,
        floatingActionButton: ToTopFloatActionButton(
          key: _toTopKey,
          onPressed: () {
            _toTop();
          },
        ),
      );
    }
  }

  void _toTop() {
    _controller?.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.elasticInOut);
  }

  @override
  void dispose() {
    _listBanners.clear();
    _listDatas.clear();
    super.dispose();
  }

  Widget _buildBanner(int index) {
    return GestureDetector(
      //可以处理手势事件
      child: Image.network(_listBanners[index].imagePath),
      onTap: () {
        Navigator.of(context)
            .push(new MaterialPageRoute<Null>(builder: (context) {
          return new ArticlePage(_listBanners[index].url);
        }));
      },
    );
  }

  //创建item
  Widget _buildItem(int index) {
    if (widget.hasBanner) {
      if (index == 0) {
        return Container(
          height: 200.0,
          child: _bannerViews,
        );
      } else {
        Datas data = _listDatas[index - 1];
        return _ArticleListItemWidget(data);
      }
    } else {
      Datas data = _listDatas[index];
      return _ArticleListItemWidget(data);
    }
  }
}

class _ArticleListItemWidget extends StatefulWidget {
  final Datas data;

  _ArticleListItemWidget(this.data);

  @override
  State<StatefulWidget> createState() {
    return _ArticleListItemState();
  }
}

class _ArticleListItemState extends State<_ArticleListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            widget.data.title,
            softWrap: true, //是否自动换行
            overflow: TextOverflow.ellipsis, //截断处理
            maxLines: 2,
            style: TextStyle(fontSize: 17),
          ),
        ),
        subtitle: Row(
          children: <Widget>[
            TagsWidget(widget.data.tags),
            Text(
              '作者：',
            ),
            Expanded(
                child: new Text(
              widget.data.author,
              style: TextStyle(color: Theme.of(context).textTheme.body1.color),
            )),
            Text(
              "时间:" + widget.data.niceDate,
            ),
          ],
        ),
        onTap: () {
          //点击跳转详情
          Navigator.of(context)
              .push(new MaterialPageRoute<Null>(builder: (context) {
            return new ArticlePage(widget.data.link);
          }));
        },
        contentPadding:
            EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      ),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 15),
    );
  }
}

typedef LoadCallBack = void Function(bool refresh);
