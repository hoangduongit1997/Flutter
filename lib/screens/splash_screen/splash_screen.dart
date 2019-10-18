import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/model/line_model.dart';

import 'package:pika_maintenance/data/repository/login_repository.dart';
import 'package:pika_maintenance/data/sqllite/database.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/home_screen.dart';
import 'package:pika_maintenance/screens/login_screen/login_screen.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    try {
      await Future.wait([
        initDataSQL().then((va) {
          initCrack().then((a) {
            onDoneLoading().catchError((e) {
              print(e);
            });
          }).catchError((e) {
            print(e);
          });
        }).catchError((e) {
          print(e);
        }),
      ]);
    } catch (e) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData spashscreen');
      FlutterCrashlytics().logException(e, e.stackTrace);
      return Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future initCrack() async {
    //flutter_crashlytics
    bool isInDebugMode = false;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (isInDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      } else {
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    };
    bool optIn = true;
    if (optIn) {
      await FlutterCrashlytics().initialize();
      FlutterCrashlytics()
          .setUserInfo('Maintaince', 'debug@pikatech.vn', 'tester');
    } else {}

    runZoned<Future<Null>>(() async {}, onError: (error, stackTrace) async {
      FlutterCrashlytics().log(error.toString(), priority: 200, tag: 'Error');
      FlutterCrashlytics().logException(error, stackTrace);
    });
    //end
  }

  Future initDataSQL() async {
    //data offline
    final database = await $FloorFlutterDatabase
        .databaseBuilder('tasks_database.db')
        .build();
    Configs.userDao = database.taskDao;
    Configs.linesDao = database.linesDao;
    Configs.cellDao = database.cellDao;
    Configs.machineDao = database.machineDao;
    Configs.machineCategolaryDao = database.machineCategolaryDao;
    Configs.messageFirebaseDao = database.messageFirebaseDao;
  }

  Future initDataOffline() async {
    try {
      //get listline
      List<LineModel> temp;
      temp = await Configs.linesDao.findAllLiness();
      if (temp != null || temp.length > 0) {
        if (this.mounted) {
          setState(() {
            Configs.lstLine = temp;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            Configs.lstLine = [];
          });
        }
        return;
      }
      await Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      Configs.lstLine = [];
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initdata offline '
          'splash screen');
      FlutterCrashlytics().logException(e, e.stackTrace);
      return;
    }
  }

  Future onDoneLoading() async {
    try {
      if (await Validations.isConnectedNetwork() == true) {
        Future<SharedPreferences> _sp = SharedPreferences.getInstance();
        SharedPreferences prefs =
        await _sp.timeout(const Duration(seconds: 20));
        String username = prefs.getString("username");
        String pass = prefs.getString("password");
        if ((await Validations.IsLogin()) == true) {
          if (await LoginRepository(username, pass) == 1) {
            Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => HomeScreen()));
          } else {
            prefs.clear();
            Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => LoginScreen()));
          }
        } else {
          prefs.clear();
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => LoginScreen()));
        }
      } else {
        if ((await Validations.IsLogin()) == true) {
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => HomeScreen()));
        } else {
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => LoginScreen()));
        }
      }
    } catch (e) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in doneLoading in '
          'splashscreen');
      FlutterCrashlytics().logException(e, e.stackTrace);
      return Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimension.height = MediaQuery.of(context).size.height;
    Dimension.witdh = MediaQuery.of(context).size.width;
    SizeText.queryData = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: Dimension.getHeight(1.0),
        width: Dimension.getWidth(1.0),
        color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "assets/images/login.png",
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      width: Dimension.getWidth(0.65),
                      height: Dimension.getWidth(0.65),
                    ),
                  ),
                )),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: Dimension.getWidth(0.15),
                    width: Dimension.getWidth(0.15),
                    child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.orange,
                          size: 30,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(allTranslations.text("loading"),
                        style: StylesText.style13Black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
