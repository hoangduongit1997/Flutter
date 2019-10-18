import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/repository/get_cells_repository.dart';
import 'package:pika_maintenance/data/repository/get_machines_categolary_repository.dart';
import 'package:pika_maintenance/data/repository/create_machine_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/streams/create_cell_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class CreateMachineInScan extends StatefulWidget {
  int lineModelId;
  int cellModelId;
  String machineCode;
  int machineCategolaryModelId;
  CreateMachineInScan({this.lineModelId, this.cellModelId, this.machineCode, this.machineCategolaryModelId});
  @override
  CreateMachineInScanState createState() => CreateMachineInScanState();
}

class CreateMachineInScanState extends State<CreateMachineInScan> with AfterLayoutMixin<CreateMachineInScan> {
  LineModel _currentItem_Line;
  CellModel _currentItem_Cell;
  List<CellModel> lst_cell = [];
  List<MachineCategolaryModel> lst_machine_cato = [];
  MachineCategolaryModel _currentItem_Machine_Cata;
  TextEditingController name_cell;
  CreateCellStream create_new_cell_stream;
  TextEditingController position;
  List<DropdownMenuItem<LineModel>> _dropDownMenuItems_Lines;
  List<DropdownMenuItem<CellModel>> _dropDownMenuItems_Cells;
  List<DropdownMenuItem<MachineCategolaryModel>> _dropDownMenuItems_Machine_Cato;
  List<DropdownMenuItem<LineModel>> getDropDownMenuItems_Lines(List<LineModel> lst) {
    List<DropdownMenuItem<LineModel>> items = new List();

    for (LineModel line in lst) {
      items.add(new DropdownMenuItem(
          value: line,
          child: new Text(
            (lst.indexOf(line) + 1).toString() + ". " + line.code,
            style: StylesText.style12Black,
          )));
    }
    return items;
  }

  void changedDropDownItem_Lines(LineModel selectedline) {
    try {
      setState(() {
        _currentItem_Line = selectedline;
      });
      _currentItem_Cell = null;
      List<CellModel> temp = lst_cell.where((i) => i.lineId == _currentItem_Line.lineId).toList();
      _dropDownMenuItems_Cells = getDropDownMenuItems_Cell(temp);
    } catch (e, stackTrace) {
      FlutterCrashlytics()
          .log(e.toString(), priority: 200, tag: 'Error changedDropDownItem_Lines in create machine in scan');
      FlutterCrashlytics().logException(e, stackTrace);
    }
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    await Future.wait([
      initData(),
    ]);
    _dropDownMenuItems_Lines = getDropDownMenuItems_Lines(Configs.lstLine);
    if (widget.lineModelId != null) {
      _currentItem_Line = _dropDownMenuItems_Lines[Configs.lstLine.indexOf(
              Configs.lstLine.firstWhere((t) => t.lineId == widget.lineModelId, orElse: () => Configs.lstLine[0]))]
          .value;
    }
  }

  Future initData() async {
    if (await Validations.isConnectedNetwork() == true) {
      GetCellsRepository(0).then((val) {
        if (val != null) {
          if (this.mounted) {
            setState(() {
              lst_cell.addAll(val);
              _dropDownMenuItems_Cells = getDropDownMenuItems_Cell(lst_cell);
            });
          }
          if (widget.cellModelId != null) {
            _currentItem_Cell = _dropDownMenuItems_Cells[
                    lst_cell.indexOf(lst_cell.firstWhere((t) => t.id == widget.cellModelId, orElse: () => lst_cell[0]))]
                .value;
          }
        }
      });
      GetMachinesCategolaryRepository().then((va) {
        if (va != null) {
          if (this.mounted) {
            setState(() {
              lst_machine_cato.addAll(va);
              _dropDownMenuItems_Machine_Cato = getDropDownMenuItems_Machine_Cate();
            });
          }
          if (widget.machineCategolaryModelId != null) {
            _currentItem_Machine_Cata = _dropDownMenuItems_Machine_Cato[lst_machine_cato.indexOf(lst_machine_cato
                    .firstWhere((t) => t.id == widget.machineCategolaryModelId, orElse: () => lst_machine_cato[0]))]
                .value;
          }
        }
      });
    } else {
      return MessageDialog.showMsgDialog(
          context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
    }
  }

  List<DropdownMenuItem<CellModel>> getDropDownMenuItems_Cell(List<CellModel> lst) {
    List<DropdownMenuItem<CellModel>> items = new List();

    for (CellModel line in lst) {
      items.add(new DropdownMenuItem(
          value: line,
          child: new Text(
            (lst.indexOf(line) + 1).toString() + ". " + line.code,
            style: StylesText.style12Black,
          )));
    }
    return items;
  }

  void changedDropDownItem_Cell(CellModel selectedline) {
    setState(() {
      _currentItem_Cell = selectedline;
    });
  }

  List<DropdownMenuItem<MachineCategolaryModel>> getDropDownMenuItems_Machine_Cate() {
    List<DropdownMenuItem<MachineCategolaryModel>> items = new List();

    for (MachineCategolaryModel line in lst_machine_cato) {
      items.add(new DropdownMenuItem(
          value: line,
          child: new Text(
            (lst_machine_cato.indexOf(line) + 1).toString() + ". " + line.code,
            style: StylesText.style12Black,
          )));
    }
    return items;
  }

  void changedDropDownItem_Machine_Cato(MachineCategolaryModel selectedline) {
    setState(() {
      _currentItem_Machine_Cata = selectedline;
    });
  }

  @override
  void initState() {
    create_new_cell_stream = new CreateCellStream();
    name_cell = new TextEditingController(text: widget.machineCode ?? "");
    position = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            allTranslations.text("add_machine"),
            style: StylesText.style16While,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Alert(
                  context: context,
                  title: allTranslations.text("notification"),
                  content: Text(
                    allTranslations.text("add_machine_question"),
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
                        await onNewMachine();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          allTranslations.text("new_machine_info"),
                          textAlign: TextAlign.center,
                          style: StylesText.style18RedItalic,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      allTranslations.text("line_info"),
                      textAlign: TextAlign.center,
                      style: StylesText.style13BackItalic,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            elevation: 20,
                            style: StylesText.style13Black,
                            isExpanded: true,
                            hint: Text(allTranslations.text("choose_line"), style: StylesText.style13Blugray),
                            value: _currentItem_Line,
                            items: _dropDownMenuItems_Lines,
                            onChanged: changedDropDownItem_Lines,
                          ))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      allTranslations.text("cell_info"),
                      textAlign: TextAlign.center,
                      style: StylesText.style13BackItalic,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            elevation: 20,
                            style: StylesText.style13Black,
                            isExpanded: true,
                            hint: Text(allTranslations.text("choose_cell"), style: StylesText.style13Blugray),
                            value: _currentItem_Cell,
                            items: _dropDownMenuItems_Cells,
                            onChanged: changedDropDownItem_Cell,
                          ))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      allTranslations.text("machine_positions"),
                      textAlign: TextAlign.center,
                      style: StylesText.style13BackItalic,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          autofocus: false,
                          controller: position,
                          style: StylesText.style13Black,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 20.0, bottom: 10, top: 10),
                            hintText: allTranslations.text("machine_position_hint"),
                            hintStyle: StylesText.style13Blugray,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                              borderSide: new BorderSide(
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      allTranslations.text("machine_info_cato"),
                      textAlign: TextAlign.center,
                      style: StylesText.style13BackItalic,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            elevation: 20,
                            style: StylesText.style13Black,
                            isExpanded: true,
                            hint: Text(allTranslations.text("choose_category"), style: StylesText.style13Blugray),
                            value: _currentItem_Machine_Cata,
                            items: _dropDownMenuItems_Machine_Cato,
                            onChanged: changedDropDownItem_Machine_Cato,
                          ))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      allTranslations.text("machine_names"),
                      textAlign: TextAlign.center,
                      style: StylesText.style13BackItalic,
                    ),
                  ),
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
                                labelText: allTranslations.text("machine_name_hint"),
                                hintText: allTranslations.text("enter_machine_name"),
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

  Future onNewMachine() async {
    if (_currentItem_Line == null) {
      Navigator.of(context).pop();
      return Toast.show(allTranslations.text("not_choose_line_yet"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else if (_currentItem_Cell == null) {
      Navigator.of(context).pop();
      return Toast.show(allTranslations.text("not_choose_cell_yet"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else if (_currentItem_Machine_Cata == null) {
      Navigator.of(context).pop();
      return Toast.show(allTranslations.text("not_choose_machine_cato_yet"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      if (create_new_cell_stream.isValidInfo(name_cell.text.trim())) {
        if (await Validations.isConnectedNetwork() == true) {
          CreateMachineRepository(_currentItem_Line.lineId, _currentItem_Cell.id, _currentItem_Machine_Cata.id,
                  name_cell.text.trim(), position.text.trim())
              .then((value) {
            if (value == 1) {
              //thêm nhật thành công
              Navigator.of(context).pop(true);
              return Toast.show(allTranslations.text("success_add"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
