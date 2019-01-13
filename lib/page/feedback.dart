import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wan/conf/imgs.dart';
import 'package:wan/net/interceptor.dart';
import 'package:wan/privateIds.dart';
import 'package:wan/utils/common_utils.dart';
import 'package:wan/utils/toast_utils.dart';

//建议与反馈
class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeedbackState();
  }
}

class FeedbackState extends State<FeedbackPage> {
  GlobalKey<EditableTextState> _contentKey = GlobalKey();
  GlobalKey<EditableTextState> _contactKey = GlobalKey();
  TextEditingController _controllerContent = TextEditingController();
  TextEditingController _controllerConTact = TextEditingController();
  String _content; //内容
  String _contact; //联系方式

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('建议与反馈'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  '直接反馈',
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                color: Theme
                    .of(context)
                    .highlightColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _controllerContent,
                  decoration: InputDecoration(
                      hintText: '请输入您的详细问题或建议，我将尽快解决改进。\n<(▰˘◡˘▰)>'),
                  maxLines: 7,
                  maxLength: 200,
                  onSubmitted: (str) {
                    _content = str;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _controllerConTact,
                  decoration: InputDecoration(
                    hintText: '可以选择留下联系方式，方便联系',
                  ),
                  maxLength: 20,
                ),
              ),
              FlatButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text('点击提交'),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  '联系我',
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                color: Theme
                    .of(context)
                    .highlightColor,
              ),
              InkWell(
                onTap: () {
                  launch('mailto:sunxiaolei92@163.com');
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          ImagePath.icMail,
                          color: Colors.orange,
                          width: 25,
                        ),
                        margin: EdgeInsets.only(left: 15),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '发送邮件',
                            style: TextStyle(fontSize: 16),
                          ),
                          margin: EdgeInsets.only(left: 5),
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              InkWell(
                onTap: () {
                  CommonUtils.copy('sunxiaolei92', '微信号已复制到剪切板');
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          ImagePath.icWechat,
                          color: Colors.green,
                          width: 25,
                        ),
                        margin: EdgeInsets.only(left: 15),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '加我微信：sunxiaolei92',
                            style: TextStyle(fontSize: 16),
                          ),
                          margin: EdgeInsets.only(left: 5),
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //提交
  _submit() async {
    String content = _controllerContent.text;
    String contact =
    _controllerConTact.text == null ? '' : _controllerConTact.text;
    if (content == null || content.isEmpty) {
      ToastUtils.showShort('请输入内容');
      return;
    }
    CommonUtils.showLoading(context);

    ///api支持：https://leancloud.cn
    String reqAPi = 'https://fuydw05s.api.lncld.net/1.1/feedback';
    Map<String, dynamic> headers = Map.from({
      'X-LC-Id': Ids.X_LC_Id,
      'X-LC-Key': Ids.X_LC_Key,
      'Content-Type': 'application/json',
    });
    Dio _dio = Dio();
    LogInterceptor interceptor = LogInterceptor();
    _dio.interceptor.request.onSend = interceptor.onSend;
    _dio.interceptor.response.onSuccess = interceptor.onSuccess;
    _dio.interceptor.response.onError = interceptor.onError;
    Response response =
    await _dio.post(reqAPi, options: Options(headers: headers), data: {
      'status': 'open',
      'content': content,
      'contact': contact,
    }).then((response) {
      Navigator.pop(context);
      ToastUtils.showShort('提交成功，感谢反馈');
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
      ToastUtils.showShort(error.message);
    });
  }
}
