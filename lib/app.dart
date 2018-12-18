import 'package:flutter/material.dart';
import 'package:wan/themes.dart';
import 'package:wan/ui/category.dart';
import 'package:wan/ui/home.dart';
import 'package:wan/ui/mine.dart';
import 'package:wan/ui/navi.dart';
import 'package:wan/event/event.dart';
import 'package:wan/utils/toastutils.dart';

///主页
class WanApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WanAppState();
  }
}

class _WanAppState extends State<WanApp> {
  int _tabIndex = 0; //当前页面
  var _titles = ['首页', '分类', '导航', '我的']; //导航栏标题

  @override
  void initState() {
    super.initState();
    bus.on<DarkThemeEvent>().listen((event) {
      setState(() {
        //切换主题
        dark = event.darkTheme;
      });
    });
  }

  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: dark ? darkTheme.data : lightTheme.data,
      // Scaffold:Material Design布局结构的基本实现。
      // 此类提供了用于显示drawer、snackbar和底部sheet的API
      home: Scaffold(
        //标题栏
        appBar: AppBar(
          title: Text('WanFlutter'),
        ),
        //悬浮按钮
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
        //底部导航栏
        bottomNavigationBar: BottomNavigationBar(
          //导航栏元素
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: _getNavText(_titles[0])),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: _getNavText(_titles[1])),
            BottomNavigationBarItem(
                icon: Icon(Icons.navigation), title: _getNavText(_titles[2])),
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
            CategoryPage(),
            NaviPage(),
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
