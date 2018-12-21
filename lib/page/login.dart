import 'package:flutter/material.dart';
import 'package:wan/page/registry.dart';
import 'package:wan/widget/arc_clipper.dart';
import 'package:wan/widget/pwdfield.dart';

///登录
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
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
                    child: Padding(
                  padding: EdgeInsets.all(18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //用户名
                        TextField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: '请输入用户名',
                            labelText: '用户名',
                          ),
                        ),
                        //密码
                        PasswordField(
                          labelText: '用户密码',
                          fillColor: Colors.transparent,
                          border: UnderlineInputBorder(),
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
                              onPressed: () {},
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
                                      builder: (context) => RegistryPage(),
                                      fullscreenDialog: true));
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

class LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return _buildLoginBody(context);
  }
}
