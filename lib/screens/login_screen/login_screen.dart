import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:pika_maintenance/data/repository/login_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/home_screen.dart';

import 'package:pika_maintenance/streams/login_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/loading_dialog.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> with AfterLayoutMixin<LoginScreen> {
  final FocusNode _userName = FocusNode();
  final FocusNode _passWord = FocusNode();
  LoginStream loginStream;
  DateTime currentBackPressTime;
  bool _showpass = false;
  TextEditingController username;
  TextEditingController password;
  TextEditingController version;
  @override
  void initState() {
    username = new TextEditingController();
    password = new TextEditingController();
    version = new TextEditingController();
    loginStream = new LoginStream();
    super.initState();
  }

  @override
  void dispose() {
    loginStream.dispose();
    super.dispose();
  }

  Future _submitlogin() async {
    LoadingDialog.showLoadingDialog(context);
    if (loginStream.isValidInfo(username.text.trim(), password.text.trim())) {
      if (await Validations.isConnectedNetwork() == true) {
        LoginRepository(username.text.trim(), password.text.trim()).then((va) {
          if (va == 1) {
            LoadingDialog.hideLoadingDialog(context);
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => HomeScreen()));
          } else if (va == -1) {
            LoadingDialog.hideLoadingDialog(context);
            MessageDialog.showMsgDialog(
                context, allTranslations.text("notification"), allTranslations.text("login_faile"), AlertType.warning);
          } else {
            LoadingDialog.hideLoadingDialog(context);
            MessageDialog.showMsgDialog(
                context, allTranslations.text("notification"), allTranslations.text("error"), AlertType.error);
          }
        });
      } else {
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
      }
    } else {
      LoadingDialog.hideLoadingDialog(context);
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _form() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(top: 50.0, bottom: 30.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.asset(
                "assets/images/login.png",
                width: Dimension.getWidth(0.5),
                height: Dimension.getWidth(0.5),
                filterQuality: FilterQuality.high,
                fit: BoxFit.contain,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: StreamBuilder<Object>(
              stream: loginStream.usernameStream,
              builder: (context, snapshot) {
                return new TextFormField(
                  controller: username,
                  textInputAction: TextInputAction.next,
                  focusNode: _userName,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _userName, _passWord);
                  },
                  decoration: new InputDecoration(
                    errorText: snapshot.hasError ? snapshot.error : null,
                    errorStyle: StylesText.style10Red,
                    labelText: allTranslations.text("username_login"),
                    hintText: allTranslations.text("username_login_hint"),
                    hintStyle: StylesText.style12black12,
                    labelStyle: StylesText.styele00128100,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                    ),
                    prefixIcon: const Icon(
                      Icons.account_circle,
                      color: textColor,
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: StreamBuilder<Object>(
              stream: loginStream.passStream,
              builder: (context, snapshot) {
                return new TextFormField(
                  controller: password,
                  textInputAction: TextInputAction.done,
                  focusNode: _passWord,
                  obscureText: !_showpass,
                  onFieldSubmitted: (va) async {
                    await _submitlogin();
                  },
                  decoration: new InputDecoration(
                    errorText: snapshot.hasError ? snapshot.error : null,
                    errorStyle: StylesText.style10Red,
                    labelText: allTranslations.text("password_login"),
                    hintText: allTranslations.text("password_login_hint"),
                    hintStyle: StylesText.style12black12,
                    labelStyle: StylesText.styele00128100,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                      borderSide: new BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: textColor,
                    ),
                    suffix: GestureDetector(
                      onTap: ShowPass,
                      child: Container(
                        child: Text(
                          _showpass
                              ? allTranslations.text("hide_password").toString()
                              : allTranslations.text("show_password").toString(),
                          style: StylesText.style15BluegrayBold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              onPressed: () async {
                await _submitlogin();
              },
              child: Text(
                allTranslations.text("login_button").toUpperCase(),
                style: StylesText.style16While,
              ),
              color: Colors.orange),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
          child: Text(allTranslations.text("version") + " " + version.text, style: StylesText.style12Gray),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => onWillScope(),
        child: Scaffold(
            body: Container(
                color: Theme.of(context).backgroundColor,
                constraints: BoxConstraints.expand(),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: new ClipRect(
                            child: new BackdropFilter(
                              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: new Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: _form(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

  void ShowPass() {
    setState(() {
      _showpass = !_showpass;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version.text = packageInfo.version;
      });
    });
  }

  Future<void> onWillScope() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      return Toast.show(allTranslations.text("press_exit"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }
}
