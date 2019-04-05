import 'package:basic_app/datamodel.dart';
import 'package:basic_app/home.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp(post:fetchData()));
}

class MyApp extends StatelessWidget{
  final Future<Datamodel> post;
  MyApp({Key key, this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}