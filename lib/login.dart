import 'package:cacook_coffee/veryfy_phone.dart';
import 'package:flutter/material.dart';
import 'package:color/color.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: MyAppPage(),
    );
  }

}
class MyAppPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }

}
class MyAppState extends State<MyAppPage>{
  bool _showpass =false;
  TextEditingController _user=new TextEditingController();
  TextEditingController _pass=new TextEditingController();
  String _usererror="Tài khoản không hợp lệ";
  String _passerror="Mật khẩu không hợp lệ";
  bool _uservalid =false;
  bool _passvalid=false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.fromLTRB(30,0,30,0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
          child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,50,0,0),
                  child: Text("Welcome to\n   Cacook!",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                    fontSize: 20,
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,20,0,0),
                  child: Text("Sign in to continute",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                    fontSize: 16,
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child: TextField(
                    controller: _user,
                    style: TextStyle(fontSize: 18,color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Email",
                        errorText: _uservalid? _usererror:null,
                        labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 12)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,20),
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      TextField(
                        style: TextStyle(fontSize: 18,color: Colors.black),
                        controller: _pass,
                        obscureText: !_showpass,
                        decoration: InputDecoration(
                            labelText: "Password",
                            errorText: _passvalid?_passerror:null,
                            labelStyle: TextStyle(color:Colors.blueGrey , fontSize: 12)
                        ),
                      ),
                      GestureDetector(
                          onTap: ShowPass,
                          child: Text(_showpass ?"HIDE":"SHOW",style: TextStyle(color: Colors.blueGrey,fontSize: 12,fontWeight: FontWeight.bold),))
                    ],

                  ),
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,20),
                      child: Text("Forget password?",
                          style: TextStyle(fontSize: 16,color:Colors.red[300],fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: RaisedButton(
                      color: Colors.red[300],
                      child:
                      Text("Login", style: TextStyle(color: Colors.white,fontSize: 16),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      onPressed: onSigninClick,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("New to Cocook?  ",style: TextStyle(fontSize: 16,color: Colors.brown),
                        ),
                        Text("Sign up",style: TextStyle(fontSize: 16,color: Colors.red[300],fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                )
              ],
            ) ,
          )



      ),
    );
  }


  void onSigninClick() {
    setState(() {

        Navigator.push(context,MaterialPageRoute(builder:gotohome));

    });

  }

  void ShowPass() {
    setState(() {
      _showpass=!_showpass;

    });
  }
  Widget gotohome(BuildContext context)
  {
    return VerifyPhone();
  }
}