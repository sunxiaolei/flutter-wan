import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticlePage extends StatelessWidget {
  final String url;

  ArticlePage(this.url);

  @override
  Widget build(BuildContext context) {
    return new ArticleWidget(url);
  }
}

class ArticleWidget extends StatefulWidget {
  final String url;

  ArticleWidget(this.url);

  @override
  State<StatefulWidget> createState() {
    return new Article(url);
  }
}

class Article extends State<ArticleWidget> {
  String url;

  Article(this.url);

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: url,
      appBar: new AppBar(
        title: new Text("文章"),
      ),
    );
  }
}
