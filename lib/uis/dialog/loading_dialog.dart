import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';

class LoadingDialog {
  static showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          height: Dimension.getHeight(0.15),
          child: Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: new SpinKitFadingCircle(
                    color: Color.fromARGB(255, 40, 115, 161),
                    size: 50,
                    ),
                  ),
                Expanded(
                  flex: 4,
                  child: Text(
                    allTranslations.text("loading"),
                    style: StylesText.style20Black,
                    ),
                  ),
              ],
              ),
            ),
          ),
        ),
      );
  }

  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
