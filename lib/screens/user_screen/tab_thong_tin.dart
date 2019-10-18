import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';

class TabThongTin extends StatefulWidget {
  Function onrefresh;
  TabThongTin(this.onrefresh);
  @override
  State createState() => new TabThongTinState();
}

class TabThongTinState extends State<TabThongTin> with AutomaticKeepAliveClientMixin<TabThongTin> {
  // List<Centers> item_zone = [];
  // List<DropdownMenuItem<Zones>> _dropDownMenuItems_Zone;
  // List<DropdownMenuItem<Centers>> _dropDownMenuItems;
  // Centers _currentItem;
  // Zones _currentZone;
  int birthedayTimeStamp;

  TextEditingController username;
  TextEditingController name;
  TextEditingController birthday;
  TextEditingController phonenum;
  TextEditingController email;
  TextEditingController address;
  TextEditingController center;
  TextEditingController class_user;

  Future _selectDate() async {
    var format = new DateFormat("dd/MM/yyyy");
    DateTime picked = await showDatePicker(
        context: context, firstDate: DateTime(1970), initialDate: DateTime.now(), lastDate: DateTime(2100));
    if (picked != null) {
      setState(() => birthday.text = format.format(picked).toString());
    }
  }

  // List<DropdownMenuItem<Zones>> getDropDownMenuItems_Zone() {
  //   List<DropdownMenuItem<Zones>> items = new List();
  // for (Zones zone in lst_zone) {
  //   items.add(new DropdownMenuItem(
  //       value: zone,
  //       child: new Text(
  //         (lst_zone.indexOf(zone) + 1).toString() + ". " + zone.name,
  //         style: StylesText.style12Black,
  //       )));
  // }
  //   return items;
  // }

  // List<DropdownMenuItem<Centers>> getDropDownMenuItems() {
  //   List<DropdownMenuItem<Centers>> items = new List();

  //   for (Centers zone in item_zone) {
  //     items.add(new DropdownMenuItem(
  //         value: zone,
  //         child: new Text(
  //           (item_zone.indexOf(zone) + 1).toString() + ". " + zone.name,
  //           style: StylesText.style12Black,
  //         )));
  //   }
  //   return items;
  // }

  // Future changedDropDownItemZone(Zones selectedZone) async {
  //   try {
  //     setState(() {
  //       _currentZone = selectedZone;
  //     });
  //     if (selectedZone.code == 0) {
  //       center.text = "0";
  //       item_zone = Configs.listzone.where((i) => i.zoneCode == 0).toList();
  //       _currentItem = null;
  //       _dropDownMenuItems = getDropDownMenuItems();
  //     } else if (selectedZone.code == 1) {
  //       center.text = "1";
  //       _currentItem = null;
  //       item_zone = Configs.listzone.where((i) => i.zoneCode == 1).toList();
  //       _dropDownMenuItems = getDropDownMenuItems();
  //     } else {
  //       center.text = "2";
  //       _currentItem = null;
  //       item_zone = Configs.listzone.where((i) => i.zoneCode == 2).toList();
  //       _dropDownMenuItems = getDropDownMenuItems();
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error');
  //     FlutterCrashlytics().logException(e, e.stackTrace);
  //     return;
  //   }
  // }

  // void changedDropDownItem(Centers selectedZone) {
  //   setState(() {
  //     _currentItem = selectedZone;
  //   });
  //   class_user.text = selectedZone.code;
  // }

  @override
  initState() {
    try {
      name = new TextEditingController(
          text: Configs.user == null || Configs.user.fullName == null ? "" : Configs.user.fullName);
      birthday = new MaskedTextController(mask: '00/00/0000');

      phonenum = new TextEditingController();
      email = new TextEditingController();
      address = new TextEditingController();
    } catch (e, stackTrace) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initState tab thông tin');
      FlutterCrashlytics().logException(e, stackTrace);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: Container(
          constraints: BoxConstraints.expand(),
          color: Theme.of(context).backgroundColor,
          child: RefreshIndicator(
              onRefresh: onrefresh,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  // Padding(
                                  //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  //   child: TextField(
                                  //     enableInteractiveSelection: false,
                                  //     enabled: false,
                                  //     controller: username,
                                  //     style: StylesText.style13Black,
                                  //     decoration: InputDecoration(
                                  //         icon: Icon(Icons.account_circle,
                                  //             color: Colors.grey),
                                  //         labelText: allTranslations.text("username_login"),
                                  //         labelStyle: StylesText.style13Blugray),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: TextField(
                                      controller: name,
                                      style: StylesText.style13Black,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.recent_actors, color: Colors.orange),
                                          labelText: allTranslations.text("full_name"),
                                          labelStyle: StylesText.style13Blugray),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 6,
                                            child: Padding(
                                                padding: const EdgeInsets.only(right: 0.0),
                                                child: TextField(
                                                  textInputAction: TextInputAction.done,
                                                  autofocus: false,
                                                  controller: birthday,
                                                  keyboardType: TextInputType.datetime,
                                                  enableInteractiveSelection: false,
                                                  style: StylesText.style13Black,
                                                  decoration: InputDecoration(
                                                      icon: Icon(Icons.calendar_today, color: Colors.orange),
                                                      labelText: allTranslations.text("birth_day"),
                                                      labelStyle: StylesText.style13Blugray),
                                                )),
                                          ),
                                          // Expanded(
                                          //   flex: 1,
                                          //   child: Padding(
                                          //       padding: const EdgeInsets.only(
                                          //           left: 0.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.grey[400],
                                          //             borderRadius:
                                          //                 BorderRadius.all(
                                          //                     Radius.circular(
                                          //                         5.0))),
                                          //         width:
                                          //             Dimension.getWidth(0.08),
                                          //         child: FlatButton(
                                          //           onPressed: _selectDate,
                                          //           child: SvgPicture.asset(
                                          //               "assets/icons/calendar.svg",
                                          //               width:
                                          //                   Dimension.getWidth(
                                          //                       0.08)),
                                          //         ),
                                          //       )),
                                          // )
                                        ],
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: TextField(
                                      controller: phonenum,
                                      keyboardType: TextInputType.number,
                                      style: StylesText.style13Black,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.phone, color: Colors.orange),
                                          labelText: allTranslations.text("phone_number"),
                                          labelStyle: StylesText.style13Blugray),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: TextField(
                                      controller: email,
                                      style: StylesText.style13Black,
                                      decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.alternate_email,
                                            color: Colors.orange,
                                          ),
                                          labelText: "Email",
                                          labelStyle: StylesText.style13Blugray),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: TextField(
                                      controller: address,
                                      style: StylesText.style13Black,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.location_on, color: Colors.orange),
                                          labelText: allTranslations.text("address"),
                                          labelStyle: StylesText.style13Blugray),
                                    ),
                                  ),
                                  // Padding(
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  //     child: Row(
                                  //       children: <Widget>[
                                  //         Icon(
                                  //           Icons.business_center,
                                  //           color: Colors.orange,
                                  //         ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         top: 10.0, left: 15.0),
                                  //     child: ButtonTheme(
                                  //       child: DropdownButton(
                                  //         elevation: 20,
                                  //         style: StylesText.style13Black,
                                  //         isExpanded: true,
                                  //         hint: Text("Chọn khu vực",
                                  //             style: StylesText
                                  //                 .style13Blugray),
                                  //         value: _currentZone,
                                  //         items: _dropDownMenuItems_Zone,
                                  //         onChanged:
                                  //             changedDropDownItemZone,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                  //   ],
                                  // )),
                                  // Padding(
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  //     child: Row(
                                  //       children: <Widget>[
                                  //         Padding(
                                  //           padding: const EdgeInsets.only(
                                  //               top: 10.0, right: 1.0),
                                  //           child: Icon(
                                  //             Icons.group,
                                  //             color: Colors.orange,
                                  //           ),
                                  //         ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         left: 15.0),
                                  //     child: ButtonTheme(
                                  //       alignedDropdown: false,
                                  //       child: DropdownButton(
                                  //         elevation: 20,
                                  //         style: StylesText.style13Black,
                                  //         isExpanded: true,
                                  //         hint: Text("Chọn đoàn cơ sở",
                                  //             style: StylesText
                                  //                 .style13Blugray),
                                  //         value: _currentItem,
                                  //         items: _dropDownMenuItems,
                                  //         onChanged: changedDropDownItem,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  //   ],
                                  // )),
                                  // Padding(
                                  //   padding: const EdgeInsets.fromLTRB(
                                  //       10, 10, 10, 0),
                                  //   child: SizedBox(
                                  //     width: MediaQuery.of(context).size.width,
                                  //     height: 40,
                                  //     child: RaisedButton(
                                  //       color: Colors.orange,
                                  //       child: Text(
                                  //         allTranslations.text("yes"),
                                  //         style: StylesText.style16While,
                                  //       ),
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(5))),
                                  //       onPressed: () {
                                  //         showDialog(
                                  //             context: context,
                                  //             barrierDismissible: true,
                                  //             builder: (BuildContext context) {
                                  //               return AlertDialog(
                                  //                 shape: RoundedRectangleBorder(
                                  //                     borderRadius:
                                  //                         BorderRadius.all(
                                  //                             Radius.circular(
                                  //                                 8.0))),
                                  //                 content: new Text(
                                  //                   "Bạn có muốn lưu thay đổi không ?",
                                  //                   style:
                                  //                       StylesText.style15Black,
                                  //                 ),
                                  //                 actions: <Widget>[
                                  //                   FlatButton(
                                  //                     child: Text(
                                  //                       "Không",
                                  //                       style: StylesText
                                  //                           .style13Black,
                                  //                     ),
                                  //                     onPressed: () async {
                                  //                       Navigator.of(context)
                                  //                           .pop();
                                  //                     },
                                  //                   ),
                                  //                   FlatButton(
                                  //                     child: Container(
                                  //                       child: Center(
                                  //                           child: Text(
                                  //                         "Có",
                                  //                         style: StylesText
                                  //                             .style13Black,
                                  //                       )),
                                  //                     ),
                                  //                     onPressed: () {
                                  //                       Navigator.of(context)
                                  //                           .pop();
                                  //                       onEditInfoUser();
                                  //                     },
                                  //                   ),
                                  //                 ],
                                  //               );
                                  //             });
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  )))),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future onEditInfoUser() async {
    // LoadingDialog.showLoadingDialog(context, "Đang tải");
    // if (await Validation.isConnectedNetwork() == true) {
    //   if (birthday.text.length > 0) {
    //     var temp = new DateFormat("dd/MM/yyyy").parse(birthday.text);
    //     birthedayTimeStamp = temp.millisecondsSinceEpoch;
    //   } else {
    //     birthedayTimeStamp = 0;
    //   }

    //   if (await Edit_User_Info(
    //           username.text.trim(),
    //           name.text.trim(),
    //           birthedayTimeStamp,
    //           phonenum.text.trim(),
    //           email.text.trim(),
    //           address.text.trim(),
    //           center.text.trim(),
    //           class_user.text.trim()) ==
    //       1) {
    //     LoadingDialog.hideLoadingDialog(context);
    //     MsgDialog.showMsgDialog(
    //         context, allTranslations.text("notification"), "Cập nhật thông tin thành công");
    //     if (this.mounted) {
    //       setState(() {
    //         Configs.memoizer_user = AsyncMemoizer();
    //         Get_User_Info();
    //       });
    //     }
    //   } else {
    //     LoadingDialog.hideLoadingDialog(context);
    //     MsgDialog.showMsgDialog(
    //         context, allTranslations.text("notification"), allTranslations.text("error"));
    //   }
    // } else {
    //   LoadingDialog.hideLoadingDialog(context);
    //   MsgDialog.showMsgDialog(context, allTranslations.text("notification"), allTranslations.text("netword_faile"));
    // }
  }

  Future<void> onrefresh() async {
    Future.delayed(Duration(microseconds: 100));
    // widget.onrefresh();
    // if (this.mounted) {
    //   setState(() {
    //     initState();
    //     build(context);
    //   });
    // }
  }
}
