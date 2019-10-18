
import 'package:flutter/material.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

 class MessageDialog {
   static void showMsgDialog(BuildContext context, String title, String msg,AlertType alertTtyle) {
     Alert(
       context: context,
       type: alertTtyle,
       title: title,
       desc: msg,
       buttons: [
         DialogButton(
           child: Text(
             "OK",
             style: TextStyle(color: Colors.white, fontSize: 20),
             ),
           onPressed: () => Navigator.pop(context),
           color: Colors.blue,
           ),
       ],
       ).show();
   }
 }
