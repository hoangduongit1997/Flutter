import 'dart:async';

import 'package:pika_maintenance/configs/configs.dart';
import 'package:pika_maintenance/data/model/cell_summary_model.dart';

class CheckCellStream {
  StreamController _checkCellController = new StreamController.broadcast();

  Stream get checkCellStream => _checkCellController.stream;

  bool isValidCell(String codeCelll, List<CellSummaryModel> lstcell) {
    bool status = false;
    lstcell.forEach((t) {
      if (t.code == codeCelll) {
        status = true;
        return;
      }
    });
    if (status == false) {
      _checkCellController.sink.addError("Cell không tồn tại");
    } else {
      _checkCellController.sink.add("OK");
    }
    return status;
  }

  void dispose() {
    _checkCellController.close();
  }
}
