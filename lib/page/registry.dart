import 'package:flutter/material.dart';
import 'package:wan/conf/themes.dart';
import 'package:wan/net/request.dart';
import 'package:wan/utils/commonutils.dart';
import 'package:wan/utils/toastutils.dart';
import 'package:wan/widget/arc_clipper.dart';
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

  var deviceSize;

  @override
  void initState() {
    super.initState();
  }

  _buildLoginBackground(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: ClipPath(
            clipper: ArcClipper(),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Colors.black87],
              )),
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

  _buildCard() {
    deviceSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: deviceSize.height / 2 - 30,
        width: deviceSize.width * 0.85,
        child: Card(
          elevation: 2.0,
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    //用户名
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        hintText: '请输入用户名',
                        labelText: '用户名',
                        fillColor: Colors.transparent,
                      ),
                      validator: _validateName,
                      onSaved: (value) {
                        _name = value;
                      },
                      autofocus: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //密码
                    PasswordField(
                      labelText: '用户密码',
                      border: UnderlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.transparent,
                      validator: _validatePassword,
                      onSaved: (value) {
                        _password = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //重复密码
                    PasswordField(
                      labelText: '重复密码',
                      border: UnderlineInputBorder(),
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.lock),
                      validator: _validateRePassword,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildLoginBackground(context),
          _buildCard(),
        ],
      ),
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

  ///密码校验
  String _validateRePassword(String value) {
    if (value.isNotEmpty) {
      if (_password != null && _password != value) {
        return '两次输入的密码不一致';
      } else {
        return null;
      }
    }
    return '请重新输入密码';
  }

  ///注册
  void _checkAndSave() {
    final FormState form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      _register();
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('请检查必填信息')));
    }
  }

  void _register() {
    CommonUtils.showLoading(context);
    Request().register(_name, _password, _password).then((res) {
      Navigator.pop(context);
      ToastUtils.showShort('注册成功');
      Navigator.pop(context, res);
    }).catchError((e) {
      Navigator.pop(context);
      ToastUtils.showShort(e.message);
    });
  }
}
