import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';

class ChangeLanguagePage extends StatefulWidget {
  ChangeLanguagePage({Key key}) : super(key: key);

  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<ChangeLanguagePage> with AfterLayoutMixin <ChangeLanguagePage>{
  Locale currentLang;
  int tap_en;
  int tap_vn;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          allTranslations.text("language").toString(),
          style: StylesText.style16While,
        ),
        leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            )),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(2.0),
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                  leading: SvgPicture.asset(
                    "assets/icons/america.svg",
                    width: Dimension.getWidth(0.1),
                    height: Dimension.getWidth(0.1),
                  ),
                  onTap: () async {
                    tap_vn = 0;
                    if (tap_en == 0) {
                      await allTranslations.setNewLanguage('en');
                      setState(() {
                        if (Configs.isTapEn == true) {
                          Configs.isTapEn = true;
                          Configs.isTapVn = false;
                        } else {
                          Configs.isTapEn = true;
                          Configs.isTapVn = false;
                        }
                      });
                    }
                    tap_en++;
                  },
                  title: Text(
                    "English",
                    style: StylesText.style13Black,
                  ),
                  trailing: Icon(Icons.check,
                      color: Configs.isTapEn
                          ? Colors.orange
                          : Colors.transparent)),
            ),
            Card(
              child: ListTile(
                onTap: () async {
                  tap_en = 0;
                  if (tap_vn == 0) {
                    await allTranslations.setNewLanguage('vi');
                    setState(() {
                      if (Configs.isTapVn) {
                        Configs.isTapVn = true;
                        Configs.isTapEn = false;
                      } else {
                        Configs.isTapVn = true;
                        Configs.isTapEn = false;
                      }
                    });
                  }
                  tap_vn++;
                },
                leading: SvgPicture.asset("assets/icons/vietnam.svg",
                    width: Dimension.getWidth(0.1),
                    height: Dimension.getWidth(0.1)),
                title: Text(
                  "Tiếng Việt",
                  style: StylesText.style13Black,
                ),
                trailing: Icon(Icons.check,
                    color:
                        Configs.isTapVn ? Colors.orange : Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      tap_en = 0;
      tap_vn = 0;
    });
  }
}
