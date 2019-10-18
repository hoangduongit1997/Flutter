import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/recieve_comment_model.dart';

import 'package:pika_maintenance/data/model/request_model.dart';
import 'package:pika_maintenance/data/model/send_comment_model.dart';
import 'package:pika_maintenance/data/model/timeline_model.dart';
import 'package:pika_maintenance/data/repository/get_comments_repository.dart';
import 'package:pika_maintenance/data/repository/send_comment_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:toast/toast.dart';
import 'chat_message.dart';
import 'feedback_item_chat.dart';

class MessagePage extends StatefulWidget {
  RequestModel requestModel;
  MessagePage(this.requestModel);
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with TickerProviderStateMixin, AfterLayoutMixin {
  final TextEditingController _textController = TextEditingController();
  RequestModel instanceRequestModel;
  List<RecieveCommentModel> comment = [];
  bool _isComposing = false;
  List<TimeLineModel> lstTimeLine;
  int timestame_comment;
  ScrollController _scrollController_timeline = new ScrollController();

  Future initData() async {
    try {
      GetCommentsRepository(requestId: instanceRequestModel.requestId, wt: 0).then((value) {
        if (value != null && value.length > 0) {
          comment = value;
          if (comment.length > 1) {
            comment.sort((a, b) => a.date.compareTo(b.date));
            comment.reversed;
          }
          timestame_comment = comment.first.date.toInt();
          lstTimeLine = new List();
          for (RecieveCommentModel item in comment) {
            TimeLineModel timeLineModel = new TimeLineModel(
              name: item?.cUserName ?? "",
              content: item?.comment ?? "",
              machineStatus: item?.machineStatus,
              machineStatusName: item?.machineStatusName ?? "",
              cUserId: item?.cUserId,
              cUserName: item?.cUserName,
              url_avt: item?.url_avt ?? "",
              url: item?.url ?? "",
              requestId: item?.requestId,
              status: item?.status,
              statusName: item?.statusName ?? "",
              icon: getIconStatusRequest(item?.status ?? 0),
              iconBackground: getColorStatusRequest(item?.status ?? 0),
              time: ChangeTime.ChangeTimeStampToTime(item?.date ?? 0.0, true, false, false),
            );
            setState(() {
              lstTimeLine.insert(0, timeLineModel);
            });
          }
        } else {
          setState(() {
            lstTimeLine = [];
          });
        }
      });
    } catch (e, stacktrace) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData message page');
      FlutterCrashlytics().logException(e, stacktrace);
    }
  }

  void _goToElementLine(int index) {
    _scrollController_timeline.animateTo((250.0 * index), duration: const Duration(seconds: 3), curve: Curves.easeOut);
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

  String getStatusMachine(TimeLineModel requestModel) {
    switch (requestModel.machineStatus) {
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
      itemCount: lstTimeLine?.length??0,
      lineColor: Colors.orange[300],
      shrinkWrap: true,
      lineWidth: 1,
      controller: _scrollController_timeline,
      physics: position == TimelinePosition.Left ? ClampingScrollPhysics() : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = lstTimeLine[i];
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
                Row(
                  children: <Widget>[
                    CachedNetworkImage(
                        fadeOutDuration: Duration(milliseconds: 700),
                        imageUrl: doodle.url_avt,
                        imageBuilder: (context, imageProvider) => Container(
                              height: Dimension.getWidth(0.055),
                              width: Dimension.getWidth(0.055),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 700),
                        placeholder: (context, url) => new SizedBox(
                              child: Center(
                                child: SpinKitFadingCircle(
                                  color: Color.fromARGB(255, 40, 115, 161),
                                  size: 15,
                                ),
                              ),
                            ),
                        errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              color: Colors.grey.withOpacity(0.8),
                            )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            doodle?.cUserName ?? "",
                            style: StylesText.style15Orange,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(doodle?.time ?? "", style: StylesText.style12GrayItalic),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.brightness_1,
                      color: getColorStatusRequest(doodle.status),
                      size: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        getStatusRequest(doodle.status),
                        style: StylesText.style13Black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.brightness_1,
                        color: getColorStatusMachine(doodle.machineStatus),
                        size: 8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        getStatusMachine(doodle),
                        style: StylesText.style13Black,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  doodle.content,
                  style: StylesText.style13Black,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        position: i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == lstTimeLine.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }

  @override
  void initState() {
    instanceRequestModel = widget.requestModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: FlatButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          allTranslations.text("comment_request") + " " + instanceRequestModel?.requestId.toString() ?? "",
          style: StylesText.style18WhiteNomorl,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: onrefresh,
          child: Container(
            color: Theme.of(context).backgroundColor,
            width: Dimension.getWidth(1.0),
            height: Dimension.getHeight(1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(height: Dimension.getWidth(0.4), child: FeedbackItemChat(instanceRequestModel)),
                Expanded(
                  child: SafeArea(
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      child: lstTimeLine == null
                          ? Center(
                              child: SpinKitCircle(color: Colors.orange),
                            )
                          : lstTimeLine.length == 0
                              ? Center(
                                  child: Text(
                                    allTranslations.text("no_chat"),
                                    style: StylesText.style13Black,
                                  ),
                                )
                              : timelineModel(TimelinePosition.Left),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(height: 1.0),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // IconButton(
            //   onPressed: () {
            //     getImage();
            //   },
            //   icon: Icon(
            //     Icons.add_circle_outline,
            //     color: Colors.blue,
            //     size: 30,
            //   ),
            // ),
            SizedBox(
              width: 8,
            ),
            Flexible(
              child: TextField(
                autofocus: false,
                controller: _textController,
                onSubmitted: (va) async {
                  await _handleSubmitted();
                },
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: allTranslations.text("send_message_hint"),
                  hintStyle: StylesText.style13Blugray,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Opacity(
                    opacity: 1.0,
                    child: Icon(
                      Icons.send,
                      size: 25,
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    await _handleSubmitted();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future _handleSubmitted() async {
    try {
      if (await Validations.isConnectedNetwork()) {
        timestame_comment = DateTime.now().millisecondsSinceEpoch;
        TimeLineModel message = new TimeLineModel(
          cUserName: Configs.user?.fullName ?? "",
          time: ChangeTime.ChangeTimeStampToTime(timestame_comment.toDouble()/1000.0, true, false, false),
          content: _textController.text?.trim() ?? "",
          url_avt: Configs.user.url_avt,
          status: instanceRequestModel.statusCode,
          machineStatus: instanceRequestModel.machineStatusCode,
          icon: getIconStatusRequest(instanceRequestModel.statusCode ?? 0),
          iconBackground: getColorStatusRequest(instanceRequestModel.statusCode ?? 0),
        );
        if (await SendCommentRepository(instanceRequestModel.requestId, instanceRequestModel.statusCode,
                timestame_comment, instanceRequestModel.machineStatusCode, _textController.text.trim()) ==
            1) {
          setState(() {
            lstTimeLine.insert(0, message);
          });
        } else {
          return MessageDialog.showMsgDialog(context, allTranslations.text("notification"),
              allTranslations.text("send_message_fail"), AlertType.error);
        }
      } else {
        return Toast.show(allTranslations.text("netword_faile"), context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      }
    } catch (e,stackTrace) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in valdation isLogin');
      FlutterCrashlytics().logException(e, stackTrace);
    }
  }

  Future<void> onrefresh() async {
    try {
      await Future.delayed(const Duration(microseconds: 100));
      GetCommentsRepository(requestId: instanceRequestModel.requestId, wt: timestame_comment).then((value) {
        if (value != null) {
          comment = value;
          if (comment.length > 1) {
            comment.sort((a, b) => a.date.compareTo(b.date));
            comment.reversed;
          }
          timestame_comment = comment.first.date.toInt();
          for (RecieveCommentModel item in comment) {
            TimeLineModel timeLineModel = new TimeLineModel(
              name: item?.cUserName ?? "",
              content: item?.comment ?? "",
              machineStatus: item?.machineStatus,
              machineStatusName: item?.machineStatusName ?? "",
              cUserId: item?.cUserId,
              cUserName: item?.cUserName,
              url_avt: item?.url_avt ?? "",
              url: item?.url ?? "",
              requestId: item?.requestId,
              status: item?.status,
              statusName: item?.statusName ?? "",
              icon: getIconStatusRequest(item?.status ?? 0),
              iconBackground: getColorStatusRequest(item?.status ?? 0),
              time: ChangeTime.ChangeTimeStampToTime(item?.date ?? 0.0, true, false, false),
            );
            setState(() {
              lstTimeLine.insert(0, timeLineModel);
            });
          }
        }
      });
    } catch (e, stackTrace) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in refresh message page');
      FlutterCrashlytics().logException(e, stackTrace);
    }
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    try {
      if (await Validations.isConnectedNetwork()) {
        if ((Configs.user.roleID == "mainten" || Configs.user.roleID == "admin") &&
            instanceRequestModel.statusCode == 0) {
          timestame_comment = DateTime.now().millisecondsSinceEpoch;
          if (await SendCommentRepository(
                  instanceRequestModel.requestId, 1, timestame_comment, instanceRequestModel.machineStatusCode, "") ==
              1) {
            await initData();
          } else {
            return MessageDialog.showMsgDialog(context, allTranslations.text("notification"),
                allTranslations.text("send_message_fail"), AlertType.error);
          }
        } else {
          await initData();
        }
      } else {
        return Toast.show(allTranslations.text("netword_faile"), context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      }
    } catch (e, stackTrace) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData in message page');
      FlutterCrashlytics().logException(e, stackTrace);
    }
  }
}
