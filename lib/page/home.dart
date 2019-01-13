import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wan/app.dart';
import 'package:wan/conf/pagestatus.dart';
import 'package:wan/event/event.dart';
import 'package:wan/model/dto/articledatas_dto.dart';
import 'package:wan/model/dto/homebanner_dto.dart';
import 'package:wan/net/api.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article.dart';
import 'package:wan/page/article_list_item.dart';
import 'package:wan/page/search.dart';
import 'package:wan/utils/toast_utils.dart';
import 'package:wan/widget/cardviewpager.dart';
import 'package:wan/widget/error_view.dart';
import 'package:wan/widget/loading.dart';
import 'package:wan/widget/pullrefresh/pullrefresh.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  int index = 1;
  List<BannerDataDTO> _listBanners;
  List<Datas> _listDatas;

  PageStatus status = PageStatus.LOADING;

  @override
  void initState() {
    super.initState();
    bus.on<LoginEvent>().listen((event) {
      _refresh();
    });
    bus.on<FavoriteEvent>().listen((event) {
      _refresh();
    });
    _getPersistCookieJar();
  }

  _getPersistCookieJar() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    PersistCookieJar pcj = new PersistCookieJar(path);
    List<Cookie> cs = pcj.loadForRequest(Uri.parse(Api.baseUrl + Api.login));
    if (cs != null && cs.length > 0) {
      cs.forEach((cookie) {
        if (cookie.name == 'token_pass') {
          WanApp.isLogin = true;
          bus.fire(LoginEvent());
        }
      });
      if (!WanApp.isLogin) {
        _refresh();
      }
    } else {
      _refresh();
    }
  }

  //刷新
  _refresh() async {
    index = 1;
    Request().getHomeBanner().then((data) {
      if (this.mounted) {
        setState(() {
          _listBanners = data;
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
    Request().getHomeList(0).then((data) {
      if (this.mounted) {
        setState(() {
          _listDatas = data.datas;
          index++;
          status = PageStatus.DATA;
        });
      }
    }).catchError((e) {
      ToastUtils.showShort(e.message);
      setState(() {
        status = PageStatus.ERROR;
      });
    });
  }

  //加载数据
  _loadMore() async {
    Request().getHomeList(index).then((data) {
      setState(() {
        _listDatas.addAll(data.datas);
        index++;
      });
    }).catchError((e) {
      ToastUtils.showShort(e.message);
    });
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
                  MaterialPageRoute(builder: (context) => SearchWidget(0)));
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
        break;
      case PageStatus.DATA:
        return PullRefresh(
          onRefresh: _refresh,
          onLoadmore: _loadMore,
          scrollView: ListView.builder(
            itemBuilder: (context, index) {
              return _buildItem(index);
            },
            itemCount: _listDatas.length,
          ),
        );
        break;
      case PageStatus.ERROR:
      default:
        return ErrorView(
          onClick: () {
            _refresh();
          },
        );
    }
  }

  ///创建banner
  Widget _buildBanner(BannerDataDTO dto) {
    return GestureDetector(
      //可以处理手势事件
      child: Card(
        elevation: 3,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: new EdgeInsets.symmetric(horizontal: 10.0),
            child: CachedNetworkImage(
              imageUrl: dto.imagePath,
            )),
      ),
      onTap: () {
        Navigator.of(context)
            .push(new MaterialPageRoute<Null>(builder: (context) {
          return new ArticlePage(dto.url, dto.id);
        }));
      },
    );
  }

  //创建item
  Widget _buildItem(int index) {
    if (_listBanners != null) {
      if (index == 0) {
        return CardViewPager(
            items: _listBanners.map((dto) {
              return _buildBanner(dto);
            }).toList(),
            height: 200.0,
            autoPlay: true);
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
