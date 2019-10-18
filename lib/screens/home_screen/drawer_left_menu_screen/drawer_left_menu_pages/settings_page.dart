import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';

import 'package:pika_maintenance/styles/styles.dart';

import 'change_language_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with AfterLayoutMixin<SettingsPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController version;
  @override
  void initState() {
    version = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.8,
        backgroundColor: Colors.orange,
        title: Text(
          allTranslations.text("settings"),
          style: StylesText.style18WhiteBold,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.all(2.0),
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => ChangeLanguagePage()));
                },
                title: Text(
                  allTranslations.text("language").toString(),
                  style: StylesText.style15Black,
                ),
                trailing: Text(
                    allTranslations.text("language_settings").toString(),
                    style: StylesText.style14Blue),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  allTranslations.text("terms"),
                  style: StylesText.style15Black,
                ),
                trailing:
                    Icon(Icons.arrow_forward_ios, color: Colors.grey[300]),
              ),
            ),
            Card(
              elevation: 0.0,
              child: ListTile(
                title: Text(
                  allTranslations.text("version").toString() +
                      ": " +
                      version.text,
                  style: StylesText.style13Blugray,
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version.text = packageInfo.version;
      });
    });
  }
}
