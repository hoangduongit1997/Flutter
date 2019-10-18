import 'package:flutter/material.dart';
import 'package:pika_maintenance/styles/styles.dart';

class StatusText extends StatelessWidget {
   StatusText({
    Key key,
    this.statusReport,
    this.colorReport,
  }) : super(key: key);

  Color colorReport;
  String statusReport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 2, right: 2),
          child: ClipOval(
            child: Container(
              color: colorReport,
              height: 8,
              width: 8,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        Text(
          statusReport,
          style: StylesText.style12Black
        ),
      ],
    );
  }
}
