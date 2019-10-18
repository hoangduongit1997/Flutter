import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pika_maintenance/configs/configs.dart';

import 'package:pika_maintenance/data/repository/create_line_repository.dart';
import 'package:pika_maintenance/data/repository/edit_line_repository.dart';
import 'package:pika_maintenance/data/repository/get_lines_repository.dart';
import 'package:pika_maintenance/data/repository/delete_line_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/streams/create_lines_stream.dart';

import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pika_maintenance/validations/validations.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class LinesManagerPage extends StatefulWidget {
  LinesManagerPage({Key key}) : super(key: key);

  _LinesManagerPageState createState() => _LinesManagerPageState();
}

class _LinesManagerPageState extends State<LinesManagerPage> {
  TextEditingController counpon_code;
  CreateLineStream create_lines_stream;
  TextEditingController name_line;

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
        title: Text(allTranslations.text("list_line"), style: StylesText.style18WhiteNomorl),
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
          child:Configs.lstLine == null ||
                  Configs.lstLine.length == 0
              ? Center(
                  child: Text(
                    allTranslations.text("no_line"),
                    style: StylesText.style13Black,
                  ),
                )
              : 
           ListView.builder(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: Configs.lstLine == null || Configs.lstLine.length == 0
                ? 0
                : Configs.lstLine.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    counpon_code.text = Configs.lstLine[index].code;
                    Alert(
                      context: context,
                      title: Configs.lstLine[index] == null ||
                              Configs.lstLine[index].code == null
                          ? "Sửa line"
                          : "Sửa line " + Configs.lstLine[index].code,
                      content: StreamBuilder<Object>(
                          stream: create_lines_stream.titleStream,
                          builder: (context, snapshot) {
                            return TextField(
                              controller: counpon_code,
                              decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  errorStyle: StylesText.style10Red,
                                  hintStyle: StylesText.style13Blugray,
                                  hintText: "Nhập tên line",
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.redAccent))),
                            );
                          }),
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
                            if (create_lines_stream
                                .isValidInfo(counpon_code.text.trim())) {
                              if (await Validations.isConnectedNetwork() ==
                                  true) {
                                if (await EditLineRepository(
                                        Configs.lstLine[index].lineId,
                                        counpon_code.text.trim()) ==
                                    1) {
                                  Navigator.of(context).pop(true);
                                  return Toast.show("Sửa thành công!", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);
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
                            } else {
                              return;
                            }
                          },
                          color: Colors.orange,
                        )
                      ],
                    ).show().then((value) {
                      if (value == true) {
                        onRefresh();
                      } else {
                        return;
                      }
                    });
                  },
                  child: Slidable(
                    delegate: new SlidableDrawerDelegate(),
                    actionExtentRatio: 0.25,
                    child: Card(
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(10,5, 10, 5),
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 11, 68, 125),
                              ),
                              width: Dimension.getWidth(0.1),
                              height:Dimension.getWidth(0.1),
                              child: Center(
                                child: Text((index + 1).toString(),
                                    style: StylesText.style13WhiteBold),
                              ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text(
                              Configs.lstLine[index].code,
                              style: StylesText.style13Blue,
                            ),
                          ),
                        )),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          caption: "Xóa line",
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () async {
                            // bool is_delete = await showDialog(
                            //     context: context,
                            //     builder: (_) =>
                            //         Delete_Line_Dialog(Config.lst_line[index]));
                            // if (is_delete == true) {
                            //   if (this.mounted) {
                            //     setState(() {
                            //       Config.lst_line.removeAt(index);
                            //     });
                            //     return;
                            //   }
                            // } else {
                            //   return;
                            // }

                            Alert(
                              context: context,
                              title: allTranslations.text("notification"),
                              type: AlertType.warning,
                              desc: Configs.lstLine[index] == null ||
                                      Configs.lstLine[index].code == null
                                  ? "Bạn có muốn xóa line này không?"
                                  : "Bạn có muốn xóa line " +
                                      Configs.lstLine[index].code.toString() +
                                      " không ?",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    allTranslations.text("no"),
                                    style: StylesText.style13WhiteBold,
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  color: Colors.orange,
                                ),
                                DialogButton(
                                  child: Text(
                                    allTranslations.text("yes"),
                                    style: StylesText.style13WhiteBold,
                                  ),
                                  onPressed: () async {
                                    if (await Validations
                                            .isConnectedNetwork() ==
                                        true) {
                                      if (await DeleteLineRepository(
                                              Configs.lstLine[index].lineId,
                                              Configs.lstLine[index].code,
                                              Configs.lstLine[index].name) ==
                                          1) {
                                        Navigator.of(context).pop(true);
                                        return Toast.show(
                                            "Xóa thành công!", context,
                                            duration: Toast.LENGTH_SHORT,
                                            gravity: Toast.BOTTOM);
                                      } else {
                                        Navigator.of(context).pop(false);
                                        return MessageDialog.showMsgDialog(
                                            context,
                                            allTranslations
                                                .text("notification"),
                                            allTranslations.text("error"),
                                            AlertType.error);
                                      }
                                    } else {
                                      Navigator.of(context).pop(false);
                                      return MessageDialog.showMsgDialog(
                                          context,
                                          allTranslations.text("notification"),
                                          allTranslations
                                              .text("netword_faile"),
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
                                    Configs.lstLine.removeAt(index);
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        tooltip: "Thêm line",
        onPressed: () {
          Alert(
            context: context,
            title: "Thêm line",
            content: StreamBuilder<Object>(
                stream: create_lines_stream.titleStream,
                builder: (context, snapshot) {
                  return TextField(
                    controller: name_line,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        errorStyle: StylesText.style10Red,
                        hintStyle: StylesText.style13Blugray,
                        hintText: "Nhập tên line",
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Colors.redAccent))),
                  );
                }),
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
                  if (create_lines_stream.isValidInfo(name_line.text.trim())) {
                    if (await Validations.isConnectedNetwork() == true) {
                      CreateLineRepository(name_line.text.trim()).then((value) {
                        if (value == 1) {
                          Navigator.of(context).pop(true);
                          return Toast.show(allTranslations.text("success_add"), context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
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
                    return;
                  }
                },
                color: Colors.orange,
              )
            ],
          ).show().then((value) {
            if (value == true) {
              onRefresh();
            } else {
              return;
            }
          });
        },
        child: Icon(Icons.add, size: 25, color: Colors.white),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 100));
    GetLinesRepository().then((value) {
      if (this.mounted) {
        setState(() {
          Configs.lstLine = value;
        });
      }
    });
  }
}
