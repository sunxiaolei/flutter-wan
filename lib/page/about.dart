import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wan/utils/common_utils.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AboutState();
  }
}

class AboutState extends State<AboutPage> {
  String _appName = '';
  String _appVersion = '';

  var deviceSize;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return _build();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _appName = info.appName;
        _appVersion = info.version;
      });
    });
  }

  _build() {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                CommonUtils.share('https://www.pgyer.com/wan_flutter');
              })
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/ic_launcher.png',
                width: 65,
              ),
              Text(
                _appName,
                style: TextStyle(fontSize: 20),
              ),
              Text('v' + _appVersion),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        _buildDes(),
      ],
    );
  }

  _buildDes() {
    return SizedBox(
      width: deviceSize.width * 0.9,
      child: Card(
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '说明',
                style: TextStyle(fontSize: 16),
              ),
              Text('一个简单的玩应用'),
              Row(
                children: <Widget>[
                  Text('本项目仅做'),
                  _buildLinkText('Flutter', 'https://flutterchina.club/'),
                  Text('学习交流使用'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'API由WAN ANDROID提供',
                style: TextStyle(fontSize: 16),
              ),
              _buildLinkText('http://wanandroid.com', 'http://wanandroid.com'),
              SizedBox(
                height: 10,
              ),
              Text(
                '开源地址',
                style: TextStyle(fontSize: 16),
              ),
              _buildLinkText('https://github.com/sunxiaolei/flutter-wan',
                  'https://github.com/sunxiaolei/flutter-wan'),
            ],
          ),
        ),
      ),
    );
  }

  _buildLinkText(String str, String link) {
    return GestureDetector(
      child: Text(str,
          style: new TextStyle(
            color: Colors.lightBlue,
            decoration: TextDecoration.underline,
          )),
      onTap: () => launch(link),
    );
  }
}
