import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/message_model.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';

import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/description_text/description_text.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationsPageState();
  }
}

class NotificationsPageState extends State<NotificationsPage>
    with AfterLayoutMixin<NotificationsPage> {
  Future initData() async {
    List<MessageFirebaseModel> temp =
        await Configs.messageFirebaseDao.findAllMessageFirebases();
    if (temp == null || temp.length == 0) {
      if (this.mounted) {
        setState(() {
          Configs.messages = [];
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          Configs.messages = temp;
        });
      }
    }
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    await initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: <Widget>[
          Container(
            width: Dimension.getWidth(0.15),
            child: FlatButton(
              color: Colors.orange[300],
              onPressed: () {
                // showDialog(
                //     context: context,
                //     builder: (_) => Padding(
                //           padding: EdgeInsets.only(
                //               bottom: MediaQuery.of(context).viewInsets.bottom),
                //           child: Confirm_Dialog(),
                //         )).then((value) {
                //   if (value == true) {
                //     if (this.mounted) {
                //       setState(() {
                //         build(context);
                //       });
                //     }
                //     _scaffoldKey.currentState.showSnackBar(SnackBar(
                //       backgroundColor: Colors.orange,
                //       content: Text(
                //         "Xóa thành công",
                //         style: StylesText.style13White,
                //       ),
                //       duration: Duration(seconds: 2),
                //     ));
                //   } else {
                //     return;
                //   }
                // });

                Alert(
                  context: context,
                  title: allTranslations.text("notification"),
                  type: AlertType.warning,
                  desc: allTranslations.text("confirm_delete_all_notification"),
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
                ).show().then((va) async {
                  if (va == true) {
                    await Configs.messageFirebaseDao.deleteAllRow().then((_) {
                      Toast.show(
                          allTranslations.text("delete_notification_suc"),
                          context,
                          duration: Toast.LENGTH_SHORT,
                          gravity: Toast.BOTTOM);
                    });
                    await onRefresh();
                  } else {
                    return;
                  }
                });
              },
              child:
                  Icon(Icons.delete_forever, color: Colors.white, size: 25),
            ),
          ),
        ],
        title: Text(
          allTranslations.text("notificattion_menu"),
          style: StylesText.style18WhiteNomorl,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Dimension.getWidth(1.0),
        height: Dimension.getHeight(1.0),
        color: Theme.of(context).backgroundColor,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            child: Configs.messages == null
                ? Center(child: SpinKitCircle(color: Colors.orange))
                : Configs.messages.length == 0
                    ? Center(
                        child: Text(allTranslations.text("no_info"),
                            style: StylesText.style13Black),
                      )
                    : Container(
                        child: ListView.builder(
                            addAutomaticKeepAlives: true,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: Configs.messages.length == 0
                                ? 0
                                : Configs.messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Slidable(
                                delegate: new SlidableDrawerDelegate(),
                                actionExtentRatio: 0.25,
                                child: ItemNotication(index),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                      caption: allTranslations
                                          .text("delete_notification"),
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        Alert(
                                          context: context,
                                          title: allTranslations
                                              .text("notification"),
                                          type: AlertType.warning,
                                          desc: allTranslations.text(
                                              "confirm_delete_this_notification"),
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
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              color: Colors.orange,
                                            )
                                          ],
                                        ).show().then((va) async {
                                          if (va == true) {
                                            await Configs.messageFirebaseDao
                                                .deleteMessageById(
                                                    Configs.messages[index].id)
                                                .then((_) {
                                              Toast.show(
                                                  allTranslations.text(
                                                      "delete_notification_suc"),
                                                  context,
                                                  gravity: Toast.BOTTOM,
                                                  duration: Toast.LENGTH_LONG);
                                            });
                                            await onRefresh();
                                          } else {
                                            return;
                                          }
                                        });
                                      }),
                                ],
                              );
                            }),
                      ),
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(microseconds: 100));
    await initData();
  }
}

class ItemNotication extends StatefulWidget {
  final int index;
  ItemNotication(this.index);

  @override
  _ItemNoticationState createState() => _ItemNoticationState();
}

class _ItemNoticationState extends State<ItemNotication> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    double deviceW = MediaQuery.of(context).size.width;
    double widthChat = deviceW - 12 * 2 - 50 - 29;
    return Card(
      color: Theme.of(context).backgroundColor,
      child: ListTile(
        contentPadding: const EdgeInsets.all(5.0),
        leading: CircleAvatar(
          child: ClipOval(
            child: Image.asset(
              "assets/images/logo.png",
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
        ),
        dense: true,
        title: Text(Configs.messages[widget.index].title,
            overflow: TextOverflow.ellipsis, style: StylesText.style15BlueBold),
        subtitle: DescriptionText(Configs.messages[widget.index].body,),
      ),
    );
    // Container(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Container(
    //         padding: EdgeInsets.only(
    //           left: 12,
    //           right: 12,
    //           top: 16,
    //           bottom: 8,
    //         ),
    //         child: GestureDetector(
    //           onTap: () {
    //             setState(
    //               () {
    //                 isExpand = !isExpand;
    //               },
    //             );
    //           },
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               CircleAvatar(
    //                 child: ClipOval(
    //                   child: Image.asset(
    //                     "assets/images/logo.png",
    //                     height: 50,
    //                     width: 50,
    //                     fit: BoxFit.contain,
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: 5,
    //               ),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: <Widget>[
    //                         AnimatedContainer(
    //                           curve: Curves.easeIn,
    //                           duration: Duration(seconds: 1),
    //                           width: widthChat,
    //                           child: Text(
    //                             Configs.messages[widget.index].title,
    //                             maxLines: isExpand ? 99 : 4,
    //                             overflow: TextOverflow.ellipsis,
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                             ),
    //                           ),
    //                         ),
    //                         Icon(
    //                           isExpand
    //                               ? Icons.keyboard_arrow_up
    //                               : Icons.keyboard_arrow_down,
    //                           // color: Colors.blue,
    //                         ),
    //                       ],
    //                     ),
    //                     SizedBox(
    //                       height: 3,
    //                     ),
    //                     Text(
    //                       Configs.messages[widget.index].body,
    //                       style: TextStyle(
    //                         fontSize: 12,
    //                         color: Colors.black54,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Container(
    //         color: Colors.black26,
    //         height: 1,
    //         width: double.infinity,
    //       )
    //     ],
    //   ),
    // );
  }
}
