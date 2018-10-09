import 'package:flutter/material.dart';

void main() => runApp(new Wan());

class Wan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Text getBottomText(data) {
      return new Text(data,
          style: TextStyle(color: Color(0xff000000), fontSize: 14.0));
    }

    Image getBottomIcon(path) {
      return Image.asset(
        path,
        width: 15.0,
        height: 15.0,
      );
    }

    return new MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('WanFlutter'),
      ),
      drawer: Drawer(),
      floatingActionButton:
          FloatingActionButton(child: Text('W'), onPressed: null),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
            icon: getBottomIcon('images/home.png'), title: getBottomText('A')),
        new BottomNavigationBarItem(
            icon: getBottomIcon('images/home.png'), title: getBottomText('B')),
        new BottomNavigationBarItem(
            icon: getBottomIcon('images/home.png'), title: getBottomText('C')),
        new BottomNavigationBarItem(
            icon: getBottomIcon('images/home.png'), title: getBottomText('D'))
      ]),
    ));
  }
}
