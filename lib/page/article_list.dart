import 'package:flutter/material.dart';
import 'package:wan/model/dto/articledatas_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article_list_item.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/loading.dart';
import 'package:wan/widget/pullrefresh/pullrefresh.dart';

///文章列表
class ArticleList extends StatefulWidget {
  final id;
  final String keyword;

  const ArticleList({Key key, this.id, this.keyword: ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArticleListState();
  }
}

class ArticleListState extends State<ArticleList>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<PullRefreshState> _key = GlobalKey();
  int index = 1;
  List<Datas> _listDatas;

  @override
  void initState() {
    super.initState();
    _refresh();
  } //刷新

  Future<Null> _refresh() async {
    index = 1;
    Request().search(index, widget.keyword).then((data) {
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
    Request().search(index, widget.keyword).then((data) {
      setState(() {
        _listDatas.addAll(data.data.datas);
        index++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _listDatas == null
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
          );
  }

  //创建item
  Widget _buildItem(int index) {
    Datas data = _listDatas[index];
    return ArticleListItemWidget(data);
  }

  @override
  bool get wantKeepAlive => true;
}
