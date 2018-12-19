import 'package:flutter/material.dart';
import 'package:wan/page/registry.dart';
import 'package:wan/themes.dart';
import 'package:wan/widget/pwdfield.dart';

///登录
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '登录',
        ),
      ),
      //使用SafeArea能很好的解决刘海，不规则屏幕的显示问题
      body: SafeArea(
          child: Form(
              child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            //用户名
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                icon: Icon(Icons.person),
                hintText: '请输入用户名',
                labelText: '用户名',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //密码
            PasswordField(
              labelText: '用户密码',
              border: OutlineInputBorder(),
            ),
            const SizedBox(
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
            Center(
              child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistryPage(),
                            fullscreenDialog: true));
                  },
                  child: Text(
                    '注册',
                    style: TextStyle(decoration: TextDecoration.underline),
                  )),
            )
          ],
        ),
      ))),
    );
  }
}
