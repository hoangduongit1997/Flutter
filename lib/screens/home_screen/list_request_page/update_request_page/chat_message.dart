import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/status_text/status_text.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.machineStatus,
      this.requestStatus,
      this.colorsMachineStatus,
      this.colorsRequstStatus,
      this.typeChat = TypeChat.User,
      this.kindChat = KindChat.Text,
      this.name,
      this.fileChat,
      this.text,
      this.animationController,
      this.timecomment,
      this.fileChat2,
      this.avatar});
  final TypeChat typeChat;
  final KindChat kindChat;
  final File fileChat;
  final String text;
  final String avatar;
  final String name;
  final String machineStatus;
  final Color colorsMachineStatus;
  final Color colorsRequstStatus;
  final String requestStatus;
  final AnimationController animationController;
  final String timecomment;
  final Uint8List fileChat2;
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        color: Theme.of(context).backgroundColor,
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            typeChat == TypeChat.User
                ? SizedBox(
                    width: deviceWidth / 7,
                  )
                : Container(),
            typeChat == TypeChat.User && (fileChat == null || fileChat2 == null)
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(
                                14.0,
                              ),
                            ),
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Linkify(
                              onOpen: (link) async {
                                await _launchURL(link.url);
                              },
                              text: text ?? '',
                              style: StylesText.style13Black,
                              linkStyle: StylesText.style13Url,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            StatusText(
                              statusReport: machineStatus,
                              colorReport: colorsMachineStatus,
                            ),
                            new StatusText(
                              statusReport: requestStatus,
                              colorReport: colorsRequstStatus,
                            ),
                          ],
                        ),
                        Text(
                            timecomment ??
                                ChangeTime.ChangeTimeStampToTime(
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toDouble(),
                                    true,
                                    false,
                                    false),
                            style: StylesText.style12Gray),
                      ],
                    ),
                  )
                : Container(),
            typeChat == TypeChat.User && (fileChat != null || fileChat2 != null)
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(
                              14.0,
                            ),
                          ),
                          margin: const EdgeInsets.only(top: 5.0),
                          child: fileChat2 == null
                              ? Image.file(fileChat)
                              : Image.memory(fileChat2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            StatusText(
                              statusReport: machineStatus,
                              colorReport: colorsMachineStatus,
                            ),
                            new StatusText(
                              statusReport: requestStatus,
                              colorReport: colorsRequstStatus,
                            ),
                          ],
                        ),
                        Text(
                            timecomment ??
                                ChangeTime.ChangeTimeStampToTime(
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toDouble(),
                                    true,
                                    false,
                                    false),
                            style: StylesText.style12Gray),
                      ],
                    ),
                  )
                : Container(),
            typeChat == TypeChat.Admin && avatar != null
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CachedNetworkImage(
                              fadeOutDuration: Duration(milliseconds: 700),
                              imageUrl: avatar,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: Dimension.getWidth(0.1),
                                height: Dimension.getWidth(0.1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain),
                                ),
                              ),
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              fadeInDuration: Duration(milliseconds: 700),
                              placeholder: (context, url) => new SizedBox(
                                child: Center(
                                  child: SpinKitCircle(color: Colors.orange)
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                  child: Text(
                                name ?? "",
                                style: StylesText.style12RedItalicBold,
                              )),
                            )
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(
                                14.0,
                              ),
                            ),
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Linkify(
                              onOpen: (link) async {
                                await _launchURL(link.url);
                              },
                              text: text ?? '',
                              style: StylesText.style13Black,
                              linkStyle: StylesText.style13Url,
                            )),
                        Text(
                            timecomment ??
                                ChangeTime.ChangeTimeStampToTime(
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toDouble(),
                                    true,
                                    false,
                                    false),
                            style: StylesText.style12Gray),
                      ],
                    ),
                  )
                : Container(),
            typeChat == TypeChat.Admin && avatar == null
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipOval(
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                  child: Text(
                                name ?? "",
                                style: StylesText.style15BlackItalic,
                              )),
                            )
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(
                                14.0,
                              ),
                            ),
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Linkify(
                              onOpen: (link) async {
                                await _launchURL(link.url);
                              },
                              text: text ?? '',
                              style: StylesText.style13Black,
                              linkStyle: StylesText.style13Url,
                            )),
                            Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            StatusText(
                              statusReport: machineStatus,
                              colorReport: colorsMachineStatus,
                            ),
                            new StatusText(
                              statusReport: requestStatus,
                              colorReport: colorsRequstStatus,
                            ),
                          ],
                        ),
                        Text(
                            timecomment ??
                                ChangeTime.ChangeTimeStampToTime(
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toDouble(),
                                    true,
                                    false,
                                    false),
                            style: StylesText.style12Gray),
                      ],
                    ),
                  )
                : Container(),
            typeChat == TypeChat.Admin
                ? SizedBox(
                    width: deviceWidth / 7,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
