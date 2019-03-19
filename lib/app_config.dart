import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
class AppConfig extends InheritedWidget{
  final String appName;
  final String flavorApp;
  final String apiBaseurl;
  AppConfig({
    @required this.appName,
    @required this.flavorApp,
    @required this.apiBaseurl,
    @required Widget child,
}):super (child:child);
 static AppConfig of(BuildContext context)
 {
   return context.inheritFromWidgetOfExactType(AppConfig);
 }
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
}