import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http.get('http://207.148.71.41/appapi');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}
class Post {
  final String id;
  final bool login;
  Post({this.id,this.login});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id:json['Id'],
      login:json['IsLogin']
    );
  }
}
void main() => runApp(MyApp(post: fetchPost()));
class MyApp extends StatelessWidget {
  final Future<Post> post;
  MyApp({Key key, this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Read API'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.id.toString()+" "+snapshot.data.login.toString());
              }
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
                return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}