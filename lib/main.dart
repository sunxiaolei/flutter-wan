import 'package:flutter/material.dart';
import 'package:wan/ui/category.dart';
import 'package:wan/ui/home.dart';
import 'package:wan/ui/mine.dart';
import 'package:wan/ui/navi.dart';

void main() => runApp(new Wan());

class Wan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WanFlutter'),
      ),
      floatingActionButton:
          FloatingActionButton(child: Text('W'), onPressed: null),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: getBottomIcon(icons[0]), title: getBottomText(titles[0])),
          new BottomNavigationBarItem(
              icon: getBottomIcon(icons[1]), title: getBottomText(titles[1])),
          new BottomNavigationBarItem(
              icon: getBottomIcon(icons[2]), title: getBottomText(titles[2])),
          new BottomNavigationBarItem(
              icon: getBottomIcon(icons[3]), title: getBottomText(titles[3]))
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
      ),
      body: pages[tabIndex],
    );
  }

  var tabIndex = 0;

  TextStyle bottomTextStyle =
      TextStyle(color: Color(0xff000000), fontSize: 14.0);

  var titles = ["首页", "分类", "导航", "我的"];
  var icons = [
    'images/home.png',
    'images/home.png',
    'images/home.png',
    'images/home.png'
  ];
  var pages = [
    new HomePage(),
    new CategoryPage(),
    new NaviPage(),
    new MinePage()
  ];

  Text getBottomText(data) {
    return new Text(data, style: bottomTextStyle);
  }

  Image getBottomIcon(path) {
    return Image.asset(
      path,
      width: 15.0,
      height: 15.0,
    );
  }
}
