import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/user_model.dart';
import 'package:pika_maintenance/data/repository/get_user_info_repository.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';

import 'package:pika_maintenance/screens/user_screen/tab_thong_tin.dart';
import 'package:pika_maintenance/screens/user_screen/top_user_bar.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/uis/dialog/message_dialog.dart';
import 'package:pika_maintenance/utils/utils.dart';
import 'package:pika_maintenance/validations/validations.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with TickerProviderStateMixin, AfterLayoutMixin<UserPage> {
  AppBar appBar;
  UserModel user;
  List<Container> tabList = List();
  TabController _tabController;
  Future initData() async {
    try {
      await GetUserInfoRepository(Configs.idUser, Configs.tokenUser)
          .then((_) async {
        if (Configs.user == null ||
            Configs.user.fullName == null ||
            Configs.user.userName == null ||
            Configs.user.userCode == null) {
          Configs.user =
              await Configs.userDao.findUserById(int.tryParse(Configs.idUser));
        }
      });
    } catch (e) {
      FlutterCrashlytics().log(e.toString(), priority: 200, tag: 'Error in initData user page');
      FlutterCrashlytics().logException(e, e.stackTrace);
    }
  }

  @override
  void initState() {
    tabList.add(Container(
      height: Dimension.getHeight(0.04),
      
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Tab(
              text: "",
            ),
          ],
        ),
      
    ));
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onrefresh() {}

  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Container(
      height: heightScreen,
      width: widthScreen,
      child: Configs.user == null ||
              Configs.user.fullName == null ||
              Configs.user.userName == null ||
              Configs.user.userCode == null
          ? Center(child: SpinKitCircle(color: Colors.orange))
          : SizedBox(
              height: heightScreen,
              child: NestedScrollView(
                reverse: false,
                scrollDirection: Axis.vertical,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      pinned: true,
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      backgroundColor: Colors.orange,
                      expandedHeight: heightScreen / 3.8,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        centerTitle: true,
                        background: TopUserBar(
                            widthScreen: widthScreen,
                            heightScreen: heightScreen,
                            tabController: _tabController,
                            tabList: tabList),
                      ),
                      bottom: new TabBar(
                          labelStyle: StylesText.style16While,
                          labelColor: Colors.white,
                          controller: _tabController,
                          indicatorColor: Color.fromARGB(255, 11, 68, 125),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: tabList),
                    ),
                  ];
                },
                body: Container(
                  child: TabBarView(
                    controller: _tabController,
                    children: [TabThongTin(onrefresh)],
                  ),
                ),
              )),
    );
  }

  @override
  Future afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    await initData();
  }
}
