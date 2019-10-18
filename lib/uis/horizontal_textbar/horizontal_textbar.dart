import 'package:flutter/material.dart';
import 'package:pika_maintenance/data/model/request_model.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/styles/styles.dart';

class HorizontalTextBar extends StatelessWidget {
  const HorizontalTextBar({Key key, this.colorReport, this.statusReport, this.requestModel}) : super(key: key);

  final Color colorReport;
  final String statusReport;
  final RequestModel requestModel;
  String getStatusRequest(RequestModel requestModel) {
    switch (requestModel.statusCode) {
      case 0:
        {
          return allTranslations.text("status_request_waitting");
        }
      case 1:
        {
          return allTranslations.text("status_request_recieved");
        }
      case 2:
        {
          return allTranslations.text("status_request_checking");
        }
      case 3:
        {
          return allTranslations.text("status_request_fixing");
        }
      case 4:
        {
          return allTranslations.text("status_request_pending");
        }
      case 5:
        {
          return allTranslations.text("status_request_finish");
        }
      case 6:
        {
          return allTranslations.text("status_request_closed");
        }
      case 7:
        {
          return allTranslations.text("status_machine_moving");
        }
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        alignment: Alignment(1, -1),
        child: Container(
          padding: EdgeInsets.only(right: 2.5),
          height: double.infinity,
          width: 20,
          color: colorReport,
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              getStatusRequest(requestModel),
              textAlign: TextAlign.center,
              style: StylesText.style13WhiteBold,
            ),
          ),
        ),
      ),
    );
  }
}
