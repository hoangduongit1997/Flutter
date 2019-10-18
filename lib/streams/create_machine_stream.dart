import 'dart:async';

import 'package:pika_maintenance/validations/validations.dart';

class CreateMachineStream {
  StreamController _machineCatologcontroller = new StreamController.broadcast();
  StreamController _machinePositioncontroller =
      new StreamController.broadcast();
  StreamController _machineNamecontroller = new StreamController.broadcast();
  Stream get titleStream => _machineCatologcontroller.stream;
  Stream get positionStream => _machinePositioncontroller.stream;
  Stream get nameStream => _machineNamecontroller.stream;
  bool isValidInfo(String machine_Catolog,String machine_position, String machine_name ) {
    bool status = true;
    if (!Validations.IsValidTitle(machine_Catolog)) {
      status = false;
      _machineCatologcontroller.sink.addError("Loại máy không được trống");
    }
    if (Validations.IsValidTitle(machine_Catolog)) {
      _machineCatologcontroller.sink.add("OK");
    }

     if (!Validations.IsValidTitle(machine_position)) {
      status = false;
      _machinePositioncontroller.sink.addError("Ví trí máy không được trống");
    }
    if (Validations.IsValidTitle(machine_position)) {
      _machinePositioncontroller.sink.add("OK");
    }

     if (!Validations.IsValidTitle(machine_name)) {
      status = false;
      _machineNamecontroller.sink.addError("Tên máy máy không được trống");
    }
    if (Validations.IsValidTitle(machine_name)) {
      _machineNamecontroller.sink.add("OK");
    }
    return status;
  }

  void dispose() {
    _machineCatologcontroller.close();
    _machineNamecontroller.close();
    _machinePositioncontroller.close();
  }
}
