import 'package:after_layout/after_layout.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/model/machine_in_cell_model.dart';
import 'package:pika_maintenance/data/model/machine_model.dart';
import 'package:pika_maintenance/data/model/machine_status_model.dart';
import 'package:pika_maintenance/data/repository/edit_machine_repository.dart';
import 'package:pika_maintenance/data/repository/fetch_data_status.dart';
import 'package:pika_maintenance/data/repository/get_cells_repository.dart';
import 'package:pika_maintenance/data/repository/get_machines_categolary_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/streams/create_lines_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/loading_dialog.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class TabMachineInfo extends StatefulWidget {
  MachineInCellModel machine;
  TabMachineInfo(this.machine);
  @override
  State createState() => new TabMachineInfoState();
}

class TabMachineInfoState extends State<TabMachineInfo>
    with AfterLayoutMixin<TabMachineInfo>, AutomaticKeepAliveClientMixin<TabMachineInfo> {
  LineModel _currentItem_Line;
  CellModel _currentItem_Cell;
  MachineStatusModel _currentMachineStatus;
  List<CellModel> lst_cell = [];
  MachineCategolaryModel _currentItem_Machine_Cata;
  CreateLineStream create_lines_stream;
  TextEditingController name_cato;
  List<MachineCategolaryModel> lst_machine_cato = [];
  List<DropdownMenuItem<LineModel>> _dropDownMenuItems_Lines;
  List<DropdownMenuItem<CellModel>> _dropDownMenuItems_Cells;
  List<DropdownMenuItem<MachineCategolaryModel>> _dropDownMenuItems_Machine_Cato;
  TextEditingController position;
  List<DropdownMenuItem<MachineStatusModel>> _dropDownMenuItems_MachineStatus;
  List<DropdownMenuItem<MachineStatusModel>> getDropDownMenuItem_MachineStatus() {
    List<DropdownMenuItem<MachineStatusModel>> items = new List();

    for (MachineStatusModel machine in listStatusMachine) {
      items.add(new DropdownMenuItem(
          value: machine,
          child: new Text(
            (listStatusMachine.indexOf(machine) + 1).toString() + ". " + machine.status,
            style: StylesText.style13Black,
          )));
    }
    return items;
  }

  void changedDropDownItem_Machine_Status(MachineStatusModel selectedmachinecato) {
    setState(() {
      _currentMachineStatus = selectedmachinecato;
    });
  }

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

  void changedDropDownItem_Lines(LineModel selectedline) {
    try {
      setState(() {
        _currentItem_Line = selectedline;
      });
      _currentItem_Cell = null;
      List<CellModel> temp = lst_cell.where((i) => i.lineId == _currentItem_Line.lineId).toList();
      _dropDownMenuItems_Cells = getDropDownMenuItems_Cell(temp);
    } catch (e) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in '
          'changedDropDownItem_Lines in machine info');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
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
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    name_cato = new TextEditingController(
        text: widget.machine.machineCode == null || widget.machine.machineCode.length == 0
            ? ""
            : widget.machine.machineCode);
    position = new TextEditingController(text: widget.machine.locationInCell ?? "");
    Future.wait([initData()]);
  }

  Future initData() async {
    try {
      if (this.mounted) {
        setState(() {
          _dropDownMenuItems_MachineStatus = getDropDownMenuItem_MachineStatus();
          _currentMachineStatus =
              _dropDownMenuItems_MachineStatus[int.tryParse(widget.machine?.machineStatusCode ?? 0)].value;
          _dropDownMenuItems_Lines = getDropDownMenuItems_Lines(Configs.lstLine);
          _currentItem_Line = _dropDownMenuItems_Lines[Configs.lstLine.indexOf(Configs.lstLine
                  .firstWhere((t) => t.lineId == widget.machine.lineId, orElse: () => Configs.lstLine[0]))]
              .value;
        });
      }

      if (await Validations.isConnectedNetwork() == true) {
        GetCellsRepository(0).then((val) {
          if (val != null) {
            if (this.mounted) {
              setState(() {
                lst_cell.addAll(val);
                _dropDownMenuItems_Cells = getDropDownMenuItems_Cell(lst_cell);
                _currentItem_Cell = _dropDownMenuItems_Cells[lst_cell
                        .indexOf(lst_cell.firstWhere((t) => t.id == widget.machine.cellId, orElse: () => lst_cell[0]))]
                    .value;
              });
            }
          }
        });
        GetMachinesCategolaryRepository().then((va) {
          if (va != null) {
            if (this.mounted) {
              setState(() {
                lst_machine_cato = va;
                _dropDownMenuItems_Machine_Cato = getDropDownMenuItems_Machine_Cate();
                _currentItem_Machine_Cata = _dropDownMenuItems_Machine_Cato[lst_machine_cato
                        .indexOf(lst_machine_cato.firstWhere((t) => t.code == widget.machine.machineCateCode))]
                    .value;
              });
            }
          }
        });
      } else {
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
      }
    } catch (e) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData mahcine info');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.grey[200],
      child: Material(
        child: RefreshIndicator(
          onRefresh: () async {
            await onrefresh();
          },
          child: _currentMachineStatus == null ||
                  _currentItem_Cell == null ||
                  _currentItem_Line == null ||
                  _currentItem_Machine_Cata == null
              ? Center(
                  child: SpinKitCircle(
                  color: Colors.orange,
                ))
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0, bottom: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          allTranslations.text("line_info"),
                                          textAlign: TextAlign.center,
                                          style: StylesText.style13BackItalic,
                                        ),
                                      ],
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
                                            hint: Text(allTranslations.text("choose_line"),
                                                style: StylesText.style13Blugray),
                                            value: _currentItem_Line,
                                            items: _dropDownMenuItems_Lines,
                                            onChanged: changedDropDownItem_Lines,
                                          ))),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          allTranslations.text("cell_info"),
                                          textAlign: TextAlign.center,
                                          style: StylesText.style13BackItalic,
                                        ),
                                      ],
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
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Thông tin vị trí",
                                          textAlign: TextAlign.center,
                                          style: StylesText.style13BackItalic,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextFormField(
                                          controller: position,
                                          autofocus: false,
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
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          allTranslations.text("machine_info_cato"),
                                          textAlign: TextAlign.center,
                                          style: StylesText.style13BackItalic,
                                        ),
                                      ],
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
                                            hint: Text(allTranslations.text("choose_category"),
                                                style: StylesText.style13Blugray),
                                            value: _currentItem_Machine_Cata,
                                            items: _dropDownMenuItems_Machine_Cato,
                                            onChanged: changedDropDownItem_Machine_Cato,
                                          ))),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Thông tin tình trạng máy",
                                          textAlign: TextAlign.center,
                                          style: StylesText.style13BackItalic,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                          elevation: 20,
                                          style: StylesText.style13Black,
                                          isExpanded: true,
                                          hint: Text(allTranslations.text("machine_status_dropdown"),
                                              style: StylesText.style13Black),
                                          value: _currentMachineStatus,
                                          items: _dropDownMenuItems_MachineStatus,
                                          onChanged: changedDropDownItem_Machine_Status),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          allTranslations.text("machine_names"),
                                          textAlign: TextAlign.center,
                                          style: StylesText.style13BackItalic,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                      child: StreamBuilder<Object>(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            return TextFormField(
                                              controller: name_cato,
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
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      child: RaisedButton(
                                        color: Colors.orange,
                                        child: Text(
                                          "Lưu",
                                          style: StylesText.style16While,
                                        ),
                                        shape:
                                            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        onPressed: () {
                                          Alert(
                                            context: context,
                                            type: AlertType.none,
                                            title: "Thông báo",
                                            desc: "Bạn có muốn lưu thay đổi không ?",
                                            buttons: [
                                              DialogButton(
                                                  child: Text(
                                                    "Không",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  color: Colors.orange),
                                              DialogButton(
                                                  child: Text(
                                                    "Có",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  color: Colors.orange),
                                            ],
                                          ).show().then((va) async {
                                            if (va == true) {
                                              await onEditMachine();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future onEditMachine() async {
//    if (create_lines_stream.isValidInfo(name_cato.text.trim())) {
    if (await Validations.isConnectedNetwork() == true) {
      if (await EditMachineRepository(_currentItem_Line.lineId, widget.machine.id, _currentItem_Machine_Cata.id,
              _currentItem_Cell.id, name_cato.text.trim(), position.text.trim(), _currentMachineStatus.id) ==
          1) {
        if (this.mounted) {
          setState(() {
            widget.machine.machineStatusCode = name_cato.text.trim();
          });
        }

        return Toast.show("Sửa thành công!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("error"), AlertType.error);
      }
    } else {
      return MessageDialog.showMsgDialog(
          context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
    }
//    }
//    else {
//      return Navigator.of(context).pop(false);
//    }
  }

  Future<void> onrefresh() async {
    Future.delayed(Duration(microseconds: 500));
    if (this.mounted) {
      setState(() {
        initState();
        build(context);
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
