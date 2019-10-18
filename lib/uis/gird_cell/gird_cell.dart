import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/cell_summary_model.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/repository/create_cell_repository.dart';
import 'package:pika_maintenance/data/repository/get_cell_sumarry_respository.dart';
import 'package:pika_maintenance/data/repository/get_machines_categolary_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/streams/create_lines_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/loading_dialog.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/uis/list_machines_of_cell/list_machines_of_cell.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class GirdCell extends StatefulWidget {
  int lineId;
  MachineCategolaryModel machineCategolaryModel;
  GirdCell({this.lineId, this.machineCategolaryModel});
  @override
  GirdCellState createState() => GirdCellState();
}

class GirdCellState extends State<GirdCell> with AfterLayoutMixin<GirdCell> {
  int currentIndex;
  bool isLoading;
  List<MachineCategolaryModel> temp_machinecato;
  CreateLineStream create_lines_stream;
  TextEditingController name_cell;

//  Future initData() async {
//    try {
//      GetMachinesCategolaryRepository().then((valua) async {
//        if (valua != null) {
//          await Configs.machineCategolaryDao.deleteAllRow();
//          if (!mounted) return;
//          setState(() {
//            Configs.lst_machine_cata = valua;
//          });
//
//          await Configs.machineCategolaryDao
//              .insertMachineCategolaryModels(valua);
//        } else {
//          temp_machinecato = await Configs.machineCategolaryDao
//              .findAllMachineCategolaryModel();
//          if (temp_machinecato == null || temp_machinecato.length == 0) {
//            if (!mounted) return;
//            setState(() {
//              Configs.lst_machine_cata = [];
//            });
//          } else {
//            if (!mounted) return;
//            setState(() {
//              Configs.lst_machine_cata = temp_machinecato;
//            });
//          }
//        }
//        MachineCategolaryModel all =
//            new MachineCategolaryModel(0, "All", "All", "", "", 0.0);
//        bool isHasAllItem = Configs.lst_machine_cata.contains(all);
//        if (isHasAllItem == false) {
//          if (!mounted) return;
//          setState(() {
//            Configs.lst_machine_cata.insert(0, all);
//          });
//        }
//      });
//    } catch (e) {
//      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error');
//      FlutterCrashlytics().logException(e, e.stackTrace);
//    }
//  }
  Future getCellSummary() async {
    try {
      if (await Validations.isConnectedNetwork() == true) {
        await GetCellSumarryRepository(lineId: widget.lineId, cateId: Configs.lstMachineCata[currentIndex].id, wt: 0)
            .then((va) {
          if (va != null) {
            if (va.length > 1) {
              va.sort((a, b) => a.cellId.compareTo(b.cellId));
            }
            if (!mounted) return;
            setState(() {
              Configs.lstMachineInCell = va;
              isLoading = false;
            });
          } else {
            if (!mounted) return;
            setState(() {
              Configs.lstMachineInCell = [];
              isLoading = false;
            });

            return;
          }
        });
      } else {
        if (!mounted) return;
        setState(() {
          Configs.lstMachineInCell = [];
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in get cell sumary gird '
          'cell page');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    currentIndex = 0;
    isLoading = false;
    create_lines_stream = new CreateLineStream();
    name_cell = new TextEditingController();
    super.initState();
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    await getCellSummary();
  }

  @override
  void dispose() {
    create_lines_stream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: Dimension.getWidth(1.0),
      height: Dimension.getHeight(1.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//            Padding(
//                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                child: Container(
//                  child: CustomPaint(
//                      painter: Drawhorizontalline(
//                          false,
//                          Dimension.getWidth(1.0),
//                          Dimension.getWidth(1.0),
//                          Colors.blueGrey[300],
//                          0.5)),
//                )),
//            Padding(
//                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                child: Row(
//                  children: <Widget>[
//                    renderListMachine()],
//                )),
//            Padding(
//                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                child: Container(
//                  child: CustomPaint(
//                      painter: Drawhorizontalline(
//                          false,
//                          Dimension.getWidth(1.0),
//                          Dimension.getWidth(1.0),
//                          Colors.blueGrey[300],
//                          0.5)),
//                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0),
              child: Container(
                  child: AnimatedOpacity(
                      opacity: isLoading ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 500),
                      child: renderGirdCell(widget.machineCategolaryModel))),
            )
          ],
        ),
      ),
    );
  }

//  Widget renderListMachine() {
//    return Container(
//      height: Dimension.getHeight(0.165),
//      width: Dimension.getWidth(1.0),
//      child: Configs.lst_machine_cata == null
//          ? Center(
//              child: SpinKitCircle(color: Colors.orange)(
//                strokeWidth: 1.5,
//                valueColor: AlwaysStoppedAnimation(Colors.orange),
//              ),
//            )
//          : Configs.lst_machine_cata.length == 0
//              ? Center(
//                  child: Text(
//                    "Không có thông tin loại máy",
//                    style: StylesText.style13Black,
//                  ),
//                )
//              : ListView.builder(
//                  scrollDirection: Axis.horizontal,
//                  addAutomaticKeepAlives: true,
//                  itemExtent: null,
//                  shrinkWrap: true,
//                  physics: const ClampingScrollPhysics(),
//                  itemCount: Configs.lst_machine_cata == null ||
//                          Configs.lst_machine_cata.length == 0
//                      ? 0
//                      : Configs.lst_machine_cata.length,
//                  itemBuilder: (BuildContext context, int index) {
//                    return GestureDetector(
//                        child: Container(
//                            decoration: BoxDecoration(
//                                color: currentIndex == index
//                                    ? Colors.orange
//                                    : Colors.brown,
//                                border: Border.all(
//                                    color: currentIndex == index
//                                        ? Colors.red
//                                        : Colors.grey[300],
//                                    width: 2.0),
//                                borderRadius:
//                                    BorderRadius.all(Radius.circular(8.0))),
//                            margin: EdgeInsets.only(right: 12),
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Row(
//                                  children: <Widget>[
//                                    Stack(
//                                      alignment: AlignmentDirectional.topEnd,
//                                      children: <Widget>[
//                                        Padding(
//                                          padding: const EdgeInsets.fromLTRB(
//                                              0, 0, 0, 0),
//                                          child: Container(
//                                            height: Dimension.getHeight(0.12),
//                                            width: Dimension.getWidth(0.28),
//                                            decoration: new BoxDecoration(
//                                              borderRadius:
//                                                  BorderRadius.circular(8.0),
//                                              border: new Border.all(
//                                                  color: Colors.grey),
//                                            ),
//                                            child: ClipRRect(
//                                              borderRadius:
//                                                  BorderRadius.circular(8.0),
//                                              child: CachedNetworkImage(
//                                                imageUrl: Configs
//                                                                .lst_machine_cata[
//                                                                    index]
//                                                                .img_Url ==
//                                                            "" ||
//                                                        Configs
//                                                                .lst_machine_cata[
//                                                                    index]
//                                                                .img_Url ==
//                                                            null
//                                                    ? "https://library.kissclipart.com/20180830/kpq/kissclipart-machine-factory-icon-png-clipart-machine-factory-a-f479a7fc22bff4e5.jpg"
//                                                    : Unity.Replace_String(
//                                                        Configs
//                                                            .lst_machine_cata[
//                                                                index]
//                                                            .img_Url),
//                                                fit: BoxFit.fill,
//                                                placeholder: (context, url) =>
//                                                    new SizedBox(
//                                                  child: Center(
//                                                    child:
//                                                        SpinKitCircle(color: Colors.orange)(
//                                                      strokeWidth: 1.5,
//                                                      valueColor:
//                                                          new AlwaysStoppedAnimation(
//                                                              Colors.orange),
//                                                    ),
//                                                  ),
//                                                ),
//                                                errorWidget:
//                                                    (context, url, error) =>
//                                                        Icon(
//                                                  Icons.error,
//                                                  color: Colors.red,
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ],
//                                ),
//                                Padding(
//                                    padding:
//                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                                    child: Container(
//                                      width: Dimension.getWidth(0.28),
//                                      child: Row(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                        children: <Widget>[
//                                          Container(
//                                            width: Dimension.getWidth(0.28),
//                                            child: Text(
//                                              Configs
//                                                  .lst_machine_cata[index].name,
//                                              textAlign: TextAlign.center,
//                                              overflow: TextOverflow.ellipsis,
//                                              style: StylesText.style16While,
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    )),
//                              ],
//                            )),
//                        onTap: () async {
//                          await onHandleTap(index);
//                        });
//                  }),
//    );
//  }

  Widget renderGirdCell(MachineCategolaryModel machineCategolaryModel) {
    return Configs.lstMachineInCell == null || isLoading == true
        ? Center(child: SpinKitCircle(color: Colors.orange))
        : Configs.lstMachineInCell.length == 0
            ? Container(
                child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                children: _getListCell(machineCategolaryModel),
                crossAxisCount: 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),)
            : Container(
                // color: Colors.red,
                child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                children: _getListCell(machineCategolaryModel),
                crossAxisCount: 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ));
  }

  onHandleTap(int index) async {
    if (!mounted) return;
    setState(() {
      currentIndex = index;
    });
    LoadingDialog.showLoadingDialog(context);
    await getCellSummary().then((_) {
      LoadingDialog.hideLoadingDialog(context);
    });
  }

  _getListCell(MachineCategolaryModel machineCategolaryModel) {
    List<Widget> listCellItem = new List<Widget>();
    for (int i = 0; i < Configs.lstMachineInCell.length; i++) {
      Widget widget = Builder(
          builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: RaisedButton(
                  onPressed: () async {
                    await Navigator.of(context)
                        .push(
                      CupertinoPageRoute(
                        builder: (context) => ListMachinesOfCell(Configs.lstMachineInCell[i], machineCategolaryModel),
                      ),
                    )
                        .then((_) async {
                      await getCellSummary();
                    });
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Configs.lstMachineInCell[i].selected ? Colors.orange : Colors.transparent,
                          width: Configs.lstMachineInCell[i].selected ? 2.0 : 0.0),
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: Colors.white,
                  child: Container(
                      child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth,
                        child: Text(Configs.lstMachineInCell[i].code,
                            textAlign: TextAlign.center, style: StylesText.style12OrangeBold),
                      ),
                      Visibility(
                        visible: Configs.lstMachineInCell[i].totalMachineBroken > 0,
                        child: Text(
                            Configs.lstMachineInCell[i].totalMachineBroken.toString() +
                                    " " +
                                    allTranslations.text("machine_broken") ??
                                "",
                            textAlign: TextAlign.center,
                            style: StylesText.style12RedBold),
                      ),
                      Text(
                          Configs.lstMachineInCell[i].totalMachine.toString() + " " + allTranslations.text("machine") ??
                              "",
                          textAlign: TextAlign.center,
                          style: StylesText.style12Black),
                    ]),
                  )),
                ),
              ));
      listCellItem.add(widget);
    }
    Widget widget_last = Builder(
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(4.0),
              child: RaisedButton(
                onPressed: () {
                  Alert(
                    context: context,
                    title: allTranslations.text("create_cell"),
                    content: Container(
                        child: StreamBuilder<Object>(
                            stream: create_lines_stream.titleStream,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: name_cell,
                                decoration: InputDecoration(
                                    errorText: snapshot.hasError ? snapshot.error : null,
                                    errorStyle: StylesText.style10Red,
                                    hintStyle: StylesText.style13Blugray,
                                    hintText: allTranslations.text("enter_name_of_cell"),
                                    border:
                                        new OutlineInputBorder(borderSide: new BorderSide(color: Colors.redAccent))),
                              );
                            })),
                    buttons: [
                      DialogButton(
                        child: Text(
                          allTranslations.text("no"),
                          style: StylesText.style13WhiteBold,
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        color: Colors.orange,
                      ),
                      DialogButton(
                        child: Text(
                          allTranslations.text("yes"),
                          style: StylesText.style13WhiteBold,
                        ),
                        onPressed: () async {
                          await onAddcell();
                        },
                        color: Colors.orange,
                      )
                    ],
                  ).show().then((value) async {
                    if (value == true) {
                      LoadingDialog.showLoadingDialog(context);
                      Future.wait([getCellSummary()]).whenComplete(() {
                        LoadingDialog.hideLoadingDialog(context);
                      });
                    }
                  });
                },
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                color: Colors.white, //o day
                child: Container(
                    child: Center(
                        child: IconButton(
                  onPressed: () async {
                    await Alert(
                      context: context,
                      title: allTranslations.text("create_cell"),
                      content: Container(
                          child: StreamBuilder<Object>(
                              stream: create_lines_stream.titleStream,
                              builder: (context, snapshot) {
                                return TextField(
                                  controller: name_cell,
                                  decoration: InputDecoration(
                                      errorText: snapshot.hasError ? snapshot.error : null,
                                      errorStyle: StylesText.style10Red,
                                      hintStyle: StylesText.style13Blugray,
                                      hintText: allTranslations.text("enter_name_of_cell"),
                                      border:
                                          new OutlineInputBorder(borderSide: new BorderSide(color: Colors.redAccent))),
                                );
                              })),
                      buttons: [
                        DialogButton(
                          child: Text(
                            allTranslations.text("no"),
                            style: StylesText.style13WhiteBold,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          color: Colors.orange,
                        ),
                        DialogButton(
                          child: Text(
                            allTranslations.text("yes"),
                            style: StylesText.style13WhiteBold,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          color: Colors.orange,
                        )
                      ],
                    ).show().then((value) async {
                      if (value == true) {
                        await onAddcell();
                      }
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 11, 68, 125),
                  ),
                ))),
              ),
            ));
    listCellItem.add(widget_last);
    return listCellItem.toList();
  }

  Future onAddcell() async {
    LoadingDialog.showLoadingDialog(context);
    if (create_lines_stream.isValidInfo(name_cell.text.trim())) {
      if (await Validations.isConnectedNetwork() == true) {
        CreateCellRepository(name_cell.text.trim(), widget.lineId).then((value) async {
          if (value == 1) {
            await getCellSummary().then((_) {
              LoadingDialog.hideLoadingDialog(context);
              Toast.show(allTranslations.text("success_add"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            });
          } else {
            LoadingDialog.hideLoadingDialog(context);
            return MessageDialog.showMsgDialog(
                context, allTranslations.text("notification"), allTranslations.text("error"), AlertType.error);
          }
        });
      } else {
        LoadingDialog.hideLoadingDialog(context);
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
      }
    } else {
      return LoadingDialog.hideLoadingDialog(context);
    }
  }
}
