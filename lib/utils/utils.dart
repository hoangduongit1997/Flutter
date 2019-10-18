import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pika_maintenance/configs/configs.dart';

class Dimension {
  static double height = 0.0;
  static double witdh = 0.0;

  static double getWidth(double size) {
    return witdh * size;
  }

  static double getHeight(double size) {
    return height * size;
  }
}

class ChangeTime {
  static String ChangeTimeStampToTime(
      double timestamp, bool isHasHour, bool isJustyear, bool isJustHour) {
    if(timestamp==null||timestamp==0.0)
      {
        return "";
      }
    else{
      if (isHasHour == true && isJustyear == false && isJustHour == false) {
        var format = new DateFormat("dd/MM/yyyy HH:mm");
        DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch((timestamp * 1000.0).toInt());
        return format.format(dateTime).toString();
      } else if (isHasHour == false &&
                 isJustyear == false &&
                 isJustHour == false) {
        var format = new DateFormat("dd/MM/yyyy");
        DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch((timestamp * 1000.0).toInt());
        return format.format(dateTime).toString();
      } else if (isHasHour == false &&
                 isJustyear == true &&
                 isJustHour == false) {
        var format = new DateFormat("yyyy");
        DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch((timestamp * 1000.0).toInt());
        return format.format(dateTime).toString();
      } else if (isHasHour == false &&
                 isJustyear == false &&
                 isJustHour == true) {
        var format = new DateFormat("HH:mm");
        DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch((timestamp * 1000.0).toInt());
        return format.format(dateTime).toString();
      }
    }

  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class Unity {
  static Replace_String(String url) {
    String replaced_token =
        url.replaceFirst(RegExp('tkUnkhown'), Configs.tokenUser);
    String replace_final =
        replaced_token.replaceFirst(RegExp('idUnkhown'), Configs.idUser);
    return replace_final;
  }
  static openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
    context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    scaffoldState.openDrawer();
  }
}
