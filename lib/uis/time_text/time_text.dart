import 'package:flutter/material.dart';
import 'package:pika_maintenance/styles/styles.dart';

class TimeText extends StatelessWidget {
  const TimeText({
    Key key,
    this.timeHasPassed,
  }) : super(key: key);

  final String timeHasPassed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.access_time,
          size: 20,
           color: Color.fromARGB(255, 11, 68, 125)
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        Text(
          timeHasPassed,
           style: StylesText.style14Blue,
        ),
      ],
    );
  }
}
