import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';

import 'package:pika_maintenance/data/repository/edit_machine_categolary_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/streams/create_lines_stream.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class EditMachineCategolaryPage extends StatefulWidget {
  MachineCategolaryModel machine_categorys;
  EditMachineCategolaryPage(this.machine_categorys);

  EditMachineCategolaryPageState createState() =>
      EditMachineCategolaryPageState();
}

class EditMachineCategolaryPageState extends State<EditMachineCategolaryPage> {
  List<Asset> images = List<Asset>();
  CreateLineStream create_lines_stream;
  TextEditingController name_cato;
  List<int> image_data = [];
  String base64Image = "";
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      addAutomaticKeepAlives: true,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 2.0,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: AssetThumb(
            quality: 100,
            asset: asset,
            width: asset.originalWidth,
            height: asset.originalWidth,
          ),
        );
      }),
    );
  }

  Future<void> deleteAssets() async {
    if (this.mounted) {
      setState(() {
        images = [];
      });
    }
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
    } on PlatformException catch (e, stacktrace) {
      print(e.toString());
//      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error');
//      FlutterCrashlytics().logException(e, stacktrace);
    }
    if (!mounted) return;
    //Convert image to byte then to base64
    ByteData thumbData = await resultList[0].requestThumbnail(
      (resultList[0].originalWidth * 0.8).toInt(),
      (resultList[0].originalWidth * 0.8).toInt(),
      quality: 100,
    );
    image_data = thumbData.buffer.asUint8List();
    base64Image = base64Encode(image_data);
    setState(() {
      images = resultList;
    });
  }

  @override
  void initState() {
    create_lines_stream = new CreateLineStream();
    name_cato = new TextEditingController(
        text: widget.machine_categorys.code == null ||
                widget.machine_categorys.code.length == 0
            ? ""
            : widget.machine_categorys.code);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.machine_categorys.code == null ||
                    widget.machine_categorys.code == ""
                ? "Sửa loại máy"
                : "Sửa loại máy " + widget.machine_categorys.code,
            style: StylesText.style16While,
            textAlign: TextAlign.center,
          ),
          leading: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: <Widget>[
            Container(
              width: Dimension.getWidth(0.15),
              child: FlatButton(
                  onPressed: () {
                    Alert(
                      context: context,
                      title: allTranslations.text("notification"),
                      content: Text(
                        allTranslations.text("save_change_alert"),
                        style: StylesText.style13Black,
                        textAlign: TextAlign.center,
                      ),
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
                          onPressed: onEditMachine_Cato,
                          color: Colors.orange,
                        )
                      ],
                    ).show();
                  },
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 25,
                  )),
            )
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Theme.of(context).backgroundColor,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: Dimension.getHeight(0.1),
                    child: StreamBuilder<Object>(
                        stream: create_lines_stream.titleStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: name_cato,
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              errorStyle: StylesText.style10Red,
                              hintText: "Nhập tên loại máy",
                              hintStyle: StylesText.style13Blugray,
                              border: new OutlineInputBorder(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: widget.machine_categorys.img_Url == null ||
                          widget.machine_categorys.img_Url.length == 0
                      ? Container()
                      : Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Ảnh hiện tại",
                                    style: StylesText.style13BlackBold)
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Container(
                                  height: Dimension.getHeight(0.3),
                                  width: Dimension.getHeight(0.3),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    child: CachedNetworkImage(
                                      imageUrl: Unity.Replace_String(
                                          widget.machine_categorys.img_Url),
                                      fadeOutDuration:
                                          Duration(milliseconds: 700),
                                      fit: BoxFit.cover,
                                      fadeInDuration:
                                          Duration(milliseconds: 700),
                                      placeholder: (context, url) =>
                                          new SizedBox(
                                        child: Center(
                                          child: SpinKitCircle(color: Colors.orange)
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  images.length > 0
                                      ? Container(
                                          child: Text(
                                          "Ảnh thêm mới (Xóa ảnh hiện tại)",
                                          style: StylesText.style13BlackBold,
                                        ))
                                      : Container(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Container(
                                  constraints: BoxConstraints.expand(
                                    height: images.length == 0
                                        ? 0
                                        : Dimension.getHeight(0.3),
                                    width: images.length == 0
                                        ? 0
                                        : Dimension.getHeight(0.3),
                                  ),
                                  child: buildGridView(),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: images.length > 0
                            ? Material(
                                borderRadius: BorderRadius.circular(30.0),
                                child: MaterialButton(
                                    color: Colors.redAccent,
                                    onPressed: deleteAssets,
                                    child: Text("Xóa hình",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center)),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            width: Dimension.getWidth(1.0),
            height: Dimension.getHeight(0.08),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: FlatButton(
              onPressed: loadAssets,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Thêm hình ảnh',
                    style: TextStyle(
                        color: Color.fromARGB(255, 75, 75, 75),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SvgPicture.asset("assets/icons/image.svg",
                      width: Dimension.getWidth(0.04),
                      height: Dimension.getHeight(0.04))
                ],
              ),
            )));
  }

  Future onEditMachine_Cato() async {
    if (create_lines_stream.isValidInfo(name_cato.text.trim())) {
      if (await Validations.isConnectedNetwork() == true) {
        if (await EditMachineCategolaryRepository(name_cato.text.trim(),
                widget.machine_categorys.id, base64Image) ==
            1) {
          Navigator.of(context).pop(true);
          return Toast.show("Sửa thành công!", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
      return Navigator.of(context).pop(false);
    }
  }
}
