import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/cell_summary_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';
import 'package:pika_maintenance/data/repository/get_cell_sumarry_respository.dart';
import 'package:pika_maintenance/data/repository/get_line_has_machine_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/drawer_left_menu_screen/drawer_left_menu_pages/draw_left_menu_page.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/draw_line/drawline.dart';
import 'package:pika_maintenance/uis/gird_cell/gird_cell.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';
import 'package:toast/toast.dart';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> with SingleTickerProviderStateMixin, AfterLayoutMixin {
  List<LineModel> lstLineHasMachine;
  int currentMachineCatoIndex;

//  int currentLineIndex;
  bool changeing;
  // Future initData() async {
  //   List<LineModel> temp;
  //   try {
  //     if (await Validations.isConnectedNetwork() == true) {
  //       await Future.wait([
  //         //get machine_catalo, chưa lưu vào sqllite
  //         GetMachinesCategolaryRepository().then((valua) {
  //           if (valua != null) {
  //             if (this.mounted) {
  //               setState(() {
  //                 Configs.lst_machine_cata = valua;
  //               });
  //             }
  //           }
  //         }),
  //         //get line
  //         GetLinesRepository().then((value) async {
  //           if (value != null) {
  //             await Configs.linesDao.deleteAllRow();

  //             if (this.mounted) {
  //               setState(() {
  //                 Configs.lst_line = value;
  //               });
  //             }
  //             await Configs.linesDao.insertLiness(Configs.lst_line);
  //           } else {
  //             temp = await Configs.linesDao.findAllLiness();
  //             if (this.mounted) {
  //               setState(() {
  //                 Configs.lst_line = temp;
  //               });
  //             }
  //           }
  //         })
  //       ]);
  //     } else {
  //       temp = await Configs.linesDao.findAllLiness();
  //       if (temp != null || temp.length > 0) {
  //         if (this.mounted) {
  //           setState(() {
  //             Configs.lst_line = temp;
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           Configs.lst_line = [];
  //         });

  //         return;
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       Configs.lst_line = [];
  //     });

  //     return;
  //   }
  // }
  Future initDataLineHasMachine() async {
    try {
      GetLinesHasMachineRepository().then((va) async {
        final lsttemp = va;
        if (lsttemp == null || lsttemp.length == 0) {
          final temp_line = await Configs.linesDao.findAllLiness();
          if (temp_line == null || temp_line.length == 0) {
            setState(() {
              lstLineHasMachine = [];
            });
          } else {
            if (this.mounted) {
              setState(() {
                lstLineHasMachine = temp_line;
              });
            }
          }
        } else {
          if (this.mounted) {
            setState(() {
              lstLineHasMachine = lsttemp;
            });
          }
          await Configs.linesDao.deleteAllRow();
          await Configs.linesDao.insertLiness(lsttemp);
        }
      });
    } catch (e) {
      print(e.toString());
      FlutterCrashlytics().log(e.toString(),
          priority: 200,
          tag: 'Error in initDataLineHasMachine'
              ' in new feed page');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  @override
  void initState() {
    currentMachineCatoIndex = 0;
    changeing = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return lstLineHasMachine == null
        ? Container(
            width: Dimension.getWidth(1.0),
            height: Dimension.getHeight(1.0),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: SpinKitCircle(color: Colors.orange),
            ),
          )
        : lstLineHasMachine.length == 0 ? renderNoData() : renderHasData();
  }

  Widget renderNoData() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("PIKA MAINTENANCE", style: StylesText.style18WhiteBold),
        leading: IconButton(
          tooltip: "Menu trái",
          icon: Icon(
            Icons.menu,
            size: 25,
            color: Colors.white,
          ),
          onPressed: () {
            Unity.openDrawer(context);
          },
        ),
      ),
      body: Container(
        width: Dimension.getWidth(1.0),
        height: Dimension.getHeight(1.0),
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: Text(
            "Không có thông tin Line",
            style: StylesText.style15Black,
          ),
        ),
      ),
      drawer: Drawer(
        child: DrawerMenuPage(),
      ),
    );
  }

  Widget renderHasData() {
    return DefaultTabController(
      length: lstLineHasMachine == null || lstLineHasMachine.length == 0 ? 0 : lstLineHasMachine.length,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Dimension.getHeight(0.14)),
              child: AppBar(
                title: Text("PIKA MAINTENANCE", style: StylesText.style18WhiteBold),
                leading: IconButton(
                  tooltip: "Menu trái",
                  icon: Icon(
                    Icons.menu,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Unity.openDrawer(context);
                  },
                ),
                bottom: TabBar(
                  indicatorColor: Colors.blue,
                  indicatorWeight: 2.0,
                  labelStyle: StylesText.style15Black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  isScrollable: true,
                  tabs: List<Widget>.generate(
                      lstLineHasMachine == null || lstLineHasMachine.length == 0 ? 0 : lstLineHasMachine.length,
                      (int index) {
                    return new Tab(
                        child: Text(lstLineHasMachine == null ||
                                lstLineHasMachine.length == 0 ||
                                lstLineHasMachine[index].code == null
                            ? ""
                            : lstLineHasMachine[index].code.toString()));
                  }),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Divider(
                              color: Colors.grey,
                            ),
                            Container(
                                height: Dimension.getWidth(0.25),
                                width: Dimension.getWidth(1.0),
                                child: Center(child: renderListMachine(context))),
                            Divider(
                              color: Colors.grey,
                            ),
                          ],
                        )),
                    Expanded(
                      child: TabBarView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: List<Widget>.generate(
                            lstLineHasMachine == null || lstLineHasMachine.length == 0 ? 0 : lstLineHasMachine.length,
                            (int index) {
                          return lstLineHasMachine == null ||
                                  Configs.lstMachineCata == null ||
                                  lstLineHasMachine.length == 0 ||
                                  Configs.lstMachineCata.length == 0
                              ? Container()
                              : GirdCell(
                                  lineId: lstLineHasMachine[index].lineId,
                                  machineCategolaryModel: Configs.lstMachineCata[currentMachineCatoIndex],
                                );
                        }),
                      ),
                    ),
                  ],
                ),
                renderLoading(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget renderLoading() {
    return Container(
      color: changeing ? Colors.black12 : Colors.transparent,
      child: Visibility(visible: changeing ? true : false, child: SpinKitCircle(color: Colors.orange)),
    );
  }

  Widget renderListMachine(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Configs.lstMachineCata == null
          ? Center(
              child: SpinKitCircle(
                color: Colors.orange,
                size: 25,
              ),
            )
          : Configs.lstMachineCata.length == 0
              ? Center(
                  child: Text(
                    allTranslations.text("no_machine_cato"),
                    style: StylesText.style13Black,
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: Configs.lstMachineCata == null || Configs.lstMachineCata.length == 0
                      ? 0
                      : Configs.lstMachineCata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        child: Container(
                            decoration: BoxDecoration(
                                color: currentMachineCatoIndex == index
                                    ? Colors.orange[400]
                                    : Color.fromARGB(255, 40, 115, 161),
                                border: Border.all(
                                    color: currentMachineCatoIndex == index
                                        ? Colors.orange
                                        : Color.fromARGB(255, 40, 115, 161),
                                    width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(8.0))),
                            margin: EdgeInsets.only(right: 12),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: Dimension.getWidth(0.18),
                                  width: Dimension.getWidth(0.28),
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: Configs.lstMachineCata[index].img_Url == "" ||
                                              Configs.lstMachineCata[index].img_Url == null
                                          ? "https://library.kissclipart.com/20180830/kpq/kissclipart-machine-factory-icon-png-clipart-machine-factory-a-f479a7fc22bff4e5.jpg"
                                          : Unity.Replace_String(Configs.lstMachineCata[index].img_Url),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => new SizedBox(
                                        child: Center(child: SpinKitCircle(color: Colors.orange)),
                                      ),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.image,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FittedBox(
                                        child: Text(
                                          Configs.lstMachineCata[index].name,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: StylesText.style16While,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        onTap: () async {
                          await handelTap(index, context);
                        });
                  }),
    );
  }

  Future handelTap(int index, BuildContext context) async {
    try {
      if (!mounted) return;
      setState(() {
        currentMachineCatoIndex = index;
        changeing = true;
        Configs.lstMachineInCell.forEach((t) {
          t.selected = false;
        });
      });
      if (currentMachineCatoIndex == 0) {
        if (!mounted) return;
        setState(() {
          changeing = false;
        });
        return;
      } else {
        if (await Validations.isConnectedNetwork() == true) {
          GetCellSumarryRepository(
                  lineId: lstLineHasMachine[DefaultTabController.of(context).index].lineId,
                  cateId: Configs.lstMachineCata[index].id,
                  wt: 0)
              .then((va) async {
            Configs.lstMachineSelected = va;
            if (Configs.lstMachineSelected != null) {
              if (Configs.lstMachineSelected.length == 0) {
                Configs.lstMachineInCell.forEach((t) => t.selected = false);
                if (!mounted) return;
                setState(() {
                  changeing = false;
                });
                return;
              } else {
                await handelSelectedCell(Configs.lstMachineSelected, context);
              }
            } else {
              Configs.lstMachineInCell.forEach((t) => t.selected = false);
              if (!mounted) return;
              setState(() {
                changeing = false;
              });
              return;
            }
          });
        } else {
          setState(() {
            changeing = false;
          });
          return Toast.show(allTranslations.text("netword_faile"), context,
              gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
        }
      }
    } catch (e) {
      setState(() {
        changeing = false;
      });
      FlutterCrashlytics().log(e.toString(),
          priority: 200,
          tag: 'Error in handelTap new feed '
              'page');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  Future handelSelectedCell(List<CellSummaryModel> lstMachineSelected, BuildContext context) async {
    for (int i = 0; i < lstMachineSelected.length; i++) {
      int index = Configs.lstMachineInCell.indexOf(
          Configs.lstMachineInCell.firstWhere((t) => t.code == lstMachineSelected[i].code, orElse: () => null));
      if (index != null) {
        if (!mounted) return;
        setState(() {
          Configs.lstMachineInCell[index].selected = true;
        });
      } else {
        break;
      }
    }
    if (!mounted) return;
    setState(() {
      changeing = false;
    });
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    await initDataLineHasMachine();
  }
}
