import 'package:flutter/material.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';
import 'package:pika_maintenance/data/repository/edit_cell_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';

import 'package:pika_maintenance/streams/create_cell_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class EditCellManagerPage extends StatefulWidget {
  CellModel item;
  EditCellManagerPage(this.item);
  @override
  EditCellManagerPageState createState() => EditCellManagerPageState();
}

class EditCellManagerPageState extends State<EditCellManagerPage> {
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
            (Configs.lstLine.indexOf(line) + 1).toString() +
                ". " +
                line.code,
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
    name_cell = new TextEditingController(text: widget.item.code);
    _dropDownMenuItems_Lines = getDropDownMenuItems_Lines();
    _currentItem = _dropDownMenuItems_Lines[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Sửa cell " + widget.item.code,
            style: StylesText.style16While,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Alert(
                  context: context,
                  title: "Sửa cell " + widget.item.code,
                  content: Text(
                    allTranslations.text("save_change_alert"),
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
                        await onEditCell();
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
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      "Sửa thông tin cell " + widget.item.code,
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
                            hint: Text(allTranslations.text("choose_line"),
                                style: StylesText.style13Blugray),
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
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                errorStyle: StylesText.style10Red,
                                labelText: "Sửa tên cell",
                                hintText:
                                    allTranslations.text("enter_name_of_cell"),
                                hintStyle: StylesText.style12black12,
                                labelStyle: StylesText.styele00128100,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(10.0)),
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

  Future onEditCell() async {
    if (_currentItem == null || _currentItem.lineId == null) {
      Navigator.of(context).pop();
      return Toast.show(allTranslations.text("not_choose_line_yet"), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      if (create_new_cell_stream.isValidInfo(name_cell.text.trim())) {
        if (await Validations.isConnectedNetwork() == true) {
          EditCellRepository(
            _currentItem.lineId,
            widget.item.id,
            name_cell.text.trim(),
          ).then((value) {
            if (value == 1) {
              //cập nhật thành công
              if (this.mounted) {
                setState(() {
                  widget.item.code = name_cell.text;
                  widget.item.lineId = _currentItem.lineId;
                });
              }
              Navigator.of(context).pop(true);
              return Toast.show(allTranslations.text("success_add"), context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            } else {
              Navigator.of(context).pop(false);
              return MessageDialog.showMsgDialog(
                  context,
                  allTranslations.text("notification"),
                  allTranslations.text("error"),
                  AlertType.error);
            }
          });
        } else {
          Navigator.of(context).pop(false);
          return MessageDialog.showMsgDialog(
              context,
              allTranslations.text("notification"),
              allTranslations.text("netword_faile"),
              AlertType.warning);
        }
      } else {
        return Navigator.of(context).pop(false);
      }
    }
  }
}
