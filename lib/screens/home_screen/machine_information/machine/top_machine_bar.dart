
import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/image_data_model.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';

class TopMachineBar extends StatelessWidget {
  const TopMachineBar({
    @required this.widthScreen,
    @required this.heightScreen,
    @required TabController tabController,
    @required this.tabList,
  }) : _tabController = tabController;

  final double widthScreen;
  final double heightScreen;
  final TabController _tabController;
  final List<Container> tabList;

  @override
  Widget build(BuildContext context) {
    return TopMachineBarPage(widthScreen, heightScreen, _tabController, tabList);
  }
}

class TopMachineBarPage extends StatefulWidget {
  final double widthScreen;
  final double heightScreen;
  final TabController _tabController;
  final List<Container> tabList;
  TopMachineBarPage(
      this.widthScreen, this.heightScreen, this._tabController, this.tabList);
  @override
  State<StatefulWidget> createState() {
    return TopMachineBarPageState();
  }
}

class TopMachineBarPageState extends State<TopMachineBarPage>
    with AutomaticKeepAliveClientMixin<TopMachineBarPage> {
  List<Asset> images = List<Asset>();
  bool ischange_avatar;
  @override
  void initState() {
    super.initState();
    ischange_avatar = false;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            startInAllView: true,
            selectionLimitReachedText: "Tối đa được một hình",
            actionBarTitleColor: "#18191a",
            actionBarColor: "#64a8ed",
            actionBarTitle: "Chọn hình",
            allViewTitle: "Tất cả hình",
            selectCircleStrokeColor: "#edf0f2",
          ));
      if (!mounted) return;
      setState(() {
        images = resultList;
      });
      if (images.length > 0) {
        //Convert image to byte
        ByteData thumbData = await resultList[0].requestThumbnail(
          Dimension.getWidth(0.7).toInt(),
          Dimension.getWidth(0.7).toInt(),
          quality: 60,
        );

        if (!mounted) return;
        setState(() {
          ischange_avatar = true;
          Configs.image_machine = thumbData.buffer.asUint8List();
        });
        Configs.imageDataModel = new ImageDataModel();
        Configs.imageDataModel.fileData = base64.encode(Configs.image_machine);
        List<String> tempDataImage = images.first.name.split('.');
        Configs.imageDataModel.fileExtention = "." + tempDataImage.last;
      }
    } catch (e) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(),
          priority: 200, tag: 'Error in loadAssets in top user bar');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.orange),
          width: widget.widthScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0, 0),
                      width: widget.widthScreen / 5.0,
                      height: widget.widthScreen / 5.0,
                      child: GestureDetector(
                        onTap: () {
                          // loadAssets();
                        },
                        // child: ischange_avatar == false
                        //     ? CachedNetworkImage(
                        //         fadeOutDuration: Duration(milliseconds: 700),
                        //         imageUrl:
                        //             "http://www.thanhdoan.hochiminhcity.gov.vn/ThanhDoan/webtd/Content/news/2017/2/27576/Huy%20hieu%20Doan.png",
                        //         imageBuilder: (context, imageProvider) =>
                        //             Container(
                        //           width: Dimension.getWidth(0.1),
                        //           height: Dimension.getWidth(0.1),
                        //           decoration: BoxDecoration(
                        //             shape: BoxShape.circle,
                        //             image: DecorationImage(
                        //                 image: imageProvider,
                        //                 fit: BoxFit.contain),
                        //           ),
                        //         ),
                        //         alignment: Alignment.center,
                        //         fit: BoxFit.contain,
                        //         fadeInDuration: Duration(milliseconds: 700),
                        //         placeholder: (context, url) => new SizedBox(
                        //           child: Center(
                        //             child: SpinKitCircle(color: Colors.orange)(
                        //               strokeWidth: 1.0,
                        //               valueColor: new AlwaysStoppedAnimation(
                        //                   Colors.orange),
                        //             ),
                        //           ),
                        //         ),
                        //         errorWidget: (context, url, error) => Icon(
                        //           Icons.error,
                        //           color: Colors.red,
                        //         ),
                        //       )
                        //     :
                        child: CircleAvatar(
                          child: ClipOval(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              child: Container(
                                color: Colors.white,
                                child: Image.asset(
                                  "assets/images/login.png",
                                  width: widget.widthScreen / 4,
                                  height: widget.widthScreen / 4,
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          backgroundColor: Colors.transparent,
                          ),
                        )),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: IconButton(
                  //     icon: Icon(Icons.add_to_home_screen, color: Colors.white),
                  //     alignment: Alignment.center,
                  //     onPressed: () {
                  //       showDialog(
                  //           context: context,
                  //           barrierDismissible: true,
                  //           builder: (BuildContext context) {
                  //             return AlertDialog(
                  //               shape: RoundedRectangleBorder(
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(8.0))),
                  //               content: new Text(
                  //                 "Bạn có muốn đăng xuất không ?",
                  //                 style: StylesText.style16BlackNormal,
                  //               ),
                  //               actions: <Widget>[
                  //                 FlatButton(
                  //                   child: Text(
                  //                     "Không",
                  //                     style: StylesText.style16BlackNormal,
                  //                   ),
                  //                   onPressed: () async {
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                 ),
                  //                 FlatButton(
                  //                   child: Container(
                  //                     child: Center(
                  //                         child: Text(
                  //                       "Có",
                  //                       style: StylesText.style16BlackNormal,
                  //                     )),
                  //                   ),
                  //                   onPressed: () async {
                  //                     SharedPreferences preferences =
                  //                         await SharedPreferences.getInstance();
                  //                     preferences.clear();

                  //                     Navigator.of(context).pop();
                  //                     Navigator.of(context).pushReplacement(
                  //                         CupertinoPageRoute(
                  //                             builder: (context) => Login()));
                  //                   },
                  //                 ),
                  //               ],
                  //             );
                  //           });
                  //     },
                  //   ),
                  // )
                ],
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                        Configs.user != null || Configs.user.fullName != null
                            ? Configs.user.fullName
                            : "USERNAME",
                        style: StylesText.style18WhiteBold),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          Configs.user != null || Configs.user.roleName != null
                              ? Configs.user.roleName
                              : "POSITION",
                          style: StylesText.style14BlueBold),
                      ),
                  ],
                  ),
                ),
            ],
            ),
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
