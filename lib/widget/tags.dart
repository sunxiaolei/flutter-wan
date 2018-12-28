import 'package:flutter/material.dart';
import 'package:wan/model/dto/tags_dto.dart';

class TagsWidget extends StatefulWidget {
  final List<Tags> tags;

  TagsWidget(this.tags);

  @override
  State<StatefulWidget> createState() {
    return _TagsWidgetState();
  }
}

class _TagsWidgetState extends State<TagsWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.tags != null && widget.tags.length > 0) {
      return Row(
        children: widget.tags.map((tags) {
          return Container(
            child: Text(
              tags.name,
              style: TextStyle(
                  fontSize: 10, color: Theme.of(context).primaryColorLight),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColorLight),
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            margin: EdgeInsets.only(right: 7),
          );
        }).toList(),
      );
    } else {
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
  }
}
