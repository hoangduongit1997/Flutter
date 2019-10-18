import 'package:after_layout/after_layout.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/cell_summary_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';

import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/model/machine_model.dart';
import 'package:pika_maintenance/data/model/machine_position.dart';
import 'package:pika_maintenance/data/model/machine_status_model.dart';
import 'package:pika_maintenance/data/repository/fetch_data_status.dart';
import 'package:pika_maintenance/data/repository/get_cell_sumarry_respository.dart';

import 'package:pika_maintenance/data/repository/get_cells_repository.dart';
import 'package:pika_maintenance/data/repository/get_line_has_machine_repository.dart';
import 'package:pika_maintenance/data/repository/get_machines_categolary_repository.dart';
import 'package:pika_maintenance/data/repository/get_mahines_repository.dart';
import 'package:pika_maintenance/data/repository/send_request_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/streams/check_cell.dart';

import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/loading_dialog.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class SendRequestPage extends StatefulWidget {
  int machineId;
  SendRequestPage({this.machineId});
  _SendRequestPageState createState() => _SendRequestPageState();
}

class _SendRequestPageState extends State<SendRequestPage> with AfterLayoutMixin<SendRequestPage> {
  List<CellSummaryModel> lst_cell = [];
  TextEditingController requestComment;
  TextEditingController machinePosition;
  TextEditingController newmachinePosition;
  TextEditingController newmachinecell;
  List<CellSummaryModel> lstCellTemp;
  List<LineModel> lstLineHasMachine;
  MachineStatusModel _currentMachineStatus;
  List<MachineStatusModel> lstMachineStatusTemp;
  List<MachinePositionModel> lstMachinePositionTemp;
  List<MachineCategolaryModel> lstMachineCateloTemp;
  List<MachineModel> lstMachineTemp;
  int current_line;
  int current_cell;
  List<MachineCategolaryModel> lst_machine_cato = [];
  List<MachineModel> lst_machine = [];
  MachineCategolaryModel _currentItem_Machine_Cata;
  LineModel _currentItem_LineModel;
  MachineModel _currentItem_Machine;
  String machine_categolary = "";
  MachinePositionModel _currentItem_MachinePosition;
  List<DropdownMenuItem<MachinePositionModel>> _dropDownMenuItems_MachinePosition;
  String machine_position = "";
//  ScrollController _scrollController_list_line;
//  ScrollController _scrollController_list_cell;
  List<DropdownMenuItem<MachineCategolaryModel>> _dropDownMenuItems_Machine_Cato;
  List<DropdownMenuItem<LineModel>> _dropDownMenuItems_LineModel;
  List<DropdownMenuItem<MachineModel>> _dropDownMenuItems_Machine;
  List<DropdownMenuItem<MachineStatusModel>> _dropDownMenuItems_MachineStatus;
  String scanCode = "";
  TextEditingController cellPosition;
  String urlMachineAvatar =
      "https://library.kissclipart.com/20180830/kpq/kissclipart-machine-factory-icon-png-clipart-machine-factory-a-f479a7fc22bff4e5.jpg";
  CellSummaryModel currentCell;
  CellSummaryModel newcurrentCell;
  List<CellSummaryModel> suggestions = [];
  CheckCellStream checkcellStream;
  @override
  Future afterFirstLayout(BuildContext context) async {
    await initData().then((_) {
      if (widget.machineId != null) {
        if (lst_machine != null || lst_machine.length > 0) {
          bool hasMachine =
              lst_machine.contains(lst_machine.firstWhere((t) => t.machineId == widget.machineId, orElse: () => null));
          if (hasMachine == false) {
            Toast.show(allTranslations.text("machine_not_exit"), context,
                gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
          } else {
            MachineModel temp = lst_machine.firstWhere((t) => t.machineId == widget.machineId, orElse: () => null);

            if (temp != null) {
//                        int indexLine = Configs.lstLine.indexOf(Configs.lstLine
//                            .firstWhere((t) => t.lineId == temp.line_id,
//                                orElse: () => null));
//                        int indexCell = lstCellTemp.indexOf(
//                            lstCellTemp.firstWhere((t) => t.id == temp.cell_id,
//                                orElse: () => null));
//                        if (indexLine != null) {
//                          _goToElementLine(indexLine);
////                          handelTapLine(indexLine);
//                        }
//                        if (indexCell != null) {
//                          _goToElementCell(indexCell);
//                          handleTapCell(indexCell);
//                        }

              _currentItem_LineModel = _dropDownMenuItems_LineModel[
                      lstLineHasMachine.indexOf(lstLineHasMachine.firstWhere((t) => t.lineId == temp.line_id))]
                  .value;
              cellPosition.text = temp.positition ?? "";
              _currentItem_Machine_Cata = _dropDownMenuItems_Machine_Cato[
                      lstMachineCateloTemp.indexOf(lstMachineCateloTemp.firstWhere((t) => t.id == temp.mCateId))]
                  .value;
              _currentItem_Machine = _dropDownMenuItems_Machine[
                      lstMachineTemp.indexOf(lstMachineTemp.firstWhere((t) => t.machineId == temp.machineId))]
                  .value;
              lstMachineStatusTemp = listStatusMachine;
              _currentMachineStatus = _dropDownMenuItems_MachineStatus[
                      lstMachineStatusTemp.indexOf(lstMachineStatusTemp.firstWhere((t) => t.id == temp.statusCode))]
                  .value;
            } else {
              Toast.show(allTranslations.text("error"), context, gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
            }
          }
        } else {
          Toast.show(allTranslations.text("machine_not_exit"), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

  List<DropdownMenuItem<MachineCategolaryModel>> getDropDownMenuItems_Machine_Cate() {
    List<DropdownMenuItem<MachineCategolaryModel>> items = new List();

    for (MachineCategolaryModel line in lstMachineCateloTemp) {
      items.add(new DropdownMenuItem(
          value: line,
          child: new Text(
            (lstMachineCateloTemp.indexOf(line) + 1).toString() + ". " + line.code,
            style: StylesText.style13Black,
          )));
    }
    return items;
  }

  List<DropdownMenuItem<MachinePositionModel>> getDropDownMenuItems_Machine_Position() {
    List<DropdownMenuItem<MachinePositionModel>> items = new List();

    for (MachinePositionModel line in lstMachinePositionTemp) {
      items.add(new DropdownMenuItem(
          value: line,
          child: new Text(
            (lstMachinePositionTemp.indexOf(line) + 1).toString() + ". " + line.posititon,
            style: StylesText.style13Black,
          )));
    }
    return items;
  }

  List<DropdownMenuItem<MachineModel>> getDropDownMenuItems_Machine() {
    List<DropdownMenuItem<MachineModel>> items = new List();

    for (MachineModel machine in lstMachineTemp) {
      items.add(new DropdownMenuItem(
          value: machine,
          child: new Text(
            (lstMachineTemp.indexOf(machine) + 1).toString() + ". " + machine.code,
            style: StylesText.style13Black,
          )));
    }
    return items;
  }

  List<DropdownMenuItem<LineModel>> getDropDownMenuItems_LineModel() {
    List<DropdownMenuItem<LineModel>> items = new List();

    for (LineModel line in lstLineHasMachine) {
      items.add(new DropdownMenuItem(
          value: line,
          child: new Text(
            (lstLineHasMachine.indexOf(line) + 1).toString() + ". " + line.code,
            style: StylesText.style13Black,
          )));
    }
    return items;
  }

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

  void changedDropDownItem_Machine_Cato(MachineCategolaryModel selectedmachinecato) {
    setState(() {
      _currentItem_Machine_Cata = selectedmachinecato;
      _currentMachineStatus = null;
      _currentItem_MachinePosition = null;
      _currentItem_Machine = null;
      urlMachineAvatar =
          lstMachineCateloTemp.firstWhere((t) => t.id == selectedmachinecato.id, orElse: () => null)?.img_Url ?? "";
    });
  }

  void changedDropDownItem_LineModel(LineModel selectedLineModel) {
    if (!mounted) return;
    setState(() {
      _currentItem_LineModel = selectedLineModel;
      _currentItem_Machine = null;
      _currentItem_Machine_Cata = null;
      //reset vị trí cell
      cellPosition.clear();
      // reset current cell
      currentCell = null;
      lstCellTemp = lst_cell.where((t) => t.lineId == _currentItem_LineModel.lineId).toList();
      suggestions = lstCellTemp;
    });
  }

  void changedDropDownItem_Machine_Position(MachinePositionModel selectedmachinecato) {
    setState(() {
      _currentItem_MachinePosition = selectedmachinecato;
    });
  }

  void changedDropDownItem_Machine(MachineModel selectedmachine) {
    if (!mounted) return;
    setState(() {
      _currentItem_Machine = selectedmachine;
      _currentMachineStatus = null;
      _currentItem_MachinePosition = null;
      _currentItem_Machine_Cata = _dropDownMenuItems_Machine_Cato[lstMachineCateloTemp.indexOf(lstMachineCateloTemp
              .firstWhere((t) => t.id == selectedmachine.mCateId, orElse: () => lstMachineCateloTemp[0]))]
          .value;
      _dropDownMenuItems_MachineStatus = getDropDownMenuItem_MachineStatus();
      _currentMachineStatus = _dropDownMenuItems_MachineStatus[listStatusMachine.indexOf(listStatusMachine
              .firstWhere((t) => t.id == selectedmachine.statusCode, orElse: () => listStatusMachine[0]))]
          .value;
      machinePosition.text = selectedmachine?.positition ?? "";
      // int indexMaPo = lstMachinePositionTemp.indexOf(lstMachinePositionTemp
      //     .firstWhere((t) => t.posititon.contains(selectedmachine.positition),
      //         orElse: () => null));
      // if (indexMaPo != null) {
      //   _currentItem_MachinePosition =
      //       _dropDownMenuItems_MachinePosition[indexMaPo].value;
      // }
    });
  }

  @override
  void dispose() {
    checkcellStream.dispose();
    super.dispose();
  }

  @override
  void initState() {
    requestComment = new TextEditingController();
    machinePosition = new TextEditingController();
    newmachinePosition = new TextEditingController();
    newmachinecell = new TextEditingController();
    cellPosition = new TextEditingController();
    checkcellStream = new CheckCellStream();
//    _scrollController_list_line = new ScrollController();
//    _scrollController_list_cell = new ScrollController();
    super.initState();
  }

  Future initData() async {
    await Future.wait([
      GetLinesHasMachineRepository().then((va) {
        if (va == null || va.length == 0) {
          if (this.mounted) {
            setState(() {
              lstLineHasMachine = [];
            });
          }
        } else {
          if (this.mounted) {
            setState(() {
              lstLineHasMachine = va;
              _dropDownMenuItems_LineModel = getDropDownMenuItems_LineModel();
            });
          }
        }
      }),
      GetCellSumarryRepository(wt: 0, lineId: 0, cateId: 0).then((va) {
        if (va != null) {
          lst_cell = va.where((t) => t.totalMachine > 0).toList();
          if (this.mounted) {
            setState(() {
              lstCellTemp = lst_cell;
              suggestions = lstCellTemp;
            });
          }
        } else {
          if (this.mounted) {
            setState(() {
              lst_cell = [];
              suggestions = [];
              lstCellTemp = [];
            });
          }
        }
      }),
      GetMachinesCategolaryRepository().then((va) {
        if (va != null) {
          if (this.mounted) {
            setState(() {
              lst_machine_cato = va;
              lstMachineCateloTemp = lst_machine_cato;
              _dropDownMenuItems_Machine_Cato = getDropDownMenuItems_Machine_Cate();
            });
          }
        }
      }),
      GetMachinesRepository().then((va) {
        if (va != null) {
          if (this.mounted) {
            setState(() {
              lst_machine = va;
              lstMachineTemp = lst_machine;
              _dropDownMenuItems_Machine = getDropDownMenuItems_Machine();
            });
          }
        }
      }),
    ]);
    _dropDownMenuItems_MachineStatus = getDropDownMenuItem_MachineStatus();
  }

//  void _goToElementLine(int index) {
//    _scrollController_list_line.animateTo((Dimension.getWidth(0.2) * index),
//        duration: const Duration(seconds: 1), curve: Curves.easeOut);
//  }
//
//  void _goToElementCell(int index) {
//    _scrollController_list_cell.animateTo((Dimension.getWidth(0.2) * index),
//        duration: const Duration(seconds: 1), curve: Curves.easeOut);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            try {
              Navigator.of(context).pop();
            } catch (e) {
              print(e.toString());
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(allTranslations.text("input_request"), style: StylesText.style18WhiteNomorl),
      ),
      body: Container(
        height: Dimension.getHeight(1.0),
        width: Dimension.getWidth(1.0),
        color: Theme.of(context).backgroundColor,
        child: lstLineHasMachine == null || lstCellTemp == null
            ? Center(
                child: SpinKitCircle(color: Colors.orange),
              )
            : lstLineHasMachine.length == 0
                ? Center(
                    child: Text(
                      allTranslations.text("no_line_has_machine"),
                      style: StylesText.style13Black,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    allTranslations.text("choose_line"),
                                    style: StylesText.style15BlueBold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: Dimension.getHeight(0.07),

                                    child: ButtonTheme(
                                      alignedDropdown: false,
                                      child: DropdownButton(
                                          elevation: 20,
//                                          underline: Container(),
                                          style: StylesText.style13Black,
                                          isExpanded: true,
                                          hint:
                                              Text(allTranslations.text("choose_line"), style: StylesText.style13Black),
                                          value: _currentItem_LineModel,
                                          items: _dropDownMenuItems_LineModel,
                                          onChanged: changedDropDownItem_LineModel),
                                    ),

                                    //                            ListView.builder(
                                    //                              controller: _scrollController_list_line,
                                    //                              physics: const AlwaysScrollableScrollPhysics(),
                                    //                              scrollDirection: Axis.horizontal,
                                    //                              itemCount: Configs.lstLine.length ?? 0,
                                    //                              itemBuilder: (context, index) {
                                    //                                return GestureDetector(
                                    //                                    onTap: () => handelTapLine(index),
                                    //                                    child: Card(
                                    //                                      margin: const EdgeInsets.only(right: 5.0),
                                    //                                      child: Container(
                                    //                                          padding: const EdgeInsets.all(1.0),
                                    //                                          width: Dimension.getWidth(0.2),
                                    //                                          decoration: BoxDecoration(
                                    //                                              border: Border.all(
                                    //                                                  color: current_line == index
                                    //                                                      ? Colors.orange
                                    //                                                      : Colors.grey[300],
                                    //                                                  width: 2.0)),
                                    //                                          child: Center(
                                    //                                            child: Text(
                                    //                                                Configs.lstLine[index].code,
                                    //                                                style: StylesText.style13Black),
                                    //                                          )),
                                    //                                    ));
                                    //                              },
                                    //                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                lstCellTemp == null || lstCellTemp.length == 0
                                    ? Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Text(
                                                allTranslations.text("no_cell_info"),
                                                textAlign: TextAlign.center,
                                                style: StylesText.style13Black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Visibility(
                                          visible: current_line == null ? true : true,
                                          child: Text(allTranslations.text("cell_position"),
                                              style: StylesText.style15BlueBold),
                                        )),
                                lstCellTemp == null || lstCellTemp.length == 0
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          height: Dimension.getHeight(0.07),
                                          child: StreamBuilder<Object>(
                                              stream: checkcellStream.checkCellStream,
                                              builder: (context, snapshot) {
                                                return AutoCompleteTextField<CellSummaryModel>(
                                                  itemSubmitted: (item) {
                                                    setState(() {
                                                      currentCell = item;
                                                      cellPosition.text = currentCell.code;
                                                    });
                                                    handleTapCell(lstCellTemp.indexOf(item));
                                                  },
                                                  keyboardType: TextInputType.text,
                                                  clearOnSubmit: false,
                                                  textSubmitted: (va) {
                                                    try {
                                                      CellSummaryModel temp = suggestions[0];
                                                      if (temp != null) {
                                                        setState(() {
                                                          currentCell = temp;
                                                          cellPosition.text = currentCell.code;
                                                        });
                                                      } else {
                                                        cellPosition.text = "";
                                                      }
                                                    } catch (e) {
                                                      print(e.toString());
                                                      cellPosition.text = "";
                                                    }
                                                  },
                                                  style: StylesText.style13Black,
                                                  decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.fromLTRB(0.0, 15, 15, 7),
                                                      hintText: "Nhập vị trí cell",
                                                      hintStyle: StylesText.style13Black,
                                                      errorText: snapshot.hasError ? snapshot.error : null,
                                                      errorStyle: StylesText.style10Red),
                                                  controller: cellPosition,
                                                  suggestionsAmount: 5,
                                                  suggestions: suggestions,
                                                  textInputAction: TextInputAction.done,
                                                  itemBuilder: (context, suggestion) => new SingleChildScrollView(
                                                      child: new ListTile(
                                                          title: new Text(
                                                            suggestion.code,
                                                            style: StylesText.style13Black,
                                                          ),
                                                          subtitle: Text(
                                                            allTranslations.text("sum_machine") +
                                                                    ": " +
                                                                    suggestion?.totalMachine?.toString() ??
                                                                "",
                                                            style: StylesText.style12Gray,
                                                          ),
                                                          trailing: new Text(
                                                            suggestion.totalMachineBroken == 0
                                                                ? ""
                                                                : "Máy hỏng: ${suggestion.totalMachineBroken}",
                                                            style: StylesText.style10Red,
                                                          )),
                                                      padding: EdgeInsets.all(2.0)),
                                                  itemSorter: (a, b) => a.totalMachine.compareTo(b.totalMachine),
                                                  itemFilter: (suggestion, input) =>
                                                      suggestion.code.toLowerCase().contains(input.toLowerCase()),
                                                );
                                              }),
                                        )
                                        //                                SafeArea(
                                        //                                  child: ListView.builder(
                                        //                                    controller: _scrollController_list_cell,
                                        //                                    physics:
                                        //                                        const AlwaysScrollableScrollPhysics(),
                                        //                                    scrollDirection: Axis.horizontal,
                                        //                                    itemCount: lstCellTemp.length,
                                        //                                    itemBuilder: (context, index) {
                                        //                                      return GestureDetector(
                                        //                                          onTap: () => handleTapCell(index),
                                        //                                          child: Card(
                                        //                                            margin: const EdgeInsets.only(
                                        //                                                right: 5.0),
                                        //                                            child: Container(
                                        //                                                decoration: new BoxDecoration(
                                        //                                                    border: new Border.all(
                                        //                                                        color: current_cell ==
                                        //                                                                index
                                        //                                                            ? Colors.orange
                                        //                                                            : Colors.grey[300],
                                        //                                                        width: 2.0)),
                                        //                                                padding:
                                        //                                                    const EdgeInsets.all(1.0),
                                        //                                                width: Dimension.getWidth(0.2),
                                        //                                                child: Center(
                                        //                                                  child: Text(
                                        //                                                      lstCellTemp[index].code,
                                        //                                                      style: StylesText
                                        //                                                          .style13Black),
                                        //                                                )),
                                        //                                          ));
                                        //                                    },
                                        //                                  ),
                                        //                                ),

                                        ),
                              ],
                            ),
                          )
                        ],
                      ),
                      lstCellTemp == null || lstCellTemp.length == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                              child: Visibility(
                                visible: current_cell == null ? true : true,
                                child: Text(
                                  allTranslations.text("machine_info"),
                                  style: StylesText.style15BlueBold,
                                ),
                              )),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                allTranslations.text("machine_category") + machine_categolary ?? "",
                                style: StylesText.style14Blue,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  elevation: 20,
                                  style: StylesText.style13Black,
                                  isExpanded: true,
                                  hint: Text(allTranslations.text("choose_category"), style: StylesText.style13Black),
                                  value: _currentItem_Machine_Cata,
                                  items: _dropDownMenuItems_Machine_Cato,
                                  onChanged: changedDropDownItem_Machine_Cato,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                allTranslations.text("machine_name") + machine_categolary ?? "",
                                style: StylesText.style14Blue,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton(
                                      elevation: 20,
                                      style: StylesText.style10Black,
                                      isExpanded: true,
                                      hint: Text(allTranslations.text("choose_machine_name"),
                                          style: StylesText.style13Black),
                                      value: _currentItem_Machine,
                                      items: _dropDownMenuItems_Machine,
                                      onChanged: changedDropDownItem_Machine,
                                    ))),
                          ),
                        ],
                      ),
                      lstCellTemp == null || lstCellTemp.length == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(5, 6, 5, 5),
                              child: Visibility(
                                visible: current_cell == null ? true : true,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: CachedNetworkImage(
                                              fadeOutDuration: Duration(milliseconds: 700),
                                              imageUrl: Unity.Replace_String(urlMachineAvatar),
                                              imageBuilder: (context, imageProvider) => Container(
                                                height: Dimension.getWidth(0.25),
                                                width: Dimension.getWidth(0.25),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                      alignment: Alignment.center),
                                                ),
                                              ),
                                              fadeInDuration: Duration(milliseconds: 700),
                                              placeholder: (context, url) => new SizedBox(
                                                child: Center(
                                                    child: SpinKitCircle(
                                                  color: Colors.orange,
                                                  size: 25,
                                                )),
                                              ),
                                              errorWidget: (context, url, error) => Icon(
                                                Icons.image,
                                                size: 50,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                            child: Text(allTranslations.text("machine_status"),
                                                style: StylesText.style14Blue),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Padding(
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
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                            child: Text(
                                                allTranslations.text("machine_position") + machine_position ?? "",
                                                style: StylesText.style14Blue),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              child: TextField(
                                                controller: machinePosition,
                                                style: StylesText.style13Black,
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                                                  hintStyle: StylesText.style13Black,
                                                  hintText: allTranslations.text("machine_position_hint"),
                                                ),
                                              )
                                              // ButtonTheme(
                                              //   alignedDropdown: true,
                                              //   child: ButtonTheme(
                                              //     alignedDropdown: true,
                                              //     child: DropdownButton(
                                              //       elevation: 20,
                                              //       style: StylesText
                                              //           .style10Black,
                                              //       isExpanded: true,
                                              //       hint: Text(
                                              //           allTranslations.text(
                                              //               "choose_machine_position"),
                                              //           style: StylesText
                                              //               .style10Black),
                                              //       value:
                                              //           _currentItem_MachinePosition,
                                              //       items:
                                              //           _dropDownMenuItems_MachinePosition,
                                              //       onChanged:
                                              //           changedDropDownItem_Machine_Position,
                                              //     ),
                                              //   ),
                                              // ),
                                              ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                            child: Text(allTranslations.text("new_position"),
                                                style: StylesText.style14Blue),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              child: TextField(
                                                controller: newmachinePosition,
                                                style: StylesText.style13Black,
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                                                  hintStyle: StylesText.style13Black,
                                                  hintText: allTranslations.text("new_position"),
                                                ),
                                              )
                                              // ButtonTheme(
                                              //   alignedDropdown: true,
                                              //   child: ButtonTheme(
                                              //     alignedDropdown: true,
                                              //     child: DropdownButton(
                                              //       elevation: 20,
                                              //       style: StylesText
                                              //           .style10Black,
                                              //       isExpanded: true,
                                              //       hint: Text(
                                              //           allTranslations.text(
                                              //               "choose_machine_position"),
                                              //           style: StylesText
                                              //               .style10Black),
                                              //       value:
                                              //           _currentItem_MachinePosition,
                                              //       items:
                                              //           _dropDownMenuItems_MachinePosition,
                                              //       onChanged:
                                              //           changedDropDownItem_Machine_Position,
                                              //     ),
                                              //   ),
                                              // ),
                                              ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                            child:
                                                Text(allTranslations.text("new_cell"), style: StylesText.style14Blue),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              child: AutoCompleteTextField<CellSummaryModel>(
                                                itemSubmitted: (item) {
                                                  setState(() {
                                                    newcurrentCell = item;
                                                    newmachinecell.text = item.code;
                                                  });
                                                },
                                                keyboardType: TextInputType.text,
                                                clearOnSubmit: false,
                                                textSubmitted: (va) {
                                                  try {
                                                    CellSummaryModel temp = suggestions[0];

                                                    if (temp != null) {
                                                      setState(() {
                                                        newcurrentCell = temp;
                                                        newmachinecell.text = temp.code;
                                                      });
                                                    } else {
                                                      newmachinecell.text = "";
                                                    }
                                                  } catch (e) {
                                                    print(e.toString());
                                                    newmachinecell.text = "";
                                                  }
                                                },
                                                style: StylesText.style13Black,
                                                decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                                                    hintText: allTranslations.text("new_cell"),
                                                    hintStyle: StylesText.style13Black,
                                                    errorStyle: StylesText.style10Red),
                                                controller: newmachinecell,
                                                suggestionsAmount: 5,
                                                suggestions: suggestions,
                                                textInputAction: TextInputAction.done,
                                                itemBuilder: (context, suggestion) => new SingleChildScrollView(
                                                    child: new ListTile(
                                                        title: new Text(
                                                          suggestion.code,
                                                          style: StylesText.style13Black,
                                                        ),
                                                        subtitle: Text(
                                                          allTranslations.text("sum_machine") +
                                                              ": " +
                                                              suggestion.totalMachine.toString(),
                                                          style: StylesText.style12Gray,
                                                        ),
                                                        trailing: new Text(
                                                          suggestion.totalMachineBroken == 0
                                                              ? ""
                                                              : "Máy hỏng: ${suggestion.totalMachineBroken}",
                                                          style: StylesText.style10Red,
                                                        )),
                                                    padding: EdgeInsets.all(2.0)),
                                                itemSorter: (a, b) => a.totalMachine.compareTo(b.totalMachine),
                                                itemFilter: (suggestion, input) =>
                                                    suggestion.code.toLowerCase().contains(input.toLowerCase()),
                                              )
                                              // ButtonTheme(
                                              //   alignedDropdown: true,
                                              //   child: ButtonTheme(
                                              //     alignedDropdown: true,
                                              //     child: DropdownButton(
                                              //       elevation: 20,
                                              //       style: StylesText
                                              //           .style10Black,
                                              //       isExpanded: true,
                                              //       hint: Text(
                                              //           allTranslations.text(
                                              //               "choose_machine_position"),
                                              //           style: StylesText
                                              //               .style10Black),
                                              //       value:
                                              //           _currentItem_MachinePosition,
                                              //       items:
                                              //           _dropDownMenuItems_MachinePosition,
                                              //       onChanged:
                                              //           changedDropDownItem_Machine_Position,
                                              //     ),
                                              //   ),
                                              // ),
                                              ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                      lstCellTemp == null || lstCellTemp.length == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                              child: Visibility(
                                visible: current_cell == null ? true : true,
                                child: TextFormField(
                                  controller: requestComment,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  textDirection: TextDirection.ltr,
                                  style: StylesText.style13Black,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  maxLength: 1000,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255, 11, 68, 125), width: 2.0),
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    // labelText: allTranslations.text("note"),
                                    labelStyle: StylesText.style14Black,
                                    alignLabelWithHint: true,
                                    hintText: allTranslations.text("enter_note"),
                                    hintStyle: StylesText.style14Bluegray,
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                ),
                              )),
                      _currentItem_LineModel == null || cellPosition.text == ""
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                              child: Visibility(
                                visible: current_cell == null ? true : true,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        key: Key("emergency"),
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                        onPressed: () async {
                                          await onSendRequestEmergency();
                                        },
                                        child: Text(
                                          allTranslations.text("emergency"),
                                          style: StylesText.style13Black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        key: Key("normal"),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                        color: Colors.blue,
                                        onPressed: () async {
                                          await onSendRequestNormal();
                                        },
                                        child: Text(allTranslations.text("normal"), style: StylesText.style13Black),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                    ],
                  )),
      ),
    );
  }
//
//  void handelTapLine(int index) {
//    _currentItem_Machine = null;
//    _currentItem_Machine_Cata = null;
//    List<CellSummaryModel> tem = lst_cell
//        .where((t) => t.lineId == lstLineHasMachine[index].lineId)
//        .toList();
//    setState(() {
//      current_line = index;
//      current_cell = null;
//      lstCellTemp = tem;
//    });
//  }

  void handleTapCell(int index) {
    try {
      LoadingDialog.showLoadingDialog(context);
      _currentItem_Machine = null;
      _currentItem_Machine_Cata = null;
      _currentMachineStatus = null;
      _currentItem_MachinePosition = null;
      List<MachineCategolaryModel> tem_machine_cato = new List();
      List<MachinePositionModel> tem_lst_position = new List();
      List<MachineModel> tem = lst_machine.where((t) => t.cell_id == lstCellTemp[index].cellId).toList();

      if (tem.isEmpty) {
        if (this.mounted) {
          setState(() {
            lstMachineCateloTemp = [];
            lstMachineStatusTemp = [];
            lstMachineTemp = [];
            lstMachinePositionTemp = [];
            _dropDownMenuItems_MachinePosition = getDropDownMenuItems_Machine_Position();
            _dropDownMenuItems_Machine = getDropDownMenuItems_Machine();
            _dropDownMenuItems_Machine_Cato = getDropDownMenuItems_Machine_Cate();
            _dropDownMenuItems_MachineStatus = [];
          });
        }
        LoadingDialog.hideLoadingDialog(context);
      } else {
        for (var item in tem) {
          tem_lst_position.add(new MachinePositionModel(DateTime.now().millisecondsSinceEpoch, item.positition));
          for (var machine_cato in lst_machine_cato) {
            if (item.mCateId == machine_cato.id) {
              tem_machine_cato.add(machine_cato);
            }
          }
        }
        if (this.mounted) {
          setState(() {
            lstMachineTemp = tem;
            lstMachineCateloTemp = tem_machine_cato;
            lstMachinePositionTemp = tem_lst_position;
            _dropDownMenuItems_MachinePosition = getDropDownMenuItems_Machine_Position();
            _dropDownMenuItems_Machine = getDropDownMenuItems_Machine();
            _dropDownMenuItems_Machine_Cato = getDropDownMenuItems_Machine_Cate();
            _dropDownMenuItems_MachineStatus = getDropDownMenuItem_MachineStatus();
          });
        }
        LoadingDialog.hideLoadingDialog(context);
      }
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      FlutterCrashlytics().log(e.toString(),
          priority: 200,
          tag: 'Error in handeltapcell in send '
              'request page');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  Future onSendRequestEmergency() async {
    try {
      LoadingDialog.showLoadingDialog(context);
      if (await Validations.isConnectedNetwork() == true) {
        if (await SendRequestRepository(
                _currentItem_Machine.machineId,
                _currentItem_Machine.cell_id,
                machinePosition.text.trim(),
                int.tryParse(_currentMachineStatus.id),
                requestComment.text.trim(),
                1,
                newmachinePosition.text.trim(),
                newcurrentCell?.cellId ?? -1) ==
            1) {
          LoadingDialog.hideLoadingDialog(context);
          return Toast.show(allTranslations.text("send_request_success"), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
        {
          LoadingDialog.hideLoadingDialog(context);
          return Toast.show(allTranslations.text("error"), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      } else {
        LoadingDialog.hideLoadingDialog(context);
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
      }
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in sendrequestemergentcy');
      FlutterCrashlytics().logException(e, e.stackTrace);
      return Toast.show(allTranslations.text("error"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future onSendRequestNormal() async {
    try {
      LoadingDialog.showLoadingDialog(context);
      if (await Validations.isConnectedNetwork() == true) {
        if (await SendRequestRepository(
                _currentItem_Machine.machineId,
                _currentItem_Machine.cell_id,
                machinePosition.text.trim(),
                int.tryParse(_currentMachineStatus.id),
                requestComment.text.trim(),
                0,
                newmachinePosition.text.trim(),
                newcurrentCell?.cellId ?? -1) ==
            1) {
          LoadingDialog.hideLoadingDialog(context);
          return Toast.show(allTranslations.text("send_request_success"), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
        {
          LoadingDialog.hideLoadingDialog(context);
          return Toast.show(allTranslations.text("error"), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      } else {
        LoadingDialog.hideLoadingDialog(context);
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
      }
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in sendrequestnormal');
      FlutterCrashlytics().logException(e, e.stackTrace);
      return Toast.show(allTranslations.text("error"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
