import 'package:flutter/material.dart';
import 'package:wan/conf/themes.dart';
import 'package:wan/widget/pwdfield.dart';

///注册
class RegistryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistryState();
  }
}

class RegistryState extends State<RegistryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String _name;
  String _password;
  String _repassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '注册',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _checkAndSave();
            },
          )
        ],
      ),
      //使用SafeArea能很好的解决刘海，不规则屏幕的显示问题
      body: SafeArea(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    //用户名
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.person),
                        hintText: '请输入用户名',
                        labelText: '用户名',
                      ),
                      validator: _validateName,
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //密码
                    PasswordField(
                      labelText: '用户密码',
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.lock),
                      validator: _validatePassword,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //重复密码
                    PasswordField(
                      labelText: '重复密码',
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.lock),
                      validator: _validatePassword,
                    ),
                  ],
                ),
              ))),
    );
  }

  ///用户名校验
  String _validateName(String value) {
    if (value.isNotEmpty) {
      RegExp nameExp = RegExp(r'^.{6,}$');
      if (nameExp.hasMatch(value)) {
        return null;
      } else {
        return '用户名最少6位';
      }
    }
    return '用户名不能为空';
  }

  ///密码校验
  String _validatePassword(String value) {
    if (value.isNotEmpty) {
      RegExp pwdExp = RegExp(r'^[\w_-]{6,50}$');
      if (pwdExp.hasMatch(value)) {
        return null;
      } else {
        return '密码6~50位且为数字、字母、-、_';
      }
    }
    return '密码不能为空';
  }

  ///注册
  void _checkAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('注册')));
      form.save();
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('请检查必填信息')));
    }
  }
}
