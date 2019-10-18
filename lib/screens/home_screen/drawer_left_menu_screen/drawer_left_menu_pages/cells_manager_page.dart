import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/repository/delete_cell_repository.dart';
import 'package:pika_maintenance/data/repository/get_cells_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/edit_cell_manager_page.dart';
import 'package:pika_maintenance/streams/create_lines_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

import 'create_cell_manager_page.dart';

class Cells_Manager_Page extends StatefulWidget {
  Cells_Manager_Page({Key key}) : super(key: key);

  _Cells_Manager_PageState createState() => _Cells_Manager_PageState();
}

class _Cells_Manager_PageState extends State<Cells_Manager_Page> with AfterLayoutMixin<Cells_Manager_Page> {
  TextEditingController counpon_code;
  CreateLineStream create_lines_stream;
  TextEditingController name_line;
  List<CellModel> lst_cells;
  @override
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    await initData();
  }

  Future initData() async {
    await GetCellsRepository(0).timeout(const Duration(seconds: 10)).then((va) {
      if (va != null) {
        if (this.mounted) {
          setState(() {
            lst_cells = va;
          });
        }
        return;
      } else {
        if (this.mounted) {
          setState(() {
            lst_cells = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(allTranslations.text("list_cell"), style: StylesText.style18WhiteNomorl),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, size: 25, color: Colors.white),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        height: Dimension.getHeight(1.0),
        width: Dimension.getWidth(1.0),
        color: Colors.grey[200],
        child: RefreshIndicator(
            onRefresh: onRefresh,
            child: lst_cells == null
                ? Center(child: SpinKitCircle(color: Colors.orange))
                : lst_cells.length == 0
                    ? Center(
                        child: Text(
                          allTranslations.text("no_cell_info"),
                          style: StylesText.style13Black,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: lst_cells == null || lst_cells.length == 0 ? 0 : lst_cells.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    CupertinoPageRoute(builder: (context) => EditCellManagerPage(lst_cells[index])));
                              },
                              child: Slidable(
                                delegate: new SlidableDrawerDelegate(),
                                actionExtentRatio: 0.25,
                                child: Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.all(5.0),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                                            child: Text((index + 1).toString(), style: StylesText.style13WhiteBold),
                                          ),
                                        ),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          lst_cells[index].code.toString(),
                                          style: StylesText.style13Blue,
                                        ),
                                      ),
                                    )),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                      caption: allTranslations.text("delete_cell"),
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () async {
                                        Alert(
                                          context: context,
                                          title: allTranslations.text("notification"),
                                          type: AlertType.warning,
                                          desc: lst_cells[index] == null || lst_cells[index].code == null
                                              ? allTranslations.text("delete_this_cell")
                                              : allTranslations.text("delete_name_cell") +
                                                  " " +
                                                  lst_cells[index].code.toString() +
                                                  " " +
                                                  allTranslations.text("contain_no"),
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
                                                  if (await DeleteCellRepository(lst_cells[index].lineId,
                                                          lst_cells[index].id, lst_cells[index].code) ==
                                                      1) {
                                                    Navigator.of(context).pop(true);
                                                    return Toast.show(
                                                        allTranslations.text("delete_notification"), context,
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
                                                lst_cells.removeAt(index);
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
        tooltip: allTranslations.text("create_cell"),
        onPressed: () async {
          await Navigator.of(context)
              .push(CupertinoPageRoute(builder: (context) => CreateCellManagerPage()))
              .then((_) async {
            await onRefresh();
          });
        },
        child: Icon(Icons.add, size: 25, color: Colors.white),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      GetCellsRepository(0).then((value) {
        if (this.mounted) {
          setState(() {
            lst_cells = value;
          });
        }
      });
    } catch (e, stackTrace) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in refresh cell manager page');
      FlutterCrashlytics().logException(e, stackTrace);
    }
  }
}
