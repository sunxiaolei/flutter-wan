import 'package:flutter/material.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/event/event.dart';

///我的
class MinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MineState();
  }
}

class _MineState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Mine();
  }
}

class _Mine extends State<_MineState> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Center(
              child: GestureDetector(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'images/avatar.png',
                  width: 80,
                ),
                Text('未登录')
              ],
            ),
            onTap: () {
              ToastUtils.showShort("登录");
            },
          )),
          margin: EdgeInsets.only(top: 40, bottom: 20),
        ),
        Divider(), //分割线
        Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'images/ic_dark.png',
                  width: 30,
                ),
                margin: EdgeInsets.only(left: 15),
              ),
              Container(
                child: Text(
                  '夜间模式',
                  style: TextStyle(fontSize: 16),
                ),
                margin: EdgeInsets.only(left: 5),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  //switch控件
                  child: Switch.adaptive(
                      value: _switchValue,
                      onChanged: (bool) {
                        setState(() {
                          _switchValue = bool;
                          bus.fire(new DarkThemeEvent(bool));
                        });
                      }),
                ),
              ),
            ],
          ),
          height: 40,
        ),
        Divider(),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'images/ic_setting.png',
                  width: 30,
                ),
                margin: EdgeInsets.only(left: 15),
              ),
              Container(
                child: Text(
                  '设置',
                  style: TextStyle(fontSize: 16),
                ),
                margin: EdgeInsets.only(left: 5),
              ),
            ],
          ),
          height: 40,
        ),
        Divider(),
      ],
    );
  }
}
