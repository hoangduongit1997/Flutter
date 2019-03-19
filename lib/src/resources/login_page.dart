
import 'package:flutter/material.dart';
import 'package:login_app/src/bloc/login_bloc.dart';
import 'package:login_app/src/resources/home_page.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }

}
class LoginPageState extends State<LoginPage>{
  LoginBloc loginBloc=new LoginBloc();
  bool _showpass =false;
  TextEditingController _user=new TextEditingController();
  TextEditingController _pass=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(30,0,30,0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey,
                  ),
                  child: FlutterLogo()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,40),
              child: Text("Hello\nWelcome Back",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 30,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),

              child:StreamBuilder(
                stream:LoginBloc().userStream,
                builder: (context,snapshot)=> TextField(
                controller: _user,
                style: TextStyle(fontSize: 18,color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Username",
                    errorText: snapshot.hasError?snapshot.error:null,
                    labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18)
                ),
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,30),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  StreamBuilder(
                    stream: loginBloc.passStrem,
                    builder: (context,snapshot)=> TextField(

                    style: TextStyle(fontSize: 18,color: Colors.black),
                    controller: _pass,
                    obscureText: !_showpass,
                    decoration: InputDecoration(
                        labelText: "Password",
                        errorText: snapshot.hasError?snapshot.error:null,
                        labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18)

                    ),
                  ),),

                  GestureDetector(
                      onTap: ShowPass,
                      child: Text(_showpass ?"HIDE":"SHOW",style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.bold),))
                ],

              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  onPressed: onSigninClick,
                  child: Text("SIGN IN", style: TextStyle(color: Colors.white,fontSize: 16),),
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Container(
                height: 130,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("NEW USER? SIGN UP",style: TextStyle(fontSize: 15,color: Colors.black),
                    ),
                    Text("FORGET PASSWORD?",style: TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void onSigninClick() {

     if(loginBloc.isValidInfo(_user.text.trim(),_pass.text.trim()))
       {
         Navigator.push(context,MaterialPageRoute(builder:gotohome));
       }
  }

  void ShowPass() {
    setState(() {
      _showpass=!_showpass;
    });
  }
  Widget gotohome(BuildContext context)
  {
    return HomePage();
  }
}

