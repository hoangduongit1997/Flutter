 import 'dart:async';

import 'package:pika_maintenance/validations/validations.dart';
 class LoginStream {
   StreamController _usernamecontroller = new StreamController.broadcast();
   StreamController _passwordcontroller = new StreamController.broadcast();

   Stream get usernameStream => _usernamecontroller.stream;
   Stream get passStream => _passwordcontroller.stream;

   bool isValidInfo(String user, String pass) {
     bool status = true;

     if (!Validations.isValidUser(user)) {
       status = false;
       _usernamecontroller.sink.addError("Tài khoản không hợp lệ");
     }
     if (Validations.isValidUser(user)) {
   
       _usernamecontroller.sink.add("OK");
     }

     if (!Validations.IsValidPass(pass)) {
       status = false;
       _passwordcontroller.sink.addError("Mật khẩu không hợp lệ");
     }
     if (Validations.IsValidPass(pass)) {
   
       _passwordcontroller.sink.add("OK");
     }

     return status;
   }

   void dispose() {
     _passwordcontroller.close();
     _usernamecontroller.close();
   }
 }
