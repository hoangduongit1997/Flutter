import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';

import 'package:pika_maintenance/data/repository/get_machines_categolary_repository.dart';

import 'package:pika_maintenance/data/repository/delete_machine_categolary_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/edit_machine_categolary_page.dart';

import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'create_machine_categolary_page.dart';

class MachinesCategolaryManagerPage extends StatefulWidget {
  Machine_Catalo_ManageState createState() => Machine_Catalo_ManageState();
}

class Machine_Catalo_ManageState extends State<MachinesCategolaryManagerPage> {
  MachineCategolaryModel all =
      new MachineCategolaryModel(0, "All", "All", "", "", 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Danh sách loại máy", style: StylesText.style18WhiteNomorl),
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
          onRefresh: () async {
            await onRefresh();
          },
          child: Configs.lstMachineCata == null
              ? Center(
                  child: SpinKitCircle(color: Colors.orange)
                )
              : Configs.lstMachineCata.length == 0
                  ? Center(
                      child: Text(
                        "Không có thông tin loại máy",
                        style: StylesText.style13Black,
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      addAutomaticKeepAlives: true,
                      itemCount: Configs.lstMachineCata == null ||
                              Configs.lstMachineCata.length == 0
                          ? 0
                          : Configs.lstMachineCata.length,
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: Configs.lstMachineCata[index].id == 0
                              ? false
                              : true,
                          child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context)
                                    .push(CupertinoPageRoute(
                                        builder: (context) =>
                                            EditMachineCategolaryPage(Configs
                                                .lstMachineCata[index])))
                                    .then((_) async {
                                  await onRefresh();
                                });
                              },
                              child: Slidable(
                                delegate: new SlidableDrawerDelegate(),
                                actionExtentRatio: 0.25,
                                child: Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Stack(
                                            alignment: AlignmentDirectional
                                                .bottomStart,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.4,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Configs
                                                        .lstMachineCata[index]
                                                        .img_Url
                                                        .isEmpty
                                                    ? Center(
                                                        child: Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                        size: 25,
                                                      ))
                                                    : CachedNetworkImage(
                                                        fadeOutDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    700),
                                                        imageUrl: Unity
                                                            .Replace_String(Configs
                                                                .lstMachineCata[
                                                                    index]
                                                                .img_Url),
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)),
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        fit: BoxFit.cover,
                                                        fadeInDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    700),
                                                        placeholder:
                                                            (context, url) =>
                                                                new SizedBox(
                                                          child: Center(
                                                            child:
                                                                SpinKitCircle(color: Colors.orange)
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.image,
                                                          color: Colors.grey[300],
                                                        ),
                                                      ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, bottom: 5.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white70,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 3.0,
                                                          color: Colors.white
                                                              .withOpacity(.2),
                                                          offset:
                                                              Offset(1.0, 1.0),
                                                        ),
                                                      ],
                                                      // border: Border.all(
                                                      //     color: Colors.orange)
                                                      ),
                                                  width: 30,
                                                  height: 30,
                                                  child: Center(
                                                    child: Text(
                                                        (index).toString(),
                                                        style: StylesText
                                                            .style13OrangeBold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            allTranslations
                                                    .text("machine_category") +
                                                Configs.lstMachineCata[index]
                                                    .code
                                                    .toString(),
                                            style: StylesText.style15BlueBold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                      caption: "Xóa loại máy",
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () async {
                                        Alert(
                                          context: context,
                                          title: allTranslations
                                              .text("notification"),
                                          type: AlertType.warning,
                                          desc: Configs.lstMachineCata[
                                                          index] ==
                                                      null ||
                                                  Configs
                                                          .lstMachineCata[
                                                              index]
                                                          .code ==
                                                      null
                                              ? "Bạn có muốn xóa loại máy này không?"
                                              : "Bạn có muốn xóa loại máy  " +
                                                  Configs
                                                      .lstMachineCata[index]
                                                      .code
                                                      .toString() +
                                                  " không ?",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                allTranslations.text("no"),
                                                style: StylesText.style13WhiteBold,
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
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
                                                  if (await DeleteMachineCategolaryRepository(
                                                          Configs
                                                              .lstMachineCata[
                                                                  index]
                                                              .code,
                                                          Configs
                                                              .lstMachineCata[
                                                                  index]
                                                              .id) ==
                                                      1) {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    return Toast.show(
                                                        "Xóa thành công!",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  } else {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                    return MessageDialog
                                                        .showMsgDialog(
                                                            context,
                                                            allTranslations.text(
                                                                "notification"),
                                                            allTranslations
                                                                .text("error"),
                                                            AlertType.error);
                                                  }
                                                } else {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                  return MessageDialog
                                                      .showMsgDialog(
                                                          context,
                                                          allTranslations.text(
                                                              "notification"),
                                                          allTranslations.text(
                                                              "netword_faile"),
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
                                                Configs.lstMachineCata
                                                    .removeAt(index);
                                              });
                                              return;
                                            }
                                          } else {
                                            return;
                                          }
                                        });
                                      }),
                                ],
                              )),
                        );
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        tooltip: "Thêm tên loại máy",
        onPressed: () async {
          await Navigator.of(context)
              .push(CupertinoPageRoute(
                  builder: (context) => CreateMachineCategolaryPage()))
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
    GetMachinesCategolaryRepository().then((value) {
      if (this.mounted) {
        setState(() {
          Configs.lstMachineCata = value;
          Configs.lstMachineCata.insert(0, all);
        });
      }
    });
  }
}
