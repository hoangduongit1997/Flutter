import 'package:flutter/material.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/radio_model.dart';
import 'package:pika_maintenance/data/model/request_model.dart';
import 'package:pika_maintenance/data/repository/send_comment_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomRadioRequestStatus extends StatefulWidget {
  RequestModel requestModel;
  CustomRadioRequestStatus(this.requestModel);
  @override
  createState() {
    return new CustomRadioRequestStatusState();
  }
}

class CustomRadioRequestStatusState extends State<CustomRadioRequestStatus> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    super.initState();
//    sampleData.add(new RadioModel(
//        widget.requestModel.statusCode == 0, 0, allTranslations.text("status_request_waitting"), '', Colors.blue));
//    sampleData.add(new RadioModel(
//        widget.requestModel.statusCode == 1, 1, allTranslations.text("status_request_recieved"), '', Colors.grey));
    sampleData.add(new RadioModel(
        widget.requestModel.statusCode == 2, 2, allTranslations.text("status_request_checking"), '', Colors.green));
    sampleData.add(new RadioModel(
        widget.requestModel.statusCode == 3, 3, allTranslations.text("status_request_fixing"), '', Colors.purple));
    sampleData.add(new RadioModel(widget.requestModel.statusCode == 4, 4,
        allTranslations.text("status_request_pending"), '', Colors.yellow[300]));
    sampleData.add(new RadioModel(
        widget.requestModel.statusCode == 5, 5, allTranslations.text("status_request_finish"), '', Colors.orange));
    sampleData.add(new RadioModel(
        widget.requestModel.statusCode == 6, 6, allTranslations.text("status_request_closed"), '', Colors.blueGrey));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.all(0.0),
      itemCount: sampleData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Configs.user.roleID == "admin" || Configs.user.roleID == "mainten"
                  ? handelTap(index)
                  : Configs.user.roleID == "user" &&
                          widget.requestModel.statusCode < 2 &&
                          sampleData[index].codeStatus < 6
                      ? handelTap1()
                      : Configs.user.roleID == "user" &&
                              widget.requestModel.statusCode < 2 &&
                              sampleData[index].codeStatus >= 6
                          ? handelTap(index)
                          : Configs.user.roleID == "user" && widget.requestModel.statusCode > 2
                              ? handelTap1()
                              : handelTap(index);
            },
            child: checkPermission(sampleData[index]));
      },
    );
  }

  handelTap(int index) {
    setState(() {
      widget.requestModel.statusCode = sampleData[index].codeStatus;
      widget.requestModel.statusName = sampleData[index].buttonText;
      sampleData.forEach((element) => element.isSelected = false);
      sampleData[index].isSelected = true;
    });
  }

  handelTap1() {
    return;
  }

  Widget checkPermission(RadioModel _item) {
    return Configs.user.roleID == "admin" || Configs.user.roleID == "mainten"
        ? RadioItem(_item)
        : Configs.user.roleID == "user" && widget.requestModel.statusCode < 2
            ? Opacity(
                opacity: _item.codeStatus < 6 ? 0.5 : 1.0,
                child: RadioItem(_item),
              )
            : Configs.user.roleID == "user" && widget.requestModel.statusCode >= 2
                ? Opacity(
                    opacity: 0.5,
                    child: RadioItem(_item),
                  )
                : RadioItem(_item);
  }
}

Widget RadioItem(RadioModel _item) {
  return Container(
    width: Dimension.getWidth(0.18),
    height: Dimension.getWidth(0.05),
    margin: const EdgeInsets.all(1.0),
    child: new Center(
      child: FittedBox(
        child: new Text(_item.buttonText,
            style: new TextStyle(
                color: _item.isSelected ? Colors.white : Colors.black,
                fontWeight: _item.isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11.0)),
      ),
    ),
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: _item.isSelected ? _item.color : Colors.transparent,
      border: new Border.all(width: 1.0, color: _item.isSelected ? _item.color : Colors.grey),
    ),
  );
}
