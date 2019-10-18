import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/machine_in_cell_model.dart';
import 'package:pika_maintenance/data/model/machine_model.dart';
import 'package:pika_maintenance/data/model/user_model.dart';
import 'package:pika_maintenance/screens/home_screen/machine_information/machine/machine_info.dart';
import 'package:pika_maintenance/screens/home_screen/machine_information/machine/machine_log.dart';
import 'package:pika_maintenance/screens/home_screen/machine_information/machine/top_machine_bar.dart';
import 'package:pika_maintenance/styles/styles.dart';
import 'package:pika_maintenance/utils/utils.dart';

class PageMachine extends StatefulWidget {
  MachineInCellModel machine;
  PageMachine(this.machine);

  @override
  _PageMachineState createState() => _PageMachineState();
}

class _PageMachineState extends State<PageMachine> with TickerProviderStateMixin<PageMachine> {
  List<Container> tabList = List();
  TabController _tabController;
  @override
  void initState() {
    tabList.add(Container(
      height: Dimension.getHeight(0.04),
      child: Tab(
        text: 'THÔNG TIN',
      ),
    ));
    tabList.add(Container(
      height: Dimension.getHeight(0.04),
      child: Tab(
        text: 'NHẬT KÝ',
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



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimension.getHeight(0.125)),
        child: AppBar(
          title: Text(
            "Thông tin máy " + widget.machine?.machineCode ?? "",
            style: StylesText.style16While,
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.orange,
          bottom: new TabBar(
              labelStyle: StylesText.style16While,
              labelColor: Colors.white,
              controller: _tabController,
              indicatorColor: Color.fromARGB(255, 234, 95, 93),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: tabList),
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: [TabMachineInfo( widget.machine), TabMachineLog(widget.machine)],
        ),
      ),
    );
  }
}
