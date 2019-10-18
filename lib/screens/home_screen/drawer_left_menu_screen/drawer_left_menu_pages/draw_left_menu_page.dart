import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/machines_manager_page.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/settings_page.dart';
import 'package:pika_maintenance/screens/login_screen/login_screen.dart';
import 'package:pika_maintenance/screens/user_screen/userpage.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cells_manager_page.dart';
import 'lines_manager_page.dart';
import 'machines_categolary_manager_page.dart';
import 'package:intl/intl.dart';

class DrawerMenuPage extends StatefulWidget {
  @override
  _DrawerMenuPageState createState() => _DrawerMenuPageState();
}

class _DrawerMenuPageState extends State<DrawerMenuPage> with AfterLayoutMixin<DrawerMenuPage> {
  Future initData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String time = sharedPreferences.getString("login_time");
    if (this.mounted) {
      setState(() {
        Configs.timeLogin = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(time));
      });
    }
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    await initData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
            accountName: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 25,
                ),
                Text(
                  Configs.user == null || Configs.user.fullName == null ? "Tên" : Configs.user.fullName,
                  style: StylesText.style18WhiteBold,
                ),
              ],
            ),
            accountEmail: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.input, color: Colors.white, size: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    Configs.timeLogin ?? "",
                    style: StylesText.style13WhiteBold,
                  ),
                ),
              ],
            ),
            currentAccountPicture: GestureDetector(
                child: Container(
              height: Dimension.getWidth(0.5),
              width: Dimension.getWidth(0.2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  //  border: Border.all(color: Colors.orange, width: 1.0),
                  shape: BoxShape.circle,
                  image: DecorationImage(fit: BoxFit.fill, image: ExactAssetImage('assets/images/login.png'))),
            )),
            decoration: new BoxDecoration(
              color: Colors.orange,

              // gradient: new LinearGradient(
              //     begin: FractionalOffset.bottomRight,
              //     end: FractionalOffset.topLeft,
              //     colors: [
              //       Colors.orange,
              //       Colors.white,
              //     ]
              //     ),
              // image: new DecorationImage(
              //     image: new ExactAssetImage('assets/images/drawer.jpg'),
              //     fit: BoxFit.cover),
            )),
        InkWell(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => UserPage()));
          },
          child: ListTile(
            title: Text(
              allTranslations.text("account"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(
              Icons.person_outline,
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => LinesManagerPage()));
          },
          child: ListTile(
            title: Text(
              allTranslations.text("line_manager"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(
              Icons.clear_all,
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .push(CupertinoPageRoute(builder: (context) => Cells_Manager_Page()));
          },
          child: ListTile(
            title: Text(
              allTranslations.text("cell_manager"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(
              Icons.grid_on,
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MachinesCategolaryManagerPage()));
          },
          child: ListTile(
            title: Text(
              allTranslations.text("machine_Cata_manager"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(
              Icons.desktop_mac,
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .push(CupertinoPageRoute(builder: (context) => MachinesManagerPage()));
          },
          child: ListTile(
            title: Text(
              allTranslations.text("machine_manager"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(
              Icons.airplay,
              color: Colors.grey,
            ),
          ),
        ),
//        InkWell(
//          child: ListTile(
//            title: Text(
//              allTranslations.text("factory"),
//              style: StylesText.style13BlackBold,
//            ),
//            leading: Icon(Icons.account_balance, color: Colors.grey,),
//            onTap: () {},
//          ),
//        ),
        Divider(
          height: 4.0,
          color: Colors.black38,
          indent: 15.0,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SettingsPage()));
          },
          child: ListTile(
            title: Text(
              allTranslations.text("settings"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            title: Text(
              allTranslations.text("help"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(
              Icons.help_outline,
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            if (await Validations.isConnectedNetwork() == true) {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.clear();
              Navigator.of(context, rootNavigator: true)
                  .pushReplacement(CupertinoPageRoute(builder: (context) => LoginScreen()));
            } else {
              return MessageDialog.showMsgDialog(context, allTranslations.text("notification"),
                  allTranslations.text("netword_faile"), AlertType.warning);
            }
          },
          child: ListTile(
            title: Text(
              allTranslations.text("logout"),
              style: StylesText.style13BlackBold,
            ),
            leading: Icon(Icons.exit_to_app, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
