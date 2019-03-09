import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter App'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}