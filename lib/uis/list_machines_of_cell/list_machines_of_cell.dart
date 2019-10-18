import 'package:after_layout/after_layout.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/cell_summary_model.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/model/machine_in_cell_model.dart';

import 'package:pika_maintenance/data/repository/create_machine_repository.dart';
import 'package:pika_maintenance/data/repository/get_machines_in_cell.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/create_machine_in_scan.dart';
import 'package:pika_maintenance/screens/home_screen/machine_information/machine_page.dart';
import 'package:pika_maintenance/streams/create_machine_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/uis/time_text/time_text.dart';
import 'package:pika_maintenance/uis/triangke_clipper/triangle_clipper.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class ListMachinesOfCell extends StatefulWidget {
  CellSummaryModel cell;
  MachineCategolaryModel machineCategolaryModel;
  ListMachinesOfCell(this.cell, this.machineCategolaryModel);
  @override
  _ListMachinesOfCellState createState() => _ListMachinesOfCellState();
}

class _ListMachinesOfCellState extends State<ListMachinesOfCell> with AfterLayoutMixin<ListMachinesOfCell> {
  bool isHasText;
  String codeScan = "";
  TextEditingController machine_catalog;
  TextEditingController machine_posittion;
  TextEditingController machine_code;
  CreateMachineStream add_new_machine_stream;
  List<MachineInCellModel> lst_machineInCell;

  @override
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    Future.wait([initData()]);
  }

  Future initData() async {
    try {
      if (await Validations.isConnectedNetwork()) {
        await GetMachinesInCellRepository(cellId: widget.cell.cellId, wt: 0).then((va) {
          if (va != null) {
            if (this.mounted) {
              setState(() {
                lst_machineInCell = va;
              });
            }
          } else {
            setState(() {
              lst_machineInCell = [];
            });
          }
        });
      } else {
        setState(() {
          lst_machineInCell = [];
        });
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
      }
    } catch (e) {
      setState(() {
        lst_machineInCell = [];
      });
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData in list '
          'machine of cell');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  getColor(int code) {
    switch (code) {
      case 0:
        return Colors.grey;
        break;
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.black;
        break;
      case 3:
        return Colors.red;
        break;
      case 4:
        return Colors.blue;
        break;
      case 5:
        return Colors.purple;
        break;
      default:
        return Colors.orange;
    }
  }

  Future scan() async {
    String _reader = "";
    try {
      _reader = await BarcodeScanner.scan();
      if (!mounted) return null;
      setState(() {
        codeScan = _reader;
      });
      return codeScan;
    } on PlatformException catch (e, stacktrace) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error');
      FlutterCrashlytics().logException(e, stacktrace);
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Toast.show(allTranslations.text("camera_access_deny"), context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
        return null;
      } else {
        return null;
      }
    } on FormatException {
      return null;
    } catch (e) {
      {
        FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error scann in list machine of '
            'cell');
        FlutterCrashlytics().logException(e, e.stackTrace);
        return null;
      }
    }
  }

  @override
  void initState() {
    machine_catalog = new TextEditingController();
    machine_posittion = new TextEditingController();
    machine_code = new TextEditingController();
    add_new_machine_stream = new CreateMachineStream();
    super.initState();
  }

  @override
  void dispose() {
    machine_catalog.dispose();
    machine_posittion.dispose();
    machine_code.dispose();
    add_new_machine_stream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(widget.cell.code.isEmpty ? "Danh sách máy" : "Danh sách máy " + widget.cell.code,
              style: StylesText.style16While)),
      floatingActionButton: FloatingActionButton(
        tooltip: "Thêm máy",
        onPressed: () {
          try {
            scan().then((valua) async {
              if (valua != null) {
                await Navigator.of(context)
                    .push(
                  CupertinoPageRoute(
                    builder: (context) => CreateMachineInScan(
                      machineCode: codeScan ?? "",
                      lineModelId: widget.cell.lineId,
                      cellModelId: widget.cell.cellId,
                      machineCategolaryModelId: widget.machineCategolaryModel.id,
                    ),
                  ),
                )
                    .then((_) async {
                  await onRefresh();
                });

                // Alert(
                //   context: context,
                //   title: "Thêm máy",
                //   content: SizedBox(
                //     child: Center(
                //         child: SingleChildScrollView(
                //             scrollDirection: Axis.vertical,
                //             child: Column(
                //               children: <Widget>[
                //                 Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: StreamBuilder<Object>(
                //                       stream: null,
                //                       builder: (context, snapshot) {
                //                         return TextFormField(
                //                           controller: machine_catalog,
                //                           textInputAction: TextInputAction.done,
                //                           decoration: new InputDecoration(
                //                             errorText: snapshot.hasError
                //                                 ? snapshot.error
                //                                 : null,
                //                             errorStyle: StylesText.style10Red,
                //                             labelText: "Loại máy",
                //                             hintText: "Nhập loại máy",
                //                             hintStyle:
                //                                 StylesText.style12black12,
                //                             labelStyle:
                //                                 StylesText.styele00128100,
                //                             border: new OutlineInputBorder(
                //                               borderRadius:
                //                                   new BorderRadius.all(
                //                                       Radius.circular(10.0)),
                //                               borderSide: new BorderSide(
                //                                 color: Colors.orange,
                //                               ),
                //                             ),
                //                           ),
                //                         );
                //                       }),
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: StreamBuilder<Object>(
                //                       stream: null,
                //                       builder: (context, snapshot) {
                //                         return TextFormField(
                //                           controller: machine_posittion,
                //                           textInputAction: TextInputAction.done,
                //                           decoration: new InputDecoration(
                //                             errorText: snapshot.hasError
                //                                 ? snapshot.error
                //                                 : null,
                //                             errorStyle: StylesText.style10Red,
                //                             labelText: allTranslations
                //                                 .text("machine_position"),
                //                             hintText: "Nhập vị trí máy",
                //                             hintStyle:
                //                                 StylesText.style12black12,
                //                             labelStyle:
                //                                 StylesText.styele00128100,
                //                             border: new OutlineInputBorder(
                //                               borderRadius:
                //                                   new BorderRadius.all(
                //                                       Radius.circular(10.0)),
                //                               borderSide: new BorderSide(
                //                                 color: Colors.orange,
                //                               ),
                //                             ),
                //                           ),
                //                         );
                //                       }),
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: StreamBuilder<Object>(
                //                       stream: null,
                //                       builder: (context, snapshot) {
                //                         return TextFormField(
                //                           controller: machine_code,
                //                           textInputAction: TextInputAction.done,
                //                           decoration: new InputDecoration(
                //                             errorText: snapshot.hasError
                //                                 ? snapshot.error
                //                                 : null,
                //                             errorStyle: StylesText.style10Red,
                //                             labelText: "Tên máy",
                //                             hintText: "Nhập tên máy",
                //                             hintStyle:
                //                                 StylesText.style12black12,
                //                             labelStyle:
                //                                 StylesText.styele00128100,
                //                             border: new OutlineInputBorder(
                //                               borderRadius:
                //                                   new BorderRadius.all(
                //                                       Radius.circular(10.0)),
                //                               borderSide: new BorderSide(
                //                                 color: Colors.orange,
                //                               ),
                //                             ),
                //                           ),
                //                         );
                //                       }),
                //                 )
                //               ],
                //             ))),
                //   ),
                //   buttons: [
                //     DialogButton(
                //       child: Text(
                //         allTranslations.text("no"),
                //         style: StylesText.style13White,
                //       ),
                //       onPressed: () => Navigator.pop(context),
                //       color: Colors.orange,
                //     ),
                //     DialogButton(
                //       child: Text(
                //         allTranslations.text("yes"),
                //         style: StylesText.style13White,
                //       ),
                //       onPressed: () async {
                //         await onAddNewMachine();
                //       },
                //       color: Colors.orange,
                //     )
                //   ],
                // ).show();
              } else {
                return;
              }
            });
          } catch (e) {
            FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error add machine in lst machine of '
                'cell');
            FlutterCrashlytics().logException(e, e.stackTrace);
          }
        },
        child: Icon(
          Icons.add_to_queue,
          color: Colors.white,
          size: 25,
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
          color: Theme.of(context).backgroundColor,
          width: Dimension.getWidth(1.0),
          height: Dimension.getHeight(1.0),
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: lst_machineInCell == null
                ? Center(child: SpinKitCircle(color: Colors.orange))
                : lst_machineInCell.length == 0
                    ? Center(
                        child: Text(
                          "Không có thông tin máy",
                          style: StylesText.style13Black,
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(2.0),
                              itemCount: lst_machineInCell.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                            builder: (context) => PageMachine(lst_machineInCell[index])))
                                        .then((_) async {
                                      await onRefresh();
                                    });
                                  },
                                  child: Container(
                                    width: Dimension.getWidth(1.0),
                                    height: Dimension.getHeight(0.125),
                                    color: Theme.of(context).backgroundColor,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width: Dimension.getWidth(1.0),
                                          child: new Card(
                                            child: new Container(
                                              decoration: new BoxDecoration(
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                              padding: new EdgeInsets.only(
                                                top: 12.0,
                                                bottom: 12,
                                                left: 10,
                                                right: 0,
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      decoration: new BoxDecoration(
                                                          color: Colors.black12, shape: BoxShape.circle),
                                                      child: Center(
                                                          child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Text(
                                                          (index + 1).toString(),
                                                          textAlign: TextAlign.center,
                                                          style: StylesText.style13Black,
                                                        ),
                                                      ))),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              lst_machineInCell[index]?.machineCateCode ?? "",
                                                              style: StylesText.style13BlackBold,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(right: 25),
                                                              child: TimeText(timeHasPassed: "1 ngày"),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 5),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text(
                                                              lst_machineInCell[index]?.machineCode ?? "",
                                                              style: TextStyle(
                                                                // fontSize: 12,
                                                                fontWeight: FontWeight.w600,
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
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            alignment: Alignment(1, 1),
                                            child: Container(
                                              height: 30.0,
                                              width: 30.0,
                                              color: getColor(
                                                  int.tryParse(lst_machineInCell[index]?.machineStatusCode ?? "0")),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Container(
                                            alignment: Alignment(1, 1),
                                            child: ClipPath(
                                              clipBehavior: Clip.hardEdge,
                                              clipper: TriangleClipper(),
                                              child: Container(
                                                height: 30.0,
                                                width: 30.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        HorizontalTextBar(
                                            colorReport: getColor(
                                                int.tryParse(lst_machineInCell[index]?.machineStatusCode ?? "0")),
                                            statusReport: lst_machineInCell[index]),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            alignment: Alignment(-1, 1),
                                            child: Container(
                                              height: 2,
                                              width: double.infinity,
                                              color: getColor(
                                                  int.tryParse(lst_machineInCell[index]?.machineStatusCode ?? "0")),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          )),
    );
  }

  Future<void> onAddNewMachine() async {
    if (add_new_machine_stream.isValidInfo(
        machine_catalog.text.trim(), machine_posittion.text.trim(), machine_code.text.trim())) {
      if (await Validations.isConnectedNetwork() == true) {
        CreateMachineRepository(
                widget.cell.lineId, widget.cell.cellId, 7, machine_code.text.trim(), machine_posittion.text.trim())
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

  Future<void> onRefresh() async {
    await Future.delayed(Duration(microseconds: 100));
    await initData();
  }

  String getStatusMachine(MachineInCellModel machineInCellModel) {
    switch (int.tryParse(machineInCellModel.machineStatusCode)) {
      case 0:
        {
          return allTranslations.text("status_machine_no_use");
        }
      case 1:
        {
          return allTranslations.text("status_machine_running");
        }
      case 2:
        {
          return allTranslations.text("status_machine_stop");
        }
      case 3:
        {
          return allTranslations.text("status_machine_broken");
        }

      case 4:
        {
          return  allTranslations.text("status_machine_moving");
        }
      case 5:
        {
          return allTranslations.text("status_machine_new");
        }
      default:
        return "";
    }
  }

  Widget HorizontalTextBar({colorReport, MachineInCellModel statusReport}) {
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
            child: FittedBox(
              child: Text(
                getStatusMachine(statusReport),
                textAlign: TextAlign.center,
                style: StylesText.style13WhiteBold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
