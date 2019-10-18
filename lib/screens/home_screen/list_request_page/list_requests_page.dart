import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/data/model/request_model.dart';
import 'package:pika_maintenance/data/repository/get_all_request.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/uis/horizontal_textbar/horizontal_textbar.dart';

import 'package:pika_maintenance/uis/time_text/time_text.dart';
import 'package:pika_maintenance/uis/triangke_clipper/triangle_clipper.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'update_request_page/message_page.dart';

class ListRequestsPage extends StatefulWidget {
  @override
  _ListRequestsPageState createState() => _ListRequestsPageState();
}

class _ListRequestsPageState extends State<ListRequestsPage> with AfterLayoutMixin<ListRequestsPage> {
  List<RequestModel> lst_request;

  @override
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    Future.wait([initData()]);
  }

  Future initData() async {
    try {
      if (await Validations.isConnectedNetwork()) {
        await GetAllRequest(wt: 0).then((va) {
          if (va != null) {
            if (va.length > 1) {
              va.sort((a, b) => a.requestId.compareTo(b.requestId));
            }

            if (this.mounted) {
              setState(() {
                lst_request = va;
              });
            }
          } else {
            setState(() {
              lst_request = [];
            });
          }
        });
      } else {
        setState(() {
          lst_request = [];
        });
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"),
            AlertType.warning);
      }
    } catch (e) {
      setState(() {
        lst_request = [];
      });
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData list request '
          'page');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  getColor(int code) {
    switch (code) {
      case 0:
        return Colors.blue;
        break;
      case 1:
        return Colors.grey;
        break;
      case 2:
        return Colors.green;
        break;
      case 3:
        return Colors.purple;
        break;
      case 4:
        return Colors.yellow;
        break;
      case 5:
        return Colors.orange;
        break;
      case 6:
        return Colors.blueGrey;
        break;
      case 7:
        return Colors.red;
        break;
      default:
        return Colors.orange[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: false,
          title: Text(allTranslations.text("lst_request"), style: StylesText.style18WhiteNomorl)),
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: Dimension.getWidth(1.0),
        height: Dimension.getHeight(1.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await onRefresh();
          },
          child: lst_request == null
              ? Center(child: SpinKitCircle(color: Colors.orange))
              : lst_request.length == 0
                  ? Center(
                      child: Text(
                        allTranslations.text("no_request"),
                        style: StylesText.style13Black,
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(2.0),
                            itemCount: lst_request.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => MessagePage(lst_request[index]),
                                    ),
                                  ).then((_) async {
                                    await onRefresh();
                                  });
                                },
                                child: Container(
                                  width: Dimension.getWidth(1.0),
                                  height: Dimension.getHeight(0.152),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width: Dimension.getWidth(1.0),
                                        child: new Card(
                                          child: new Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
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
                                                    decoration:
                                                        new BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                                    child: Center(
                                                        child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(
                                                        lst_request[index].requestId.toString() ?? "",
                                                        textAlign: TextAlign.center,
                                                        style: StylesText.style14While,
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
                                                            lst_request[index].machineCateCode ?? "",
                                                            style: StylesText.style18OrangeBold,
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.only(right: 25),
                                                            child: TimeText(
                                                                timeHasPassed: lst_request[index].inputtedTime),
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
                                                            lst_request[index].machineCode ?? "",
                                                            style: StylesText.style14Grey,
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            width: Dimension.getWidth(0.75),
                                                            child: Text(
                                                              lst_request[index].description ?? "",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: StylesText.style15Black,
                                                            ),
                                                          ),
                                                        ],
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
                                            color: getColor(lst_request[index].statusCode),
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
                                          colorReport: getColor(lst_request[index].statusCode),
                                          statusReport: lst_request[index].statusName,
                                          requestModel: lst_request[index],),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          alignment: Alignment(-1, 1),
                                          child: Container(
                                            height: 2,
                                            width: double.infinity,
                                            color: getColor(lst_request[index].statusCode),
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
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1));
    await initData();
  }
}
