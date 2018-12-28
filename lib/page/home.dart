import 'package:flutter/material.dart';
import 'package:wan/model/articledatas_dto.dart';
import 'package:wan/model/homebanner_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article.dart';
import 'package:wan/page/article_list_item.dart';
import 'package:wan/page/search.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/loading.dart';
import 'package:wan/widget/pullrefresh/pullrefresh.dart';

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
  GlobalKey<PullRefreshState> _key = GlobalKey();
  int index = 1;
  List<BannerData> _listBanners;
  PageView _bannerViews;
  List<Datas> _listDatas;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  //刷新
  Future<Null> _refresh() async {
    index = 1;
    Request().getHomeBanner().then((data) {
      _listBanners = data.data;
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
    setState(() {});
    Request().getHomeList(0).then((data) {
      setState(() {
        _listDatas = data.data.datas;
        index++;
      });
    }).catchError((e) {
      debugPrint('error::' + e.toString());
      ToastUtils.showShort("获取数据失败，请检查网路");
    });
  }

  //加载数据
  Future<Null> _loadMore() async {
    Request().getHomeList(index).then((data) {
      setState(() {
        _listDatas.addAll(data.data.datas);
        index++;
      });
    });
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
    return Scaffold(
      //标题栏
      appBar: AppBar(
        title: Text('WanFlutter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchWidget(0)));
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: _listDatas == null
          ? Center(
              child: Loading(),
            )
          : PullRefresh(
              key: _key,
              onRefresh: _refresh,
              onLoadmore: _loadMore,
              scrollView: ListView.builder(
                itemBuilder: (context, index) {
                  return _buildItem(index);
                },
                itemCount: _listDatas.length,
              ),
            ),
    );
  }

  ///创建banner
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
    if (_listBanners != null) {
      if (index == 0) {
        return Container(
          height: 200.0,
          child: _bannerViews,
        );
      } else {
        Datas data = _listDatas[index - 1];
        return ArticleListItemWidget(data);
      }
    } else {
      Datas data = _listDatas[index];
      return ArticleListItemWidget(data);
    }
  }
}
