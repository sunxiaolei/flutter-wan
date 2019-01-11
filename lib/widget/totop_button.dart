import 'package:flutter/material.dart';

class ToTopFloatBtn extends StatefulWidget {
  final VoidCallback onPressed;
  final bool defaultVisible;

  ToTopFloatBtn(
      {Key key, @required this.onPressed, this.defaultVisible = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new ToTopFloatBtnState();
}

class ToTopFloatBtnState extends State<ToTopFloatBtn> {
  bool _visible = false;

  refreshVisible(bool visible) {
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _visible = widget.defaultVisible;
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: widget.onPressed),
              padding: EdgeInsets.all(10.0),
            ),
          )
        : SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
}
