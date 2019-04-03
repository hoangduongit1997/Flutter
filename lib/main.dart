import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class Post {
  final String name;
  final String job;
  final String platform;
  final int age;
  final String link;
  final String linkflutter;
  final String linkvideo;
  final String linkintro;
  Post({this.name, this.job, this.platform,this.age, this.link,
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
Future<Post> fetchPost() async {
  final response = await http.get('https://fighttechvn.github.io/api/data.json');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}
bool isWifi=true;
Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    return isWifi=true;
  }
  return isWifi=false;
}
void main()=>runApp(MyApp(post:fetchPost()));
class MyApp extends StatelessWidget{
  final Future<Post> post;
  final Future<bool> check;
 MyApp({Key key, this.post,this.check}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Basic App',
      home: Scaffold(
        backgroundColor: Colors.yellow,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:const EdgeInsets.fromLTRB(80, 0, 0,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("DETECT WIFI: ",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  ),
                  Text(
                    isWifi?"ON":"OFF",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20
                  ),
                  )
                   ],
                ),
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
                  padding: const EdgeInsets.fromLTRB(80,10,0,0),
                  child: Row(
                    children: <Widget>[
                      new Text("Age:",style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 20
                      ),
                      ),
                      FutureBuilder<Post>(
                      future: post,
                        builder: (context,snapshot){
                         if(snapshot.hasData){
                            return Text(snapshot.data.age.toString(), style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),);
                         }
                         return CircularProgressIndicator();
                       },
                    ),
                    ],
                  )
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(80,10,0,0),
                  child: Row(
                    children: <Widget>[
                      new Text("Name:",style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 20
                      ),
                      ),
                      FutureBuilder<Post>(
                        future: post,
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return new Text(snapshot.data.name.toString(),style: TextStyle(
                                fontWeight:FontWeight.normal,
                                color: Colors.black,
                                fontSize: 20
                            ),);
                          }

                          return CircularProgressIndicator();
                        },
                      ),
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
                    FutureBuilder<Post>(
                      future: post,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return new Text(snapshot.data.platform.toString(),style: TextStyle(
                              fontWeight:FontWeight.normal,
                              color: Colors.black,
                              fontSize: 20
                          ),);
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(120, 10, 0,0),
                child: Row(
                  children: <Widget>[
                    FutureBuilder<Post>(
                      future: post,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return new  Container(
                              height: 140,
                              width: 140,
                              decoration:BoxDecoration( border: Border.all(color: Colors.red)),
                              child: new ClipRRect(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  child: Image.network(snapshot.data.link.toString(),
                                    fit: BoxFit.contain,
                                  ))
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(130,10,0,0),
              child: Container(
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.red
                ),
                child: RaisedButton(child:
                Text("Play video", style: TextStyle(color: Colors.white,fontSize: 16),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  onPressed: playvideo(),
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
                    Text(Platform.operatingSystem.toString().toUpperCase(),style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 20
                    ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ) ,
    );
  }

}

playvideo() {

}





