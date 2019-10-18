import 'package:after_layout/after_layout.dart';
import 'package:badges/badges.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/model/message_model.dart';
import 'package:pika_maintenance/data/repository/get_cells_repository.dart';
import 'package:pika_maintenance/data/repository/get_lines_repository.dart';
import 'package:pika_maintenance/data/repository/get_machines_categolary_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/draw_left_menu_page.dart';
import 'package:pika_maintenance/screens/home_screen/list_request_page/list_requests_page.dart';
import 'package:pika_maintenance/screens/home_screen/news_feed_page/news_feed_page.dart';
import 'package:pika_maintenance/screens/home_screen/notification_page/notifications_page.dart';
import 'package:pika_maintenance/screens/home_screen/send_request_page/scan.dart';
import 'package:pika_maintenance/streams/bottom_navigation_stream.dart';
import 'package:pika_maintenance/streams/number_notification_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:toast/toast.dart';
import 'send_request_page/send_request_page.dart';

NumberStream numberStream;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen>, AutomaticKeepAliveClientMixin<HomeScreen> {
  BottomNavBarStream _bottomNavBarStream;

  DateTime currentBackPressTime;
  @override
  Future afterFirstLayout(BuildContext context) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    firebaseMessaging.autoInitEnabled().then((bool enabled) => print(enabled));
    firebaseMessaging
        .setAutoInitEnabled(true)
        .then((_) => firebaseMessaging.autoInitEnabled().then((bool enabled) => print(enabled)));
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['notification'];
        await _showNotification(notification['title'].toString(), notification['body'].toString());
        await Configs.messageFirebaseDao.insertMessageFirebaseModel(
            new MessageFirebaseModel(null, notification['title'].toString(), notification['body'].toString(), 0));
        Configs.numberNotification++;
        numberStream.pushNumber(Configs.numberNotification);
      },
      onLaunch: (Map<String, dynamic> message) async {
        final notification = message['data'];
        await _showNotification(notification['title'].toString(), notification['body'].toString());
        await Configs.messageFirebaseDao.insertMessageFirebaseModel(
            new MessageFirebaseModel(null, notification['title'].toString(), notification['body'].toString(), 0));
        Configs.numberNotification++;
        numberStream.pushNumber(Configs.numberNotification);
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['notification'];
        await _showNotification(notification['title'].toString(), notification['body'].toString());
        await Configs.messageFirebaseDao.insertMessageFirebaseModel(
            new MessageFirebaseModel(null, notification['title'].toString(), notification['body'].toString(), 0));
        Configs.numberNotification++;
        numberStream.pushNumber(Configs.numberNotification);
      },
    );
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    // _firebaseMessaging.onTokenRefresh.listen((data) {
    //   print('Refresh Token: $data');
    // }, onDone: () => print('Refresh Token Done'));
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
    await initDataNetword();
  }

  Future initDataNetword() async {
    List<LineModel> temp_line;
    List<CellModel> tem_cell;
    List<MachineCategolaryModel> temp_machinecato;
    try {
      await Future.wait([
        //get line
        GetLinesRepository().then((value) async {
          if (value != null) {
            if (this.mounted) {
              setState(() {
                Configs.lstLine = value;
              });
            }
          } else {
            temp_line = await Configs.linesDao.findAllLiness();
            if (temp_line == null || temp_line.length == 0) {
              setState(() {
                Configs.lstLine = [];
              });
            } else {
              if (this.mounted) {
                setState(() {
                  Configs.lstLine = temp_line;
                });
              }
            }
          }
        }),
        //getcell
        // GetCellsRepository(0).then((va) async {
        //   if (va != null) {
        //     await Configs.cellDao.deleteAllRow();
        //     if (this.mounted) {
        //       setState(() {
        //         Configs.lst_cell = va;
        //       });
        //     }
        //     await Configs.cellDao.insertCellModels(va);
        //   } else {
        //     tem_cell = await Configs.cellDao.findAllLiness();
        //     if (this.mounted) {
        //       setState(() {
        //         Configs.lst_cell = tem_cell;
        //       });
        //     }
        //   }
        // }),
        //get machine_catalo, lưu vào sqllite
        GetMachinesCategolaryRepository().then((valua) async {
          if (valua != null) {
            if (this.mounted) {
              setState(() {
                Configs.lstMachineCata = valua;
                Configs.lstMachineCata.insert(0, new MachineCategolaryModel(0, "All", "All", "", "", 0));
              });
            }
            await Configs.machineCategolaryDao.deleteAllRow();
            await Configs.machineCategolaryDao.insertMachineCategolaryModels(valua);
          } else {
            temp_machinecato = await Configs.machineCategolaryDao.findAllMachineCategolaryModel();
            if (temp_machinecato == null || temp_machinecato.length == 0) {
              setState(() {
                Configs.lstMachineCata = [];
              });
            } else {
              if (this.mounted) {
                setState(() {
                  Configs.lstMachineCata = temp_machinecato;
                });
              }
            }
          }
        })
      ]);
    } catch (e) {
      Configs.lstLine = [];
      // Configs.lst_cell = [];
      Configs.lstMachineCata = [];
      FlutterCrashlytics().log(e.toString(),
          priority: 200,
          tag: 'Error in initDataNetword in '
              'homescreen');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  scan() async {
    String _reader = "";
    try {
      _reader = await BarcodeScanner.scan();
      if (!mounted) {
        return null;
      }
    } on PlatformException catch (e, stacktrace) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error');
      FlutterCrashlytics().logException(e, stacktrace);
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Toast.show(allTranslations.text("camera_access_deny"), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        return null;
      } else {
        return null;
      }
    } on FormatException {
      return null;
    } catch (e) {
      {
        FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in scan homwscreen');
        FlutterCrashlytics().logException(e, e.stackTrace);
      }
    }
  }

  @override
  void initState() {
    _bottomNavBarStream = new BottomNavBarStream();
    numberStream = new NumberStream();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    super.initState();
  }

  Future<void> onSelectNotification(String payload) async {
    _bottomNavBarStream.pickItem(3);
  }

  Future<void> _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'Bình luận',
      'Chat và bình luận sự kiện',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  Future<void> onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bottomNavBarStream.close();
    numberStream.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () => onWillScope(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarStream.itemStream,
          initialData: _bottomNavBarStream.defaultItem,
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.NEWFEET:
                return NewsFeedPage();
              case NavBarItem.SEND_REQUEST:
                return ScanPage();
              case NavBarItem.LIST_REQUEST:
                return ListRequestsPage();
              case NavBarItem.NOTIFICATONS:
                numberStream.pushNumber(0);
                return NotificationsPage();
              default:
                return NewsFeedPage();
            }
          },
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _bottomNavBarStream.itemStream,
          initialData: _bottomNavBarStream.defaultItem,
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              //  Theme.of(context).backgroundColor,
              fixedColor: Colors.orange,
              currentIndex: snapshot.data.index,
              onTap: _bottomNavBarStream.pickItem,

              items: [
                BottomNavigationBarItem(
                  title: Text(
                    allTranslations.text("newsfeed"),
                    style: StylesText.style13,
                  ),
                  icon: Icon(Icons.dashboard),
                ),
                BottomNavigationBarItem(
                  title: Text(allTranslations.text("send_request"), style: StylesText.style13),
                  icon: Icon(Icons.add_to_queue),
                ),
                BottomNavigationBarItem(
                  title: Text(allTranslations.text("list_request"), style: StylesText.style13),
                  icon: Icon(Icons.assignment),
                ),
                BottomNavigationBarItem(
                    title: Text(allTranslations.text("notificattion_menu"), style: StylesText.style13),
                    icon: StreamBuilder<int>(
                        stream: numberStream.numberStream,
                        initialData: 0,
                        builder: (context, snapshot) {
                          return Badge(
                            badgeColor: snapshot.data > 0 ? Colors.red : Colors.transparent,
                            elevation: 0.0,
                            badgeContent:
                                Text(snapshot.hasData ? snapshot.data.toString() : "", style: StylesText.styele8White),
                            shape: BadgeShape.circle,
                            child: Icon(Icons.notifications),
                          );
                        }))
              ],
            );
          },
        ),
        drawer: Drawer(
          child: DrawerMenuPage(),
        ),
      ),
    );
  }

  Future<void> onWillScope() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      return Toast.show(allTranslations.text("exit_app"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
