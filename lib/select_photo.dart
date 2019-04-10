import 'package:cacook_coffee/asset_view.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(new SelectPhoto());

class SelectPhoto extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SelectPhoto> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text("On Working"),
      ),
    );
  }

}