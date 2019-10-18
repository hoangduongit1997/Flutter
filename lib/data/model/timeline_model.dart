import 'package:flutter/material.dart';
import 'package:pika_maintenance/data/model/recieve_comment_model.dart';

class TimeLineModel extends RecieveCommentModel {
  String name;
  String time;
  String content;
  String doodle;
  Color iconBackground;
  Icon icon;

  TimeLineModel(
      {id,
      date,
      requestId,
      comment,
      cUserId,
      cUserName,
      machineStatus,
      machineStatusName,
      status,
      statusName,
      url,
      url_avt,
      this.name,
      this.time,
      this.content,
      this.doodle,
      this.icon,
      this.iconBackground})
      : super(
            id: id,
            date: date,
            requestId: requestId,
            comment: comment,
            cUserId: cUserId,
            cUserName: cUserName,
            machineStatus: machineStatus,
            machineStatusName: machineStatusName,
            status: status,
            statusName: statusName,
            url: url,
            url_avt: url_avt);
}
