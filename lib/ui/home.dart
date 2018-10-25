import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wan/model/homebanner.dart';
import 'package:wan/model/homedata.dart';
import 'package:wan/net/request.dart';
import 'package:wan/ui/article.dart';
import 'package:wan/utils/toastutils.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ItemListWidget();
  }
}

class ItemListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ItemList();
  }
}

class ItemList extends State<ItemListWidget> {
  List<Datas> listDatas;
  List<BannerData> listBanners;
  ScrollController scrollController = new ScrollController();
  int currentPage = 0;
  PageView bannerViews;

  @override
  void initState() {
    super.initState();
    refresh();
    scrollController.addListener(() {
      //上拉刷新
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // 滑动到最底部了
        currentPage++;
        loadData(currentPage);
      }
    });
  }

  //刷新
  Future<Null> refresh() async {
    await Request.getHomeList(0).then((HomeData data) {
      listDatas = data.data.datas;
    }).catchError((e) {
      ToastUtils.showShort("获取数据失败，请检查网路");
    });
    //banner
    await Request.getHomeBanner().then((HomeBanner data) {
      listBanners = data.data;
    }).catchError((e) {
      print(e.toString());
    });
    setState(() {});
    return null;
  }

  //加载数据
  void loadData(int index) async {
    HomeData data = await Request.getHomeList(index);
    listDatas.addAll(data.data.datas);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (listBanners != null) {
      bannerViews = PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return buildBanner(index);
        },
        itemCount: listBanners.length,
      );
    }

    if (listDatas == null) {
      return new Center(
        // Loading
        child: new CircularProgressIndicator(),
      );
    } else {
      return new RefreshIndicator(
        child: new ListView.builder(
          itemBuilder: (context, index) {
            return buildItem(index);
          },
          itemCount: listDatas.length,
          controller: scrollController,
        ),
        onRefresh: refresh, //下拉刷新
      );
    }
  }

  //创建item
  Widget buildItem(int index) {
    if (index == 0) {
      return Container(
        height: 200.0,
        child: bannerViews,
      );
    } else {
      Datas data = listDatas[index - 1];
      return new ListTile(
        leading: new CircleAvatar(
          child: new Text(
            data.chapterName,
            style: new TextStyle(fontSize: 9.0, color: new Color(0xffffffff)),
          ),
          backgroundColor: new Color(0xff1E88E5),
        ),
        title: new Text(
          data.title,
          style: titleTextStyle,
          softWrap: false, //是否自动换行
          overflow: TextOverflow.ellipsis, //截断处理
        ),
        subtitle: new Row(
          children: <Widget>[
            new Expanded(
                child: new Text(
              "作者:" + data.author,
              style: subTextStyle,
            )),
            new Text(
              "时间:" + data.niceDate,
              style: subTextStyle,
            ),
          ],
        ),
        trailing: new Icon(Icons.keyboard_arrow_right),
        onTap: () {
          //点击跳转详情
          Navigator.of(context)
              .push(new MaterialPageRoute<Null>(builder: (context) {
            return new ArticlePage(data.link);
          }));
        },
      );
    }
  }

  Widget buildBanner(int index) {
    return GestureDetector(//可以处理手势事件
      child: Image.network(listBanners[index].imagePath),
      onTap: () {
        Navigator.of(context)
            .push(new MaterialPageRoute<Null>(builder: (context) {
          return new ArticlePage(listBanners[index].url);
        }));
      },
    );
  }

  TextStyle titleTextStyle =
      new TextStyle(color: Color(0xff333333), fontSize: 15.0);
  TextStyle subTextStyle =
      new TextStyle(color: Color(0xff666666), fontSize: 12.0);
}
