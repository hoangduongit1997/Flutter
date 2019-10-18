import 'package:flutter/material.dart';
import 'package:pika_maintenance/data/model/radio_model.dart';
import 'package:pika_maintenance/data/model/request_model.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/utils/utils.dart';

class CustomRadioMachineStatus extends StatefulWidget {
  RequestModel requestModel;
  CustomRadioMachineStatus(this.requestModel);
  @override
  createState() {
    return new CustomRadioMachineStatusState();
  }
}

class CustomRadioMachineStatusState extends State<CustomRadioMachineStatus> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(
        widget.requestModel.machineStatusCode == 0, 0, allTranslations.text("status_machine_no_use"), '', Colors.grey));
    sampleData.add(new RadioModel(widget.requestModel.machineStatusCode == 1, 1,
        allTranslations.text("status_machine_running"), '', Colors.green));
    sampleData.add(new RadioModel(
        widget.requestModel.machineStatusCode == 2, 2, allTranslations.text("status_machine_stop"), '', Colors.black));
    sampleData.add(new RadioModel(
        widget.requestModel.machineStatusCode == 3, 3, allTranslations.text("status_machine_broken"), '', Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sampleData.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              widget.requestModel.machineStatusCode = sampleData[index].codeStatus;
              widget.requestModel.machineStatusName = sampleData[index].buttonText;
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
            });
          },
          child: new RadioItem(sampleData[index]),
        );
      },
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            width: Dimension.getWidth(0.18),
            height: Dimension.getWidth(0.18) / 2.0,
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
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}
