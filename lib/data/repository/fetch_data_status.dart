import 'package:pika_maintenance/data/model/machine_status_model.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';

List<MachineStatusModel> listStatusMachine = [
  new MachineStatusModel(
    "0",
    allTranslations.text("status_machine_no_use"),
  ),
  new MachineStatusModel(
    "1",
    allTranslations.text("status_machine_running"),
  ),
  new MachineStatusModel(
    "2",
    allTranslations.text("status_machine_stop"),
  ),
  new MachineStatusModel(
    "3",
    allTranslations.text("status_machine_broken"),
  ),
  new MachineStatusModel(
    "4",
    allTranslations.text("status_machine_moving"),
    ),
];
