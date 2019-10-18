import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pika_maintenance/data/model/machine_model.dart';

import 'package:pika_maintenance/data/repository/get_mahines_repository.dart';
import 'package:pika_maintenance/data/repository/delete_machine_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/create_machine_page.dart';
import 'package:pika_maintenance/streams/create_lines_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pika_maintenance/validations/validations.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

import 'edit_machine_manager_page.dart';

class MachinesManagerPage extends StatefulWidget {
  MachinesManagerPage({Key key}) : super(key: key);

  _MachinesManagerPageState createState() => _MachinesManagerPageState();
}

class _MachinesManagerPageState extends State<MachinesManagerPage> with AfterLayoutMixin<MachinesManagerPage> {
  TextEditingController counpon_code;
  CreateLineStream create_lines_stream;

  TextEditingController name_line;
  List<MachineModel> lst_machines;
  @override
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    await initData();
  }

  Future initData() async {
    await GetMachinesRepository().timeout(const Duration(seconds: 10)).then((va) {
      if (va != null) {
        if (this.mounted) {
          setState(() {
            lst_machines = va;
          });
        }
        return;
      } else {
        if (this.mounted) {
          setState(() {
            lst_machines = [];
          });
        }

        return;
      }
    });
  }

  @override
  void initState() {
    create_lines_stream = new CreateLineStream();
    name_line = new TextEditingController();
    counpon_code = new TextEditingController();
    super.initState();
  }
  String getStatusMachine(MachineModel machineInCellModel) {
    switch (int.tryParse(machineInCellModel.statusCode)) {
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
          return  allTranslations.text("status_machine_broken");
        }
      case 4:
        {
          return  allTranslations.text("status_machine_moving");
        }
      case 5:
        {
          return allTranslations.text("status_machine_new");
        }
      default: return "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Danh sách máy", style: StylesText.style18WhiteNomorl),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
        ),
//        actions: <Widget>[
//          IconButton(
//            onPressed: () {},
//            icon: Icon(Icons.search, size: 25, color: Colors.white),
//          )
//        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        height: Dimension.getHeight(1.0),
        width: Dimension.getWidth(1.0),
        color: Colors.grey[200],
        child: RefreshIndicator(
            onRefresh: onRefresh,
            child: lst_machines == null
                ? Center(child: SpinKitCircle(color: Colors.orange))
                : lst_machines.length == 0
                    ? Center(
                        child: Text(
                          "Không có thông tin máy",
                          style: StylesText.style13Black,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: false,
                        itemCount: lst_machines == null || lst_machines.length == 0 ? 0 : lst_machines.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    CupertinoPageRoute(builder: (context) => EditMachinePage(lst_machines[index])));
                              },
                              child: Slidable(
                                delegate: new SlidableDrawerDelegate(),
                                actionExtentRatio: 0.25,
                                child: Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromARGB(255, 11, 68, 125),
                                        ),
                                        width: Dimension.getWidth(0.1),
                                        height: Dimension.getWidth(0.1),
                                        child: Center(
                                            child: Text((index + 1).toString(), style: StylesText.style13WhiteBold)),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(0.0),
                                    title: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        lst_machines[index].code.toString(),
                                        style: StylesText.style14BlueBold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      getStatusMachine(lst_machines[index]),
                                      style: StylesText.style13Bluegray,
                                    ),
                                    dense: true,
                                  ),
                                ),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                      caption: "Xóa máy",
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () async {
                                        Alert(
                                          context: context,
                                          title: allTranslations.text("notification"),
                                          type: AlertType.warning,
                                          desc: lst_machines[index] == null || lst_machines[index].code == null
                                              ? "Bạn có muốn xóa máy này không?"
                                              : "Bạn có muốn xóa máy" +
                                                  lst_machines[index].code.toString() +
                                                  " không ?",
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
                                                if (await Validations.isConnectedNetwork() == true) {
                                                  if (await DeleteMachineRepository(
                                                        lst_machines[index].machineId,
                                                        lst_machines[index].mCateId,
                                                        lst_machines[index].cell_id,
                                                        lst_machines[index].name,
                                                      ) ==
                                                      1) {
                                                    Navigator.of(context).pop(true);
                                                    return Toast.show("Xóa thành công!", context,
                                                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                                                  } else {
                                                    Navigator.of(context).pop(false);
                                                    return MessageDialog.showMsgDialog(
                                                        context,
                                                        allTranslations.text("notification"),
                                                        allTranslations.text("error"),
                                                        AlertType.error);
                                                  }
                                                } else {
                                                  Navigator.of(context).pop(false);
                                                  return MessageDialog.showMsgDialog(
                                                      context,
                                                      allTranslations.text("notification"),
                                                      allTranslations.text("netword_faile"),
                                                      AlertType.warning);
                                                }
                                              },
                                              color: Colors.orange,
                                            )
                                          ],
                                        ).show().then((value) {
                                          if (value == true) {
                                            if (this.mounted) {
                                              setState(() {
                                                lst_machines.removeAt(index);
                                              });
                                              return;
                                            }
                                          } else {
                                            return;
                                          }
                                        });
                                      }),
                                ],
                              ));
                        },
                      )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        tooltip: "Thêm máy",
        onPressed: () async {
          await Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CreateMachinePage())).then((va) {
            onRefresh();
          });
        },
        child: Icon(Icons.add, size: 25, color: Colors.white),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      GetMachinesRepository().then((value) {
        if (this.mounted) {
          setState(() {
            lst_machines = value;
          });
        }
      });
    } catch (e) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in get machine in machine'
          ' managet page');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }
}
