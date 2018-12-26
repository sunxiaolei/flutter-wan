import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PullLoadWidget extends StatefulWidget {
  final Key key;
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback onRefresh;
  final RefreshCallback onLoadmore;
  final PullLoadWidgetControl control;

  PullLoadWidget(
      {this.key,
      this.itemBuilder,
      this.onRefresh,
      this.onLoadmore,
      this.control})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PullLoadState();
  }
}

class PullLoadState extends State<PullLoadWidget> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //滑动监听
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (widget.control.needLoadMore) {
          widget.onLoadmore?.call();
        }
      }
    });
  }

  ///根据配置状态返回实际列表数量
  ///实际上这里可以根据你的需要做更多的处理
  ///比如多个头部，是否需要空页面，是否需要显示加载更多。
  _getListCount() {
    ///是否需要头部
    if (widget.control.needHeader) {
      ///如果需要头部，用Item 0 的 Widget 作为ListView的头部
      ///列表数量大于0时，因为头部和底部加载更多选项，需要对列表数据总数+2
      return (widget.control.dataList.length > 0)
          ? widget.control.dataList.length + 2
          : widget.control.dataList.length + 1;
    } else {
      ///如果不需要头部，在没有数据时，固定返回数量1用于空页面呈现
      if (widget.control.dataList.length == 0) {
        return 1;
      }

      ///如果有数据,因为部加载更多选项，需要对列表数据总数+1
      return (widget.control.dataList.length > 0)
          ? widget.control.dataList.length + 1
          : widget.control.dataList.length;
    }
  }

  ///根据配置状态返回实际列表渲染Item
  _getItem(int index) {
    if (!widget.control.needHeader &&
        index == widget.control.dataList.length &&
        widget.control.dataList.length != 0) {
      ///如果不需要头部，并且数据不为0，当index等于数据长度时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (widget.control.needHeader &&
        index == _getListCount() - 1 &&
        widget.control.dataList.length != 0) {
      ///如果需要头部，并且数据不为0，当index等于实际渲染长度 - 1时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (!widget.control.needHeader &&
        widget.control.dataList.length == 0) {
      ///如果不需要头部，并且数据为0，渲染空页面
      return _buildEmpty();
    } else {
      ///回调外部正常渲染Item，如果这里有需要，可以直接返回相对位置的index
      return widget.itemBuilder(context, index);
    }
  }

  ///空页面
  Widget _buildEmpty() {
    return new Container(
      height: MediaQuery.of(context).size.height - 100,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Icon(
              Icons.hourglass_empty,
            ),
          ),
          Container(
            child: Text('空页面'),
          ),
        ],
      ),
    );
  }

  ///上拉加载更多
  Widget _buildProgressIndicator() {
    ///是否需要显示上拉加载更多的loading
    Widget bottomWidget = (widget.control.needLoadMore)
        ? new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                ///loading框
                SpinKitFadingCircle(
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.red : Colors.green,
                      ),
                    );
                  },
                ),
                new Container(
                  width: 5.0,
                ),

                ///加载中文本
                new Text(
                  '加载中',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ])

        /// 不需要加载
        : new Container();
    return new Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Center(
        child: bottomWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class PullLoadWidgetControl {
  ///数据，对齐增减，不能替换
  List dataList = new List();

  ///是否需要加载更多
  bool needLoadMore = true;

  ///是否需要头部
  bool needHeader = false;
}
