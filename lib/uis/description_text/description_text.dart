import 'package:flutter/material.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';

class DescriptionText extends StatefulWidget {
  String text;

  DescriptionText(@required this.text);

  @override
  _DescriptionTextState createState() => _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {
  String firstDesc;
  String secondDesc;
  bool flag = true;

  static final NUMBER_CHARACTER = 100;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > NUMBER_CHARACTER) {
      firstDesc = widget.text.substring(0, NUMBER_CHARACTER);
      secondDesc = widget.text.substring(NUMBER_CHARACTER, widget.text.length);
    } else {
      firstDesc = widget.text;
      secondDesc = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String description;

    if (flag) {
      description = firstDesc + '...';
    } else {
      description = firstDesc + secondDesc;
    }

    Widget content;
    if (secondDesc.isEmpty) {
      content = _text(firstDesc, Colors.black);
    } else {
      content = _collapseDescription(description);
    }
    return Container(child: content);
  }

  Widget _collapseDescription(String description) {
    return Column(
      children: <Widget>[
        _text(description, Colors.black),
        Material(
          color: Theme.of(context).backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  flag ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 25,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    flag = !flag;
                  });
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _text(String text, color) {
    return Container(
      width: Dimension.getWidth(0.95),
      child: Text(
        text,
        softWrap: true,
        textAlign: TextAlign.start,
        style: StylesText.style13Black,
      ),
    );
  }
}
