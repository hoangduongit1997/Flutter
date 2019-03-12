import 'package:flutter/material.dart';
import 'package:login_app/home.dart';

void main()=>runApp(MyApp());
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(home: LoginPage(),
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

              child: TextField(
                controller: _user,
                style: TextStyle(fontSize: 18,color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Username",
                    errorText: _uservalid? _usererror:null,
                    labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18)
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,30),
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
                        labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18)

                    ),
                  ),
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
    setState(() {
      if(_user.text.length<6||!_user.text.contains("@"))
        {
          _uservalid=true;
        }
        else
          {
            _uservalid=false;
          }
          if(_pass.text.length<6)
            {
              _passvalid=true;
            }
            else{
              _passvalid=false;
          }
          if(!_uservalid&&!_passvalid)
            {
              Navigator.push(context,MaterialPageRoute(builder:gotohome));

            }

    });
    
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


