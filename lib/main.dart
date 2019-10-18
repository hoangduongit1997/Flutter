import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/draw_left_menu_page.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'module/change_language_module/change_language_module.dart';
import 'screens/splash_screen/splash_screen.dart';

Future main() async {
  try {
    // Check run debug or release
    if (Validations.isInDebugMode) {
      Configs.isDebugMode = true;
      print("App is running debug mode");
    } else {
      Configs.isDebugMode = true;
      print("App is running release mode");
    }
    int value = await Validations.check_language();
    if (value == 1) {
      await allTranslations.init('vi');
      Configs.isTapEn = false;
      Configs.isTapVn = true;
    } else if (value == 0) {
      await allTranslations.init('en');
      Configs.isTapEn = true;
      Configs.isTapVn = false;
    } else {
      await allTranslations.init('vi');
      Configs.isTapEn = false;
      Configs.isTapVn = true;
    }
    runApp(MainApp());
  } catch (e) {
    print(e.toString());
    FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in main function');
    FlutterCrashlytics().logException(e, e.stackTrace);
  }
}

class MainApp extends StatelessWidget {
  Widget errorWidget() {
    return Container(
      child: Center(
        child: Text(allTranslations.text("error"), textAlign: TextAlign.center, style: StylesText.style13Black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ErrorWidget.builder = (errorDetails) {
      print(errorDetails.toString());
      FlutterCrashlytics().log(errorDetails.toString(), priority: 200, tag: 'Error in errorWidget in main');
      return errorWidget();
    };
    return MaterialApp(
      title: "Pika Maintenance",
      theme: ThemeData(primaryColor: Colors.orange, backgroundColor: HexColor("#FAFAFA")),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: allTranslations.supportedLocales(),
      home: SplashScreen(),
    );
  }
}
