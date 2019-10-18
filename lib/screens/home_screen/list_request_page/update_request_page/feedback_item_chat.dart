import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/machine_status_model.dart';
import 'package:pika_maintenance/data/model/request_model.dart';
import 'package:pika_maintenance/data/repository/fetch_data_status.dart';
import 'package:pika_maintenance/data/repository/send_comment_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/custom_radio/custom_radio_status_machine.dart';
import 'package:pika_maintenance/uis/custom_radio/custom_radio_status_request.dart';
import 'package:pika_maintenance/uis/description_text/description_text.dart';

import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/uis/time_text/time_text.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FeedbackItemChat extends StatefulWidget {
  RequestModel requestModel;
  FeedbackItemChat(this.requestModel);

  @override
  _FeedbackItemChatState createState() => _FeedbackItemChatState();
}

class _FeedbackItemChatState extends State<FeedbackItemChat> with AfterLayoutMixin<FeedbackItemChat> {
  getColor(int code) {
    switch (code) {
      case 0:
        return Colors.blue;
        break;
      case 1:
        return Colors.grey;
        break;
      case 2:
        return Colors.green;
        break;
      case 3:
        return Colors.purple;
        break;
      case 4:
        return Colors.yellow;
        break;
      case 5:
        return Colors.orange;
        break;
      case 6:
        return Colors.blueGrey;
        break;
      case 7:
        return Colors.red;
        break;
      default:
        return Colors.orange[200];
    }
  }

  MachineStatusModel currentMachineStatus;
  List<DropdownMenuItem<MachineStatusModel>> _dropDownMenuItemsMachineStatus;
  List<DropdownMenuItem<MachineStatusModel>> getDropDownMenuItem_MachineStatus() {
    List<DropdownMenuItem<MachineStatusModel>> items = new List();

    for (MachineStatusModel machine in listStatusMachine) {
      items.add(
        new DropdownMenuItem(
          value: machine,
          child: FittedBox(
            child: new Text(
              (listStatusMachine.indexOf(machine) + 1).toString() + ". " + machine.status,
              style: StylesText.style13Black,
            ),
          ),
        ),
      );
    }
    return items;
  }

  void changedDropDownItem_Machine_Status(MachineStatusModel selectedmachinecato) {
    setState(() {
      widget.requestModel.machineStatusCode = int.tryParse(selectedmachinecato.id);
      widget.requestModel.machineStatusName = selectedmachinecato.status;
      currentMachineStatus = selectedmachinecato;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    initStatusMachine();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Card(
        borderOnForeground: true,
        child: Container(
          color: Theme.of(context).backgroundColor,
          width: Dimension.getWidth(1.0),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          widget.requestModel?.requestId.toString() ?? "",
                          textAlign: TextAlign.center,
                          style: StylesText.style16While,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.requestModel.machineCateCode ?? "",
                              style: StylesText.style18OrangeBold,
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: TimeText(timeHasPassed: widget.requestModel.inputtedTime),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.requestModel.machineCode ?? "",
                              style: StylesText.style14Grey,
                            ),
                            AbsorbPointer(
                              absorbing:
                                  Configs.user.roleID == "mainten" || Configs.user.roleID == "admin" ? false : true,
                              child: Opacity(
                                opacity: Configs.user.roleID == "mainten" || Configs.user.roleID == "admin" ? 1.0 : 0.5,
                                child: Container(
                                    width: Dimension.getWidth(0.3),
                                    height: Dimension.getHeight(0.052),
                                    child: ButtonTheme(
                                      alignedDropdown: false,
                                      child: DropdownButton(
                                        elevation: 20,
                                        style: StylesText.style13Black,
                                        isExpanded: true,
                                        hint: FittedBox(
                                          child: Text(allTranslations.text("machine_status"),
                                              style: StylesText.style13Black),
                                        ),
                                        value: currentMachineStatus,
                                        items: _dropDownMenuItemsMachineStatus,
                                        onChanged: changedDropDownItem_Machine_Status,
                                      ),
                                    )
//                              CustomRadioMachineStatus(widget.requestModel),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                    child: Text(
                      allTranslations.text("change_request_status"),
                      style: StylesText.style15BlueBold,
                    ),
                  )
                ],
              ),
              Container(
                  width: Dimension.getWidth(1.0),
                  height: Dimension.getHeight(0.05),
                  child: CustomRadioRequestStatus(widget.requestModel)),
//              widget.requestModel.description == null || widget.requestModel.description.length == 0
//                  ? Container()
//                  : Row(
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
//                          child: Text(
//                            allTranslations.text("detaile_request"),
//                            style: StylesText.style15Black,
//                          ),
//                        )
//                      ],
//                    ),
              widget.requestModel.description == null || widget.requestModel.description.length == 0
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: DescriptionText(widget.requestModel.description),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void initStatusMachine() {
    setState(() {
      _dropDownMenuItemsMachineStatus = getDropDownMenuItem_MachineStatus();
      currentMachineStatus = _dropDownMenuItemsMachineStatus[widget.requestModel.machineStatusCode]?.value ?? null;
    });
  }
}
