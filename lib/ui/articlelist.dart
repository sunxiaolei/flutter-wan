import 'package:flutter/material.dart';
import 'package:wan/model/homebanner.dart';
import 'package:wan/model/homedata.dart';
import 'package:wan/net/request.dart';
import 'package:wan/themes.dart';
import 'package:wan/ui/article.dart';
import 'package:wan/utils/toastutils.dart';

class ArticleListWidget extends StatefulWidget {
  final bool hasBanner;

  ArticleListWidget(this.hasBanner);

  @override
  State<StatefulWidget> createState() {
    return _ArticleListWidgetState();
  }
}

class _ArticleListWidgetState extends State<ArticleListWidget> {
//  bool hasBanner;
  List<BannerData> _listBanners;
  PageView _bannerViews;
  List<Datas> _listDatas;
  ScrollController _scrollController = new ScrollController();
  int _currentPage = 0;

//  _ArticleListWidgetState(this.hasBanner);

  @override
  void initState() {
    super.initState();
    _refresh();
    _scrollController.addListener(() {
      //上拉刷新
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // 滑动到最底部了
        _currentPage++;
        _loadData(_currentPage);
      }
    });
  }

  //刷新
  Future<Null> _refresh() async {
    await Request.getHomeList(0).then((HomeData data) {
      _listDatas = data.data.datas;
    }).catchError((e) {
      ToastUtils.showShort("获取数据失败，请检查网路");
    });
    await Request.getHomeBanner().then((HomeBanner data) {
      _listBanners = data.data;
    }).catchError((e) {
      print(e.toString());
    });
    setState(() {});
    return null;
  }

  //加载数据
  void _loadData(int index) async {
    HomeData data = await Request.getHomeList(index);
    _listDatas.addAll(data.data.datas);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_listBanners != null) {
      _bannerViews = PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return buildBanner(index);
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
      return RefreshIndicator(
        child: new ListView.builder(
          itemBuilder: (context, index) {
            return buildItem(index);
          },
          itemCount: _listDatas.length,
          controller: _scrollController,
        ),
        onRefresh: _refresh, //下拉刷新
      );
    }
  }

  Widget buildBanner(int index) {
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
  Widget buildItem(int index) {
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
    return _ArticleListItemState(data);
  }
}

class _ArticleListItemState extends State<_ArticleListItemWidget> {
  final Datas data;

  _ArticleListItemState(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: new CircleAvatar(
          child: new Text(
            data.chapterName,
            style: new TextStyle(fontSize: 9.0, color: new Color(0xffffffff)),
          ),
          backgroundColor: new Color(0xff1E88E5),
        ),
        title: new Text(
          data.title,
          style: wanTextTheme.theme.title,
          softWrap: false, //是否自动换行
          overflow: TextOverflow.ellipsis, //截断处理
        ),
        subtitle: new Row(
          children: <Widget>[
            new Expanded(
                child: new Text(
              "作者:" + data.author,
              style: wanTextTheme.theme.subtitle,
            )),
            new Text(
              "时间:" + data.niceDate,
              style: wanTextTheme.theme.subtitle,
            ),
          ],
        ),
        trailing: new Icon(Icons.keyboard_arrow_right),
        onTap: () {
          //点击跳转详情
          Navigator.of(context)
              .push(new MaterialPageRoute<Null>(builder: (context) {
            return new ArticlePage(data.link);
          }));
        },
      ),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 15),
    );
  }
}
