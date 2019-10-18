import 'package:pika_maintenance/configs/configs.dart';

class ReportInfoItem {
  String busStopName;
  FieldReport fieldReport;
  String image;
  ProcessingStatus processingStatus;
  String reportContent;
  String timeHasPassed;
  ReportInfoItem({
    this.fieldReport = FieldReport.App,
    this.timeHasPassed = "1",
    this.busStopName = "1",
    this.reportContent = "1",
    this.image = "1",
    this.processingStatus = ProcessingStatus.Processing,
  });
}
