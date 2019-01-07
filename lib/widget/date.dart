import 'package:flutter/material.dart';

class DateItem extends StatelessWidget {
  DateItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = DateTime(dateTime.year, dateTime.month, dateTime.day),
        super(key: key);

  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor))),
        child: InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: date,
                firstDate: date.subtract(const Duration(days: 30)),
                lastDate: date.add(const Duration(days: 30)),
                locale: Locale('en'), //zh bug
              ).then<void>((DateTime value) {
                if (value != null)
                  onChanged(DateTime(
                    value.year,
                    value.month,
                    value.day,
                  ));
              });
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(date.year.toString() +
                      '-' +
                      date.month.toString() +
                      '-' +
                      date.day.toString()),
                  const Icon(Icons.arrow_drop_down, color: Colors.black54),
                ])));
  }
}
