//
//
//import 'package:after_layout/after_layout.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:pika_maintenance/data/model/machine_timeline_model.dart';
//import 'package:pika_maintenance/styles/styles.dart';
//import 'package:pika_maintenance/utils/utils.dart';
//
//class BlockTimeLine extends StatefulWidget {
//  List<Activity> lstActivity;
//  BlockTimeLine({this.lstActivity});
//
//  @override
//  _BlockTimeLineState createState() => _BlockTimeLineState();
//}
//
//class _BlockTimeLineState extends State<BlockTimeLine>
//    with AfterLayoutMixin, AutomaticKeepAliveClientMixin<BlockTimeLine> {
//  List<Step> lstStep;
//  @override
//  void initState() {
//    lstStep = new List();
//    super.initState();
//  }
//
//  void initListStep() {
//    if (widget.lstActivity == null || widget.lstActivity.length == 0) {
//      return;
//    } else {
//      widget.lstActivity.sort((a,b)=>a.checkinTime.compareTo(b.checkinTime));
//      for (var item in widget.lstActivity) {
//        if (!mounted) return;
//        setState(() {
//          lstStep.add(new Step(
//            title: Container(
//              width: Dimension.getWidth(0.72),
//              child: Text(
//                ChangeTime.ChangeTimeStampToTime(
//                    item.checkinTime.toDouble()/1000.0, true, false, false),
//                style: StylesText.style13BlackBold,
//              ),
//            ),
//            subtitle: Container(
//              width: Dimension.getWidth(0.72),
//              child: Text(
//                item.eventName,
//                textAlign: TextAlign.left,
//                style: StylesText.style13Black,
//              ),
//            ),
//            content:  Container(),
//            isActive: true,
//            state: StepState.indexed,
//          ));
//        });
//      }
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    super.build(context);
//    return lstStep.length == 0
//        ? Center(
//            child: SpinKitCircle(color: Colors.orange),
//          )
//        : Stepper(
//       physics: AlwaysScrollableScrollPhysics(),
//            type: StepperType.vertical,
//            steps: lstStep,
//            controlsBuilder: (BuildContext context,
//                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
//                Container(),
//          );
//  }
//
//  @override
//  void afterFirstLayout(BuildContext context) {
//    initListStep();
//  }
//
//  @override
//  bool get wantKeepAlive => true;
//}
