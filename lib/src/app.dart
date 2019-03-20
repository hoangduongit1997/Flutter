
import 'package:flutter/material.dart';
import 'package:login_app/main.dart';
import 'package:login_app/src/resources/login_page.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }

}