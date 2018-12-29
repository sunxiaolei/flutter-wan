import 'package:flutter/material.dart';
import 'package:wan/model/dto/hotkey_dto.dart';
import 'package:wan/model/vo/flowitem_vo.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/article_list.dart';
import 'package:wan/page/subscription_list.dart';
import 'package:wan/widget/flowitems.dart';

///搜索页
class SearchWidget extends StatefulWidget {
  final int type; //0:文章 1:公众号
  final int sId; //公众号id

  const SearchWidget(this.type, {Key key, this.sId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<SearchWidget> {
  List<FlowItemVO> _hotkeys = List();
  FlowItemsWidget _hotkeyWidget;
  GlobalKey<SubscriptionListState> _sKey = GlobalKey();
  GlobalKey<ArticleListState> _aKey = GlobalKey();
  String _keyword;

  @override
  void initState() {
    super.initState();
    getHotKey();
  }

  ///获取热词
  Future<Null> getHotKey() async {
    return Request().getHotKey().then((datas) {
      _hotkeys = datas
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
    return Scaffold(
        //搜索栏
        appBar: _buildAppbar(),
        //搜索热词 搜索结果
        body: _buildBody());
  }

  _buildAppbar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.maybePop(context);
          }),
      title: Theme(
          data: Theme.of(context).copyWith(
              hintColor: Colors.white70,
              textTheme: TextTheme(subhead: TextStyle(color: Colors.white))),
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
    );
  }

  _buildBody() {
    if (widget.type == 0) {
      return _keyword == null || _keyword.isEmpty
          ? _hotkeyWidget
          : ArticleList(
              key: _aKey,
              keyword: _keyword,
            );
    } else {
      return _keyword == null || _keyword.isEmpty
          ? Center(
              child: Text('搜索'),
            )
          : SubscriptionList(
              key: _sKey,
              id: widget.sId,
              keyword: _keyword,
            );
    }
  }

  ///搜索
  Future<Null> search(keyword) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.type == 0) {
      _aKey.currentState.setState(() {});
    } else {
      _sKey.currentState.setState(() {});
    }
  }
}
