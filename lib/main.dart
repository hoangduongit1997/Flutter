import 'package:cacook_coffee/login.dart';
import 'package:cacook_coffee/login_2.dart';
import 'package:cacook_coffee/select_photo.dart';
import 'package:cacook_coffee/tutorial.dart';
import 'package:cacook_coffee/veryfy_phone.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(MainApp());
}

class MainApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainAppPage(),
    );
  }

}

class MainAppPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainAppPageState();
  }
}

class MainAppPageState extends State<MainAppPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30,0,30,0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0,50,0,0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton(
                    color: Colors.red[300],
                    child:
                    Text("Login 1", style: TextStyle(color: Colors.white,fontSize: 16),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: onLogin_1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton(
                    color: Colors.red[300],
                    child:
                    Text("Login 2", style: TextStyle(color: Colors.white,fontSize: 16),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: onLogin_2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton(
                    color: Colors.red[300],
                    child:
                    Text("Tutorial", style: TextStyle(color: Colors.white,fontSize: 16),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: onLogin_3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton(
                    color: Colors.red[300],
                    child:
                    Text("Verify Phone", style: TextStyle(color: Colors.white,fontSize: 16),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: onLogin_4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton(
                    color: Colors.red[300],
                    child:
                    Text("Select your photo", style: TextStyle(color: Colors.white,fontSize: 16),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: onLogin_5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void onLogin_1() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: GotoLogin));
    });
  }

  Widget GotoLogin(BuildContext context) {
    return Login();
  }

  void onLogin_2() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: GotoLogin_2));
    });
  }

  Widget GotoLogin_2(BuildContext context) {
    return LoginWithFace();
  }

  void onLogin_3() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: GotoLogin_3));
    });
  }

  Widget GotoLogin_3(BuildContext context) {
    return Tutorial();
  }

  void onLogin_4() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: GotoLogin_4));
    });
  }

  Widget GotoLogin_4(BuildContext context) {
    return VerifyPhone();
  }

  void onLogin_5() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: GotoLogin_5));
    });
  }

  Widget GotoLogin_5(BuildContext context) {
    return SelectPhoto();
  }
}