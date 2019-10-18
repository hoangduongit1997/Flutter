import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/line_model.dart';

import 'package:pika_maintenance/data/repository/create_cell_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';

import 'package:pika_maintenance/streams/create_cell_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class CreateCellManagerPage extends StatefulWidget {
  @override
  _New_CellState createState() => _New_CellState();
}

class _New_CellState extends State<CreateCellManagerPage> {
  LineModel _currentItem;
  TextEditingController name_cell;
  CreateCellStream create_new_cell_stream;
  List<DropdownMenuItem<LineModel>> _dropDownMenuItems_Lines;

  List<DropdownMenuItem<LineModel>> getDropDownMenuItems_Lines() {
    List<DropdownMenuItem<LineModel>> items = new List();

    for (LineModel line in Configs.lstLine) {
      items.add(new DropdownMenuItem(
          value: line,
          child: new Text(
            (Configs.lstLine.indexOf(line) + 1).toString() + ". " + line.code,
            style: StylesText.style12Black,
          )));
    }
    return items;
  }

  void changedDropDownItem_Lines(LineModel selectedline) {
    setState(() {
      _currentItem = selectedline;
    });
  }

  @override
  void initState() {
    create_new_cell_stream = new CreateCellStream();
    name_cell = new TextEditingController();
    _dropDownMenuItems_Lines = getDropDownMenuItems_Lines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            allTranslations.text("create_cell"),
            style: StylesText.style16While,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Alert(
                  context: context,
                  title: allTranslations.text("create_cell"),
                  content: Text(
                    allTranslations.text("create_cell_question"),
                    style: StylesText.style13Black,
                    textAlign: TextAlign.center,
                  ),
                  buttons: [
                    DialogButton(
                      child: Text(
                        allTranslations.text("no"),
                        style: StylesText.style13WhiteBold,
                      ),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.orange,
                    ),
                    DialogButton(
                      child: Text(
                        allTranslations.text("yes"),
                        style: StylesText.style13WhiteBold,
                      ),
                      onPressed: () async {
                        await onNewCell();
                      },
                      color: Colors.orange,
                    )
                  ],
                ).show();
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        body: Container(
          height: Dimension.getHeight(1.0),
          width: Dimension.getWidth(1.0),
          color: Theme.of(context).backgroundColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      allTranslations.text("newcell_information"),
                      textAlign: TextAlign.center,
                      style: StylesText.style18RedItalic,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            elevation: 20,
                            style: StylesText.style13Black,
                            isExpanded: true,
                            hint: Text(allTranslations.text("choose_line"), style: StylesText.style13Blugray),
                            value: _currentItem,
                            items: _dropDownMenuItems_Lines,
                            onChanged: changedDropDownItem_Lines,
                          ))),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: StreamBuilder<Object>(
                          stream: create_new_cell_stream.titleStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: name_cell,
                              textInputAction: TextInputAction.done,
                              decoration: new InputDecoration(
                                errorText: snapshot.hasError ? snapshot.error : null,
                                errorStyle: StylesText.style10Red,
                                labelText: allTranslations.text("new_cell_name"),
                                hintText: allTranslations.text("enter_name_of_cell"),
                                hintStyle: StylesText.style12black12,
                                labelStyle: StylesText.styele00128100,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                            );
                          })),
                ],
              ),
            ),
          ),
        ));
  }

  Future onNewCell() async {
    if (_currentItem == null || _currentItem.lineId == null) {
      Navigator.of(context).pop();
      return Toast.show(allTranslations.text("not_choose_line_yet"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      if (create_new_cell_stream.isValidInfo(name_cell.text.trim())) {
        if (await Validations.isConnectedNetwork() == true) {
          CreateCellRepository(name_cell.text.trim(), _currentItem.lineId).then((value) {
            if (value == 1) {
              Navigator.of(context).pop(true);
              return Toast.show(allTranslations.text("add_success"), context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            } else {
              Navigator.of(context).pop(false);
              return MessageDialog.showMsgDialog(
                  context, allTranslations.text("notification"), allTranslations.text("error"), AlertType.error);
            }
          });
        } else {
          Navigator.of(context).pop(false);
          return MessageDialog.showMsgDialog(
              context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
        }
      } else {
        return Navigator.of(context).pop(false);
      }
    }
  }
}
