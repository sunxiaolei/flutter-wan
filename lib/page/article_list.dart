import 'package:flutter/material.dart';
import 'package:wan/model/articledatas_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article.dart';
import 'package:wan/widget/common_list.dart';
import 'package:wan/widget/pullload.dart';
import 'package:wan/widget/tags.dart';

///文章列表
class ArticleList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArticleListState();
  }
}

class _ArticleListState extends State<ArticleList>
    with
        AutomaticKeepAliveClientMixin<ArticleList>,
        CommonListState<ArticleList>,
        WidgetsBindingObserver {
  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 0;
    ArticleDatasDTO data = await Request().getHomeList(page);
    var result = data.data.datas;
    setState(() {
      pullLoadWidgetControl.needLoadMore =
          (result != null && result.length == 20);
    });
    isLoading = false;
    return null;
  }

  @override
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    ArticleDatasDTO data = await Request().getHomeList(page);
    var result = data.data.datas;
    setState(() {
      pullLoadWidgetControl.needLoadMore = (result != null);
    });
    isLoading = false;
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PullLoadWidget(
      onRefresh: handleRefresh,
      onLoadmore: onLoadMore,
      key: refreshIndicatorKey,
      control: pullLoadWidgetControl,
      itemBuilder: (context, index) {
        return _ArticleListItemWidget(pullLoadWidgetControl.dataList[index]);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;
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
    //去掉html中的高亮
    widget.data.title = widget.data.title
        .replaceAll(RegExp("(<em[^>]*>)|(</em>)"), "")
        .replaceAll("&mdash;", "-");

    widget.data.desc = (null == widget.data.desc)
        ? ""
        : widget.data.desc
            .replaceAll(RegExp("(<em[^>]*>)|(</em>)"), "")
            .replaceAll("&mdash;", "-")
            .replaceAll(RegExp("\n{2,}"), "\n")
            .replaceAll(RegExp("\s{2,}"), " ");
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
