import 'dart:async';
import 'package:login_app/src/validator/validate.dart';



class LoginBloc{
  StreamController _usercontroller=new StreamController();
  StreamController _passcontroller=new StreamController();
  Stream get userStream =>_usercontroller.stream;
  Stream get passStrem=>_passcontroller.stream;

  bool isValidInfo(String user, String pass)
  {
    if(!Validator.isValidUser(user))
      {
        _usercontroller.sink.addError("Tài khoản không hợp lệ");
        return false;
      }
      if(!Validator.isValidPass(pass))
        {
          _passcontroller.sink.addError("Mật khẩu không hợp lệ");
          return false;
        }
        else
          {
            _usercontroller.sink.add("OK");
            _passcontroller.sink.add("OK");
          }

        return true;
  }

  void dispose(){
    _passcontroller.close();
    _usercontroller.close();
  }
}