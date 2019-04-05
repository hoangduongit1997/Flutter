import 'dart:convert';
import 'dart:io' show Platform;
import 'package:basic_app/datamodel.dart';
import 'package:basic_app/video.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:path/path.dart';

String link="";
class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}
class HomePageState extends State<Homepage>{

  void initState() {
    super.initState();
    _initDetectWifi().then((onValue) {
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  bool wifiStatus = false;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  _getStatusWifi() {
    return wifiStatus == true ? "ON" : "OFF";
  }

  void setStateWifi(state) {
    setState(() {
      wifiStatus = true;
    });
  }

  Future<void> _initDetectWifi() async {
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          print("WIFI status: $wifiStatus");
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            setStateWifi(true);
          }
        });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setStateWifi(true);
      print("WIFI DETECT: $wifiStatus");
    }
  }
  void _onTapPlayVideo() {
    Navigator.of(this.context).push(new MaterialPageRoute(
        builder: (context) => new PlayVideo(linkVideo:link)));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                    _getStatusWifi(),style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
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
                    FutureBuilder<Datamodel>(
                      future: fetchData(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          link=snapshot.data.linkintro.toString();
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
                    FutureBuilder<Datamodel>(
                      future: fetchData(),
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
                  FutureBuilder<Datamodel>(
                    future: fetchData(),
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
                  FutureBuilder<Datamodel>(
                    future: fetchData(),
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
                child: RaisedButton(
                  color: Colors.redAccent,
                  child:
                  Text("Play video", style: TextStyle(color: Colors.white,fontSize: 16),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  onPressed:(){
                    _onTapPlayVideo();
                  },
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
    );
  }

}












