import 'package:flutter/material.dart';
import 'package:wan/conf/imgs.dart';
import 'package:wan/conf/pagestatus.dart';
import 'package:wan/event/event.dart';
import 'package:wan/model/dto/favoritedatas_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/favorite_list_item.dart';
import 'package:wan/utils/toast_utils.dart';
import 'package:wan/widget/empty_view.dart';
import 'package:wan/widget/error_view.dart';
import 'package:wan/widget/loading.dart';
import 'package:wan/widget/pullrefresh/pullrefresh.dart';

///文章列表
class FavoriteList extends StatefulWidget {
  const FavoriteList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FavoriteListState();
  }
}

class FavoriteListState extends State<FavoriteList> {
  GlobalKey<PullRefreshState> _key = GlobalKey();
  int index = 0;
  List<Datas> _listDatas;

  PageStatus status = PageStatus.LOADING;

  @override
  void initState() {
    super.initState();
    _refresh();
    bus.on<FavoriteEvent>().listen((event) {
      _refresh();
    });
  }

  //刷新
  Future<Null> _refresh() async {
    index = 0;
    Request().getFavorite(index).then((data) {
      if (this.mounted) {
        setState(() {
          _listDatas = data.datas;
          index++;
          status = _listDatas.length == 0 ? PageStatus.EMPTY : PageStatus.DATA;
        });
      }
    }).catchError((e) {
      ToastUtils.showShort(e.message);
      status = PageStatus.ERROR;
    });
  }

  //加载数据
  Future<Null> _loadMore() async {
    Request().getFavorite(index).then((data) {
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
    return _buildBody();
  }

  //创建item
  Widget _buildItem(int index) {
    Datas data = _listDatas[index];
    return FavoriteListItemWidget(data);
  }

  _buildBody() {
    switch (status) {
      case PageStatus.LOADING:
        return Loading();
        break;
      case PageStatus.DATA:
        return PullRefresh(
            key: _key,
            onRefresh: _refresh,
            onLoadmore: _loadMore,
            scrollView: ListView.builder(
              itemBuilder: (context, index) {
                return _buildItem(index);
              },
              itemCount: _listDatas.length,
            ));
        break;
      case PageStatus.ERROR:
        return ErrorView(
          onClick: () {
            _refresh();
          },
        );
        break;
      case PageStatus.EMPTY:
      default:
        return EmptyView(
          iconPath: ImagePath.icEmpty,
          hint: '暂无内容，点击重试',
          onClick: () {
            _refresh();
          },
        );
    }
  }
}
