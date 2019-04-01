import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
final response = await http.get('https://fighttechvn.github.io/api/data.json');
if (response.statusCode == 200) {
return Post.fromJson(json.decode(response.body));
} else {
throw Exception('Failed');
}
}
class Post {
  final String name;
  final String job;
  final String platform;
  final int age;
  final String link;
  final String linkflutter;
  final String linkvideo;
  final String linkintro;
  Post({this.name, this.job, this.platform, this.age, this.link,
      this.linkflutter, this.linkvideo, this.linkintro});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name:json['name'],
      job:json['job'],
      platform:json['Platform'],
      age:json['Age'],
      link:json['link'],
      linkflutter:json['linkflutter'],
      linkvideo:json['linkvideo'],
      linkintro:json['linkintro'],
    );
  }
}
void main()=>runApp(MyApp());
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

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }

}
class LoginPageState extends State<LoginPage>{
 TextEditingController _user=new TextEditingController();
 TextEditingController _pass=new TextEditingController();
  @override
  Widget build(BuildContext context) {
  Future<Post> post;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(

        padding: const EdgeInsets.fromLTRB(30,0,30,0),
        color: Colors.yellow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
             padding: const EdgeInsets.fromLTRB(80, 0, 0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("DETECT WIFI: ",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  ),
                  Text('ON',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20
                  ),)
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(110, 10, 0, 0),
              child: Text("DATA API",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20
              ),)
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(120,10,0,0),
              child: Row(
                children: <Widget>[
                  Text("Age:",style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 20
                  ),
                  ),
                  Text("20",style: TextStyle(
                    fontWeight:FontWeight.normal,
                    color: Colors.black,
                    fontSize: 20
                  ),)
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80,10,0,0),
              child: Row(
               children: <Widget>[
                 Text("Platform:",style: TextStyle(
                     fontWeight: FontWeight.normal,
                     color: Colors.black,
                     fontSize: 20
                 ),
                 ),
                 Text("Android",style: TextStyle(
                     fontWeight: FontWeight.normal,
                     color: Colors.black,
                     fontSize: 20
                 ),
                 ),
               ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(90, 10, 0,0),
              child: Container(
                height: 140,
                width: 140,
                decoration:BoxDecoration( border: Border.all(color: Colors.red)),
                child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(30.0),
                    child: Image.network('https://fighttechvn.github.io/assets/images/logo-gameloft.png',
                        fit: BoxFit.contain,
                        ))
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100,10,0,0),
              child: SizedBox(
              width: 120,
              height: 60,
              child: RaisedButton(child:
              Text("Play video", style: TextStyle(color: Colors.white,fontSize: 16),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                onPressed: null,
                color: Colors.red,
              ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 10, 0, 0),
              child: Row(
                children: <Widget>[
                Text(
                  "Flatform Devices: ", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
                ),
                  Text("IOS",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );

  }






 
}


