import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan/conf/constant.dart';
import 'package:wan/conf/themes.dart';
import 'package:wan/net/api.dart';
import 'package:wan/page/subscriptions.dart';
import 'package:wan/page/home.dart';
import 'package:wan/page/mine.dart';
import 'package:wan/page/navi.dart';
import 'package:wan/event/event.dart';
import 'package:wan/utils/sputils.dart';

///主页
class WanApp extends StatefulWidget {
  static bool isLogin = false;

  @override
  State<StatefulWidget> createState() {
    return _WanAppState();
  }
}

class _WanAppState extends State<WanApp> {
  int _tabIndex = 0; //当前页面
  var _titles = ['首页', '导航', '公众号', '我的']; //导航栏标题

  @override
  void initState() {
    super.initState();
    if (Dio().cookieJar.loadForRequest(Uri.parse(Api.baseUrl + Api.login)) !=
        null) {
      WanApp.isLogin = true;
    }
    _getTheme(null);
    bus.on<ThemeEvent>().listen((event) {
      _getTheme(event);
    });
  }

  void _getTheme(ThemeEvent event) async {
    if (event != null) {
      _dark = event.darkTheme;
      _theme = event.theme;
      setState(() {});
    } else {
      SpUtils.getBool(Constant.spDarkTheme).then((bool) {
        if (bool) {
          _dark = bool;
          setState(() {});
        } else {
          SpUtils.getInt(Constant.spCurTheme).then((int) {
            _theme = int;
            setState(() {});
          });
        }
      });
    }
  }

  bool _dark = false;
  int _theme = 0;

  ThemeData _setTheme() {
    if (_dark) {
      return darkTheme.data;
    } else {
      return themes[_theme].data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _setTheme(),
      // Scaffold:Material Design布局结构的基本实现。
      // 此类提供了用于显示drawer、snackbar和底部sheet的API
      home: Scaffold(
        //底部导航栏
        bottomNavigationBar: BottomNavigationBar(
          //导航栏元素
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: _getNavText(_titles[0])),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: _getNavText(_titles[1])),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), title: _getNavText(_titles[2])),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), title: _getNavText(_titles[3])),
          ],
          type: BottomNavigationBarType.fixed, //显示方式
          currentIndex: _tabIndex,
          //点击切换页面
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
        //界面
        body: IndexedStack(
          children: <Widget>[
            HomePage(),
            NaviPage(),
            SubscriptionsPage(),
            MinePage()
          ],
          index: _tabIndex,
        ),
      ),
    );
  }

  Text _getNavText(text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16),
    );
  }
}
