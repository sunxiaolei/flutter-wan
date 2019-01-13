import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wan/app.dart';
import 'package:wan/event/event.dart';
import 'package:wan/net/request.dart';
import 'package:wan/utils/commonutils.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/loading.dart';

///文章页面
class ArticlePage extends StatefulWidget {
  final int id;
  final String url;
  final bool fav; //是否收藏

  ArticlePage(this.url, this.id, {this.fav});

  @override
  State<StatefulWidget> createState() {
    return new Article();
  }
}

class Article extends State<ArticlePage> {
  bool _fav;

  @override
  void initState() {
    super.initState();
    _fav = widget.fav;
  }

  _favorite() {
    if (_fav) {
      _cancelFavorite();
    } else {
      _doFavorite();
    }
  }

  Future<Null> _doFavorite() async {
    Request().favorite(widget.id).then((res) {
      setState(() {
        _fav = true;
        bus.fire(FavoriteEvent());
      });
    }).catchError((e) {
      ToastUtils.showShort(e.message);
    });
  }

  Future<Null> _cancelFavorite() async {
    Request().favoriteCancel(widget.id).then((res) {
      setState(() {
        _fav = false;
        bus.fire(FavoriteEvent());
      });
    }).catchError((e) {
      ToastUtils.showShort(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appbar;
    if (_fav == null) {
      _appbar = AppBar(
        title: new Text("文章"),
      );
    } else {
      _appbar = AppBar(
        title: Text("文章"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              WanApp.isLogin && _fav ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              if (WanApp.isLogin) {
                _favorite();
              } else {
                ToastUtils.showShort('请先登录');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              CommonUtils.share(widget.url);
            },
          ),
        ],
      );
    }
    return new WebviewScaffold(
      url: widget.url,
      appBar: _appbar,
      initialChild: Center(
        child: Loading(),
      ),
    );
  }
}
