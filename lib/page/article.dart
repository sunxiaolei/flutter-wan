import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wan/app.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/loading.dart';

///文章页面
class ArticlePage extends StatefulWidget {
  final String url;
  final bool fav; //是否收藏

  ArticlePage(this.url, {this.fav});

  @override
  State<StatefulWidget> createState() {
    return new Article();
  }
}

class Article extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    AppBar ab;
    if (widget.fav == null) {
      ab = AppBar(
        title: new Text("文章"),
      );
    } else {
      ab = AppBar(
        title: Text("文章"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              WanApp.isLogin && widget.fav
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              if (WanApp.isLogin) {
                if (widget.fav) {
                  ToastUtils.showShort('取消收藏');
                } else {
                  ToastUtils.showShort('添加收藏');
                }
              } else {
                ToastUtils.showShort('请先登录');
              }
            },
          )
        ],
      );
    }
    return new WebviewScaffold(
      url: widget.url,
      appBar: ab,
      initialChild: Center(
        child: Loading(),
      ),
    );
  }
}
