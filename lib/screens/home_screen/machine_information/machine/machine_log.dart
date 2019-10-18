import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/data/model/machine_in_cell_model.dart';
import 'package:pika_maintenance/data/model/machine_timeline_model.dart';
import 'package:pika_maintenance/data/model/timeline_model.dart';
import 'package:pika_maintenance/data/repository/get_machine_history_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/machine_information/machine_log_detail/feedback_item_log_machine.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:toast/toast.dart';

class TabMachineLog extends StatefulWidget {
  MachineInCellModel machine;
  TabMachineLog(this.machine);
  @override
  State createState() => new TabMachineLogState();
}

class TabMachineLogState extends State<TabMachineLog>
    with AfterLayoutMixin<TabMachineLog>, AutomaticKeepAliveClientMixin<TabMachineLog> {
  List<MachineInfoHistory> lstMachineHistory;

  Future initData() async {
    try {
      if (await Validations.isConnectedNetwork()) {
        await getMachinesHistoryRepository(machineId: widget.machine.id).then((va) {
          List<MachineInfoHistory> temp = va;
          if (temp == null || temp.length == 0) {
            if (!mounted) return;
            setState(() {
              lstMachineHistory = [];
            });
          } else {
            if (!mounted) return;
            setState(() {
              lstMachineHistory = temp;
            });
          }
        });
      } else {
        return Toast.show(allTranslations.text("netword_faile"), context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      }
    } catch (e, stacktrace) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData machine log page');
      FlutterCrashlytics().logException(e, stacktrace);
    }
  }

  getIconStatusRequest(int code) {
    switch (code) {
      case 0:
        return Icon(
          Icons.exposure_zero,
          color: Colors.white,
        );
        break;
      case 1:
        return Icon(
          Icons.looks_one,
          color: Colors.white,
        );
        break;
      case 2:
        return Icon(
          Icons.looks_two,
          color: Colors.white,
        );
        break;
      case 3:
        return Icon(
          Icons.looks_3,
          color: Colors.white,
        );
        break;
      case 4:
        return Icon(
          Icons.looks_4,
          color: Colors.white,
        );
        break;
      case 5:
        return Icon(
          Icons.looks_5,
          color: Colors.white,
        );
        break;
      case 6:
        return Icon(
          Icons.looks_6,
          color: Colors.white,
        );
        break;
      default:
        return Icon(
          Icons.report_problem,
          color: Colors.white,
        );
    }
  }

  getColorStatusRequest(int code) {
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

  String getStatusMachine(int machineStatus) {
    switch (machineStatus) {
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
          return allTranslations.text("status_machine_moving");
        }
      case 5:
        {
          return allTranslations.text("status_machine_new");
        }
      default:
        return "";
    }
  }

  String getStatusRequest(int statusCode) {
    switch (statusCode) {
      case 0:
        {
          return allTranslations.text("status_request_waitting");
        }
      case 1:
        {
          return allTranslations.text("status_request_recieved");
        }
      case 2:
        {
          return allTranslations.text("status_request_checking");
        }
      case 3:
        {
          return allTranslations.text("status_request_fixing");
        }
      case 4:
        {
          return allTranslations.text("status_request_pending");
        }
      case 5:
        {
          return allTranslations.text("status_request_finish");
        }
      case 6:
        {
          return allTranslations.text("status_request_closed");
        }
      case 7:
        {
          return allTranslations.text("status_machine_moving");
        }
      default:
        return "";
    }
  }

  getColorStatusMachine(int code) {
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
        return Colors.orange[200];
    }
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: lstMachineHistory[0]?.request?.length ?? 0,
      lineColor: Colors.orange[300],
      shrinkWrap: true,
      lineWidth: 1,
      physics: position == TimelinePosition.Left ? ClampingScrollPhysics() : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = lstMachineHistory[0].request[i];
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  allTranslations.text("machine_request") + " " + doodle.machineRqId?.toString() ?? "",
                  style: StylesText.style13BlackBold,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      doodle?.newCellCode == null
                          ? Container()
                          : Icon(
                              Icons.brightness_1,
                              color: Colors.blue,
                              size: 5,
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          doodle?.newCellCode?.toString() ?? "",
                          style: StylesText.style13Black,
                        ),
                      ),
                      doodle?.newLocation == null || doodle?.newLocation == ""
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.brightness_1,
                                color: Colors.blue,
                                size: 5,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          doodle.newLocation?.toString() ?? "",
                          style: StylesText.style13Black,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    doodle.description ?? "",
                    style: StylesText.style13Black,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ListTileTheme(
                    contentPadding: EdgeInsets.all(0.0),
                    child: ExpansionTile(
                      title: Text(
                        allTranslations.text("request_processing"),
                        style: StylesText.style13Black,
                      ),
                      children: <Widget>[
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            addAutomaticKeepAlives: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: doodle?.requestProcessing?.length ?? 0,
                            itemBuilder: (context, index) {
                              if (doodle.requestProcessing == null || doodle.requestProcessing.length == 0) {
                                return Center(
                                  child: Text(
                                    allTranslations.text("no_info"),
                                    style: StylesText.style13Black,
                                  ),
                                );
                              }
                              return ListTile(
                                title: Text(
                                  ChangeTime.ChangeTimeStampToTime(
                                      doodle.requestProcessing[index].date / 1000.0 ?? 0.0, true, false, false),
                                  style: StylesText.style13BlackBold,
                                ),
                                dense: true,
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.brightness_1,
                                      color: getColorStatusRequest(doodle.requestProcessing[index].requestStatus),
                                      size: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        getStatusRequest(doodle.requestProcessing[index].requestStatus) ?? "",
                                        style: StylesText.style13Black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Icon(
                                        Icons.brightness_1,
                                        color: getColorStatusMachine(doodle.requestProcessing[index].machineStatus),
                                        size: 5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        getStatusMachine(doodle.requestProcessing[index].machineStatus) ?? "",
                                        style: StylesText.style13Black,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        position: i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == lstMachineHistory[0].request.length,
        iconBackground: Colors.orange,
        icon: Icon(Icons.build));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await onrefresh();
          },
          child: Container(
            color: Theme.of(context).backgroundColor,
            width: Dimension.getWidth(1.0),
            height: Dimension.getHeight(1.0),
            child: lstMachineHistory == null
                ? Center(
                    child: SpinKitCircle(color: Colors.orange),
                  )
                : lstMachineHistory.length == 0
                    ? Center(
                        child: Text(
                          allTranslations.text("no_machine_log"),
                          style: StylesText.style13Black,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(child: FeedbackItemChat(lstMachineHistory[0])),
                          Expanded(
                            child: SafeArea(
                              child: Container(
                                constraints: BoxConstraints.expand(),
                                child: timelineModel(TimelinePosition.Left),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(height: 1.0),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  Future<void> onrefresh() async {
    try {
      await Future.delayed(const Duration(microseconds: 100));
      await initData();
    } catch (e, stackTrace) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in refresh machine log');
      FlutterCrashlytics().logException(e, stackTrace);
    }
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    await initData();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
