import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wan/app.dart';
import 'package:wan/conf/constant.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/about.dart';
import 'package:wan/page/favorite.dart';
import 'package:wan/page/login.dart';
import 'package:wan/conf/themes.dart';
import 'package:wan/page/todo.dart';
import 'package:wan/utils/commonutils.dart';
import 'package:wan/utils/sputils.dart';
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
  String _name;

  @override
  void initState() {
    super.initState();
    _getTheme();
    bus.on<LoginEvent>().listen((event) {
      setState(() {
        if (event.data == null) {
          _getUser();
        } else {
          _name = event.data.username;
        }
      });
    });
  }

  void _getUser() async {
    SpUtils.getString(Constant.spUserName).then((str) {
      setState(() {
        _name = str;
      });
    });
  }

  void _getTheme() async {
    SpUtils.getBool(Constant.spDarkTheme).then((bool) {
      _switchValue = bool;
      setState(() {});
    });
  }

  void _setTheme(bool dark) async {
    SpUtils.getInt(Constant.spCurTheme).then((int) {
      _switchValue = dark;
      setState(() {
        SpUtils.setBool(Constant.spDarkTheme, dark);
        bus.fire(new ThemeEvent(int, dark));
      });
    });
  }

  //选择主题dialog
  _buildThemesDialogItems() {
    return themes
        .map((t) => SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: t.data.primaryColor,
                    radius: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(t.name)
                ],
              ),
              onPressed: () {
                Navigator.pop(context, themes.indexOf(t));
              },
            ))
        .toList();
  }

  //用户头像、用户名
  _buildHead() {
    return Container(
      child: Center(
          child: GestureDetector(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/avatar.png',
              width: 80,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              _name == null ? '未登录' : _name,
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
        onTap: () {
          if (!WanApp.isLogin) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            //退出登录
            showDialog(
                context: context,
                child: AlertDialog(
                  content: Text('确定要退出登录么？'),
                  actions: <Widget>[
                    FlatButton(
                        child: const Text('取消'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    FlatButton(
                        child: const Text('确定'),
                        onPressed: () {
                          Navigator.pop(context);
                          _logout();
                        })
                  ],
                ));
          }
        },
      )),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      color: Theme.of(context).primaryColor,
    );
  }

  //退出登录
  _logout() {
    CommonUtils.showLoading(context);
    Request().logout().then((res) {
      Navigator.pop(context);
      setState(() {
        WanApp.isLogin = false;
        _name = '未登录';
      });
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }

  _buildItems() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'images/ic_theme.png',
                  color: Theme.of(context).primaryColorLight,
                  width: 25,
                ),
                margin: EdgeInsets.only(left: 15),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                            title: Text('选择主题'),
                            children: _buildThemesDialogItems(),
                          )).then((value) {
                    if (value != null) {
                      SpUtils.setBool(Constant.spDarkTheme, false).then((v) {
                        SpUtils.setInt(Constant.spCurTheme, value).then((v) {
                          bus.fire(new ThemeEvent(value, false));
                        });
                        _switchValue = false;
                      });
                    }
                  });
                },
                child: Container(
                  child: Text(
                    '选择主题',
                    style: TextStyle(fontSize: 16),
                  ),
                  margin: EdgeInsets.only(left: 5),
                ),
              ),
              Expanded(
                  child: Container(
                child: Row(
//                    alignment: Alignment.bottomRight,
                  //switch控件
                  children: <Widget>[
                    Text(
                      '夜间模式',
                      style: TextStyle(fontSize: 12),
                    ),
                    Switch.adaptive(
                        value: _switchValue,
                        onChanged: (bool) {
                          _setTheme(bool);
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              )),
            ],
          ),
          height: 40,
        ),
        Divider(),
        GestureDetector(
          onTap: () {
            if (WanApp.isLogin) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritePage()));
            } else {
              ToastUtils.showShort('请先登录');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'images/ic_favorite.png',
                    color: Theme.of(context).primaryColorLight,
                    width: 25,
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '我的收藏',
                      style: TextStyle(fontSize: 16),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
//                  margin: EdgeInsets.only(left: 5),
                ),
              ],
            ),
            height: 40,
          ),
        ),
        Divider(),
        GestureDetector(
          onTap: () {
            if (WanApp.isLogin) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TodoPage()));
            } else {
              ToastUtils.showShort('请先登录');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'images/ic_todo.png',
                    color: Theme.of(context).primaryColorLight,
                    width: 25,
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      'TODO',
                      style: TextStyle(fontSize: 16),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
//                  margin: EdgeInsets.only(left: 5),
                ),
              ],
            ),
            height: 40,
          ),
        ),
        Divider(),
        GestureDetector(
          onTap: () {
            _checkUpdate();
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'images/ic_update.png',
                    color: Theme.of(context).primaryColorLight,
                    width: 25,
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '检测更新',
                      style: TextStyle(fontSize: 16),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
//                  margin: EdgeInsets.only(left: 5),
                ),
              ],
            ),
            height: 40,
          ),
        ),
        Divider(),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AboutPage()));
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'images/ic_about.png',
                    color: Theme.of(context).primaryColorLight,
                    width: 25,
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '关于',
                      style: TextStyle(fontSize: 16),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
//                  margin: EdgeInsets.only(left: 5),
                ),
              ],
            ),
            height: 40,
          ),
        ),
        Divider(),
      ],
    );
  }

  //检测更新
  _checkUpdate() async {
    CommonUtils.showLoading(context);
    Request().checkUpdate().then((dto) {
      PackageInfo.fromPlatform().then((info) {
        Navigator.pop(context);
        if (dto.version > int.parse(info.buildNumber)) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text('发现新版本' + dto.versionName + '，去更新？'),
                    actions: <Widget>[
                      FlatButton(
                          child: const Text('取消'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      FlatButton(
                          child: const Text('确定'),
                          onPressed: () {
                            Navigator.pop(context);
                            launch(dto.downloadUrl);
                          })
                    ],
                  ));
        } else {
          ToastUtils.showShort('当前已是最新版本');
        }
      });
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WanFlutter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              ToastUtils.showShort('设置');
            },
          )
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          _buildHead(),
          _buildItems(),
        ],
      ),
    );
  }
}
