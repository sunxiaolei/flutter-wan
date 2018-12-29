import 'package:flutter/material.dart';
import 'package:wan/model/dto/articledatas_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article_list_item.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/loading.dart';
import 'package:wan/widget/pullrefresh/pullrefresh.dart';

///公众号文章列表
class SubscriptionList extends StatefulWidget {
  final id;
  final String keyword;

  const SubscriptionList({Key key, this.id, this.keyword: ''})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubscriptionListState();
  }
}

class SubscriptionListState extends State<SubscriptionList>
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
    Request()
        .getSubscriptionsHis(index, widget.id, widget.keyword)
        .then((data) {
      setState(() {
        _listDatas = data.datas;
        index++;
      });
    }).catchError((e) {
      ToastUtils.showShort(e.message);
    });
  }

  //加载数据
  Future<Null> _loadMore() async {
    Request()
        .getSubscriptionsHis(index, widget.id, widget.keyword)
        .then((data) {
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
