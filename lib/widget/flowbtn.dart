import 'package:flutter/material.dart';
import 'package:wan/model/vo/flowitem_vo.dart';

class FlowItemBtns extends StatefulWidget {
  final List<FlowItemVO> items;
  final PressCallBack onPress;

  FlowItemBtns({Key key, this.items, this.onPress}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FlowItemState();
  }
}

class FlowItemState extends State<FlowItemBtns> {
  final List<Widget> children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    List<Widget> _items = widget.items
        .map((item) => RaisedButton(
              child: Text(item.name),
              onPressed: () {
                return widget.onPress(item);
              },
              color: _randomColor(item.name),
              shape: StadiumBorder(),
            ))
        .toList();

    if (_items.isNotEmpty) {
      children.add(Wrap(
        children: _items.map((Widget widget) {
          return Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
            child: widget,
          );
        }).toList(),
      ));
    } else {
//      children.add(Center(
//        child: Text('暂无数据'),
//      ));
    }

    return Card(
      child: ListView(
        children: children,
      ),
    );
  }

  Color _randomColor(name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }
}

typedef PressCallBack = void Function(FlowItemVO item);
