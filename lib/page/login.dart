import 'package:flutter/material.dart';
import 'package:wan/app.dart';
import 'package:wan/conf/constant.dart';
import 'package:wan/event/event.dart';
import 'package:wan/model/dto/login_dto.dart';
import 'package:wan/net/request.dart';
import 'package:wan/page/registry.dart';
import 'package:wan/utils/commonutils.dart';
import 'package:wan/utils/sputils.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/arc_clipper.dart';
import 'package:wan/widget/pwdfield.dart';

///登录
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return _buildLoginBody(context);
  }

  var deviceSize;

  _buildLoginBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildLoginBackground(context),
          _buildLoginCard(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text('取消'),
        icon: const Icon(Icons.close),
      ),
    );
  }

  _buildLoginBackground(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: ClipPath(
            clipper: ArcClipper(),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Colors.black87],
                  )),
                ),
                Center(
                  child: SizedBox(
                      height: deviceSize.height / 8,
                      width: deviceSize.width / 2,
                      child: FlutterLogo(
                        colors: Colors.yellow,
                      )),
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(),
        )
      ],
    );
  }

  String _name;
  String _pwd;

  //登录
  _login() {
    _formKey.currentState.save();
    if (_name == null || _name.isEmpty) {
      ToastUtils.showShort("请填写用户名");
      return;
    }
    if (_pwd == null || _pwd.isEmpty) {
      ToastUtils.showShort("请填写密码");
      return;
    }
    CommonUtils.showLoading(context);
    Request().login(_name, _pwd).then((result) {
      Navigator.pop(context);
      ToastUtils.showShort('登陆成功');
      WanApp.isLogin = true;
      _setUser(result);
      bus.fire(LoginEvent(data: result));
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }

  void _setUser(LoginDTO user) async {
    SpUtils.setString(Constant.spUserName, user.username);
  }

  _buildLoginCard(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: deviceSize.height / 2 - 50,
              width: deviceSize.width * 0.85,
              child: Card(
                  elevation: 2.0,
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              //用户名
                              TextFormField(
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  hintText: '请输入用户名',
                                  labelText: '用户名',
                                ),
                                onSaved: (str) {
                                  _name = str;
                                },
                              ),
                              //密码
                              PasswordField(
                                labelText: '用户密码',
                                fillColor: Colors.transparent,
                                border: UnderlineInputBorder(),
                                onSaved: (str) {
                                  _pwd = str;
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //登录
                              Center(
                                child: Container(
                                  child: RaisedButton(
                                    child: Center(
                                      child: Container(
                                        child: Text(
                                          '登录',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        padding: EdgeInsets.all(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      _login();
                                    },
                                  ),
                                  margin: EdgeInsets.only(left: 35, right: 35),
                                ),
                              ),
                              //注册
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistryPage(),
                                                fullscreenDialog: true))
                                        .then((dto) {
                                      if (dto != null) {
                                        //注册成功
                                        ToastUtils.showShort('注册成功');
                                        WanApp.isLogin = true;
                                        _setUser(dto);
                                        bus.fire(LoginEvent(data: dto));
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                  child: Text(
                                    '新用户注册',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  )),
                            ],
                          ),
                        ),
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
