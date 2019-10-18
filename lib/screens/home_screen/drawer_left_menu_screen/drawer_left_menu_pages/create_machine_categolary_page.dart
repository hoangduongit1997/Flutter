import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pika_maintenance/data/repository/create_machine_categolary_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/streams/create_lines_stream.dart';

import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class CreateMachineCategolaryPage extends StatefulWidget {
  _CreateMachineCategolaryPageState createState() => _CreateMachineCategolaryPageState();
}

class _CreateMachineCategolaryPageState extends State<CreateMachineCategolaryPage> {
  CreateLineStream create_lines_stream;
  TextEditingController name_cato;

  List<int> image_data = [];
  String image_base64 = "";
  List<Asset> images = List<Asset>();

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      addAutomaticKeepAlives: true,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 2.0,
      shrinkWrap: true,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: AssetThumb(
              quality: 100,
              asset: asset,
              width: (asset.originalWidth).toInt(),
              height: (asset.originalHeight).toInt(),
            ));
      }),
    );
  }

  Future<void> deleteAssets() async {
    if (this.mounted) {
      setState(() {
        images = [];
        image_data = [];
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
            selectionLimitReachedText: allTranslations.text("maximum_iamge"),
            actionBarTitleColor: "#18191a",
            actionBarColor: "#64a8ed",
            actionBarTitle: allTranslations.text("choose_image"),
            allViewTitle: allTranslations.text("all_image"),
            useDetailsView: true,
            selectCircleStrokeColor: "#edf0f2",
          ));
    } on PlatformException catch (e, stackTrace) {
      Toast.show(allTranslations.text("error"), context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error loadAssets in create machine categolary');
      FlutterCrashlytics().logException(e, stackTrace);
    }
    if (!mounted) return;
    //Convert image to byte then to String base64
    ByteData thumbData = await resultList[0].requestThumbnail(
      (resultList[0].originalWidth).toInt(),
      (resultList[0].originalHeight).toInt(),
      quality: 100,
    );
    image_data = thumbData.buffer.asUint8List();
    if (this.mounted) {
      setState(() {
        images = resultList;
      });
    }
    image_base64 = base64.encode(image_data);
  }

  @override
  void initState() {
    create_lines_stream = new CreateLineStream();
    name_cato = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    create_lines_stream.dispose();
    name_cato.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            allTranslations.text("add_new_cato"),
            style: StylesText.style16While,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: allTranslations.text("save_machine_catolary"),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
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
                        allTranslations.text("create_new_machine"),
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
                          onPressed: onCreate_New_Machine_Cato,
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
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                              errorText: snapshot.hasError ? snapshot.error : null,
                              errorStyle: StylesText.style10Red,
                              hintText: allTranslations.text("enter_machine_cato"),
                              hintStyle: StylesText.style13Blugray,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(children: <Widget>[
                      Container(
                        constraints: BoxConstraints.expand(
                          height: images.length == 0 ? 0 : MediaQuery.of(context).size.width * 0.8,
                          width: images.length == 0 ? 0 : MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: images.length == 0 ? Container() : buildGridView(),
                      ),
                      images.length > 0
                          ? Material(
                              borderRadius: BorderRadius.circular(30.0),
                              child: MaterialButton(
                                  color: Colors.redAccent,
                                  onPressed: deleteAssets,
                                  child: Text(allTranslations.text("delete_image"),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center)),
                            )
                          : Container(),
                    ])),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            width: Dimension.getWidth(1.0),
            height: Dimension.getHeight(0.08),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: FlatButton(
              onPressed: loadAssets,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    allTranslations.text("add_machine_cato_image"),
                    style:
                        TextStyle(color: Color.fromARGB(255, 75, 75, 75), fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  SvgPicture.asset("assets/icons/image.svg",
                      width: Dimension.getWidth(0.04), height: Dimension.getHeight(0.04))
                ],
              ),
            )));
  }

  Future onCreate_New_Machine_Cato() async {
    if (create_lines_stream.isValidInfo(name_cato.text.trim())) {
      if (await Validations.isConnectedNetwork() == true) {
        CreateMachineCategolaryRepository(name_cato.text.trim(), image_base64).then((value) {
          if (value == 1) {
            Navigator.of(context).pop(true);
            return Toast.show(allTranslations.text("add_success_machine_cato"), context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } else {
            Navigator.of(context).pop(false);
            return MessageDialog.showMsgDialog(
                context, allTranslations.text("notification"), allTranslations.text("error"), AlertType.error);
          }
        });
      } else {
        Navigator.of(context).pop(false);
        return MessageDialog.showMsgDialog(
            context, allTranslations.text("notification"), allTranslations.text("netword_faile"), AlertType.warning);
      }
    } else {
      return Navigator.of(context).pop();
    }
  }
}
