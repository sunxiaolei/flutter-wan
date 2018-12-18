import 'package:flutter/material.dart';

class ToTopFloatActionButton extends StatefulWidget {
  final VoidCallback onPressed;

  ToTopFloatActionButton({key, this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ToTopFloatActionState();
  }
}

class ToTopFloatActionState extends State<ToTopFloatActionButton> {
  bool _visible = false;

  void setVisible(bool visible) {
    setState(() {
      _visible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? Padding(
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              child: Icon(Icons.vertical_align_top),
            ),
            padding: EdgeInsets.all(10),
          )
        : SizedBox(
            width: 0,
            height: 0,
          );
  }
}
