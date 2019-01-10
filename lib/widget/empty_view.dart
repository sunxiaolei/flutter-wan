import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final OnClick onClick;
  final String iconPath;
  final String hint;

  const EmptyView({Key key, this.onClick, this.iconPath, this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () {
        onClick();
      },
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(iconPath),
            SizedBox(
              height: 10,
            ),
            hint == null ? SizedBox() : Text(hint),
          ],
        ),
      ),
    ));
  }
}

typedef OnClick = void Function();
