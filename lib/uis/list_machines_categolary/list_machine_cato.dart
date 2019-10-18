//import 'package:after_layout/after_layout.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:pika_maintenance/configs/configs.dart';
//import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
//import 'package:pika_maintenance/data/repository/get_machines_categolary_repository.dart';
//
//import 'package:pika_maintenance/styles/styles.dart';
//
//import 'package:pika_maintenance/utils/utils.dart';
//
//class ListMachinesCategolary extends StatefulWidget {
//  int currentIndex;
//  ListMachinesCategolary(this.currentIndex);
//  _List_Machine_Cato_State createState() => _List_Machine_Cato_State();
//}
//
//class _List_Machine_Cato_State extends State<ListMachinesCategolary>
//    with AfterLayoutMixin {
//  int currentIndexMachineCato;
//  List<MachineCategolaryModel> temp_machinecato;
//  @override
//  Future afterFirstLayout(BuildContext context) async {
//    await initData();
//  }
//
//  Future initData() async {
//    GetMachinesCategolaryRepository().then((valua) async {
//      if (valua != null) {
//        await Configs.machineCategolaryDao.deleteAllRow();
//        if (this.mounted) {
//          setState(() {
//            Configs.lst_machine_cata = valua;
//          });
//        }
//        await Configs.machineCategolaryDao.insertMachineCategolaryModels(valua);
//      } else {
//        temp_machinecato =
//            await Configs.machineCategolaryDao.findAllMachineCategolaryModel();
//        if (temp_machinecato == null || temp_machinecato.length == 0) {
//          setState(() {
//            Configs.lst_machine_cata = [];
//          });
//        } else {
//          if (this.mounted) {
//            setState(() {
//              Configs.lst_machine_cata = temp_machinecato;
//            });
//          }
//        }
//      }
//      MachineCategolaryModel all =
//          new MachineCategolaryModel(0, "All", "All", "", "", 0.0);
//      bool isHasAllItem = Configs.lst_machine_cata.contains(all);
//      if (isHasAllItem == false) {
//        setState(() {
//          Configs.lst_machine_cata.insert(0, all);
//        });
//      }
//    });
//  }
//
//  @override
//  void initState() {
//    currentIndexMachineCato = 0;
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: Dimension.getHeight(0.165),
//      width: Dimension.getWidth(1.0),
//      child: Configs.lst_machine_cata == null
//          ? Center(
//              child: SpinKitCircle(color: Colors.orange)(
//                strokeWidth: 1.5,
//                valueColor: AlwaysStoppedAnimation(Colors.orange),
//              ),
//            )
//          : Configs.lst_machine_cata.length == 0
//              ? Center(
//                  child: Text(
//                    "Không có thông tin loại máy",
//                    style: StylesText.style13Black,
//                  ),
//                )
//              : ListView.builder(
//                  scrollDirection: Axis.horizontal,
//                  shrinkWrap: true,
//                  physics: const ClampingScrollPhysics(),
//                  itemCount: Configs.lst_machine_cata == null ||
//                          Configs.lst_machine_cata.length == 0
//                      ? 0
//                      : Configs.lst_machine_cata.length,
//                  itemBuilder: (BuildContext context, int index) {
//                    return GestureDetector(
//                        child: Container(
//                            decoration: BoxDecoration(
//                                color: currentIndexMachineCato == index
//                                    ? Colors.orange
//                                    : Colors.brown,
//                                border: Border.all(
//                                    color: currentIndexMachineCato == index
//                                        ? Colors.red
//                                        : Colors.grey[300],
//                                    width: 2.0),
//                                borderRadius:
//                                    BorderRadius.all(Radius.circular(8.0))),
//                            margin: EdgeInsets.only(right: 12),
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Row(
//                                  children: <Widget>[
//                                    Stack(
//                                      alignment: AlignmentDirectional.topEnd,
//                                      children: <Widget>[
//                                        Padding(
//                                          padding: const EdgeInsets.fromLTRB(
//                                              0, 0, 0, 0),
//                                          child: Container(
//                                            height: Dimension.getHeight(0.12),
//                                            width: Dimension.getWidth(0.28),
//                                            decoration: new BoxDecoration(
//                                              borderRadius:
//                                                  BorderRadius.circular(8.0),
//                                              border: new Border.all(
//                                                  color: Colors.grey),
//                                            ),
//                                            child: ClipRRect(
//                                              borderRadius:
//                                                  BorderRadius.circular(8.0),
//                                              child: CachedNetworkImage(
//                                                imageUrl: Configs
//                                                                .lst_machine_cata[
//                                                                    index]
//                                                                .img_Url ==
//                                                            "" ||
//                                                        Configs
//                                                                .lst_machine_cata[
//                                                                    index]
//                                                                .img_Url ==
//                                                            null
//                                                    ? "https://library.kissclipart.com/20180830/kpq/kissclipart-machine-factory-icon-png-clipart-machine-factory-a-f479a7fc22bff4e5.jpg"
//                                                    : Unity.Replace_String(
//                                                        Configs
//                                                            .lst_machine_cata[
//                                                                index]
//                                                            .img_Url),
//                                                fit: BoxFit.fill,
//                                                placeholder: (context, url) =>
//                                                    new SizedBox(
//                                                  child: Center(
//                                                    child:
//                                                        SpinKitCircle(color: Colors.orange)(
//                                                      strokeWidth: 1.5,
//                                                      valueColor:
//                                                          new AlwaysStoppedAnimation(
//                                                              Colors.orange),
//                                                    ),
//                                                  ),
//                                                ),
//                                                errorWidget:
//                                                    (context, url, error) =>
//                                                        Icon(
//                                                  Icons.error,
//                                                  color: Colors.red,
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ],
//                                ),
//                                Padding(
//                                    padding:
//                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                                    child: Container(
//                                      width: Dimension.getWidth(0.28),
//                                      child: Row(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                        children: <Widget>[
//                                          Container(
//                                            width: Dimension.getWidth(0.28),
//                                            child: Text(
//                                              Configs
//                                                  .lst_machine_cata[index].name,
//                                              textAlign: TextAlign.center,
//                                              overflow: TextOverflow.ellipsis,
//                                              style: StylesText.style16While,
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    )),
//                              ],
//                            )),
//                        onTap: () async {
//                          await onHandleTap(index);
//                        });
//                  }),
//    );
//  }
//
//  Future onHandleTap(int index) async {
//    setState(() {
//      currentIndexMachineCato = index;
//      widget.currentIndex = index;
//    });
//  }
//}
