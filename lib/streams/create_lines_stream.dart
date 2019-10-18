import 'dart:async';

import 'package:pika_maintenance/validations/validations.dart';

class CreateLineStream {
  StreamController _titlecontroller = new StreamController.broadcast();

  Stream get titleStream => _titlecontroller.stream;

  bool isValidInfo(String title) {
    bool status = true;
    if (!Validations.IsValidTitle(title)) {
      status = false;
      _titlecontroller.sink.addError("Tên line không được trống");
    }
    if (Validations.IsValidTitle(title)) {
      _titlecontroller.sink.add("OK");
    }

    return status;
  }

  void dispose() {
    _titlecontroller.close();
  }
}
