import 'package:flutter/material.dart';
import'package:flutter_verification_code_input/flutter_verification_code_input.dart';
class VerifyPhone extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VerifyPhonePage();
  }

}
class VerifyPhonePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VerifyPhonePageSate();
  }
}

class VerifyPhonePageSate extends State<VerifyPhonePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.fromLTRB(30,0,30,0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              child: Text("Verify your Mobile",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 24,
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
              padding: const EdgeInsets.fromLTRB(0,20,0,20),
              child: new VerificationCodeInput(
                keyboardType: TextInputType.number,
                length: 4,
                onCompleted: (String value) {
                  print(value);
                },
              )
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,20,0,20),
              child: SizedBox(
                width: double.infinity,
                height: 51,
                child: RaisedButton(
                  color: Colors.red[300],
                  child:
                  Text("Submit", style: TextStyle(color: Colors.white,fontSize: 16),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  onPressed:onSigninClick,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void onSigninClick() {
  }
}