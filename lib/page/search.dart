import 'package:flutter/material.dart';
import 'package:wan/model/articledatas_dto.dart';
import 'package:wan/model/hotkey_dto.dart';
import 'package:wan/model/vo/flowitem_vo.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article.dart';
import 'package:wan/widget/articlelist.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/flowitems.dart';

///搜索页
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SearchWidget();
  }
}

class _SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<_SearchWidget> {
  List<FlowItemVO> _hotkeys = List();
  FlowItemsWidget _hotkeyWidget;
  ArticleListWidget _alist;
  GlobalKey<ArticleListWidgetState> _listKey = GlobalKey();
  int index = 1;
  String _keyword;

  @override
  void initState() {
    super.initState();
    getHotKey();
  }

  ///获取热词
  Future<Null> getHotKey() async {
    return Request().getHotKey().then((data) {
      HotKeyDTO hk = data;
      _hotkeys = hk.data
          .map((data) => FlowItemVO(data.id, data.name, data.link))
          .toList();
      _hotkeyWidget = FlowItemsWidget(
        items: _hotkeys,
        onPress: (item) {
          _keyword = item.name;
          search(_keyword);
        },
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _alist = ArticleListWidget(
      hasBanner: false,
      key: _listKey,
      onLoadRefresh: (refresh) {
        if (refresh) {
          _refresh(_keyword);
        } else {
          _loadMore(_keyword);
        }
      },
    );
    return Scaffold(
        //搜索栏
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.maybePop(context);
              }),
          title: Theme(
              data: Theme.of(context).copyWith(
                  hintColor: Colors.white70,
                  textTheme:
                      TextTheme(subhead: TextStyle(color: Colors.white))),
              child: TextField(
                autofocus: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: '搜索',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (_keyword != null && _keyword.isNotEmpty) {
                          search(_keyword);
                        }
                      },
                      color: Colors.white,
                    )),
                onChanged: (str) {
                  _keyword = str;
                },
              )),
        ),
        //搜索热词 搜索结果
        body: _keyword == null || _keyword.isEmpty ? _hotkeyWidget : _alist);
  }

  ///搜索
  Future<Null> search(keyword) async {
    FocusScope.of(context).requestFocus(FocusNode());
    index = 0;
    Request().search(index, keyword).then((data) {
      ArticleDatasDTO d = data;
      _listKey.currentState.setData(d.data.datas);
    });
    setState(() {});
  }

  //刷新
  Future<Null> _refresh(String keyword) async {
    index = 0;
    Request().search(index, keyword).then((data) {
      _listKey.currentState.setData(data.data.datas);
    }).catchError((e) {
      debugPrint('error::' + e.toString());
      ToastUtils.showShort("获取数据失败，请检查网路");
    });
    setState(() {});
  }

  //加载数据
  Future<Null> _loadMore(String keyword) async {
    Request().search(index, keyword).then((data) {
      _listKey.currentState.addData(data.data.datas);
      index++;
    });
    setState(() {});
  }
}
