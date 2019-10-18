import 'package:async/async.dart';
import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/cell_summary_model.dart';
import 'package:pika_maintenance/data/model/image_data_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/model/message_model.dart';
import 'package:pika_maintenance/data/model/user_model.dart';
import 'package:pika_maintenance/data/sqllite/cell_dao.dart';
import 'package:pika_maintenance/data/sqllite/line_dao.dart';
import 'package:pika_maintenance/data/sqllite/machine_categolary_dao.dart';
import 'package:pika_maintenance/data/sqllite/machine_dao.dart';
import 'package:pika_maintenance/data/sqllite/message_firebase_dao.dart';
import 'package:pika_maintenance/data/sqllite/user_dao.dart';

enum FieldReport {
  Bus,
  Driver,
  Station,
  App,
  Other,
}
enum ProcessingStatus {
  Processing,
  Finished,
  SpamReport,
}

enum TypeChat {
  Admin,
  User,
}

enum KindChat {
  Text,
  Image,
}

class Configs {
  static bool isDebugMode = false;
  static ImageDataModel imageDataModel;
  static List<int> image_machine = [];
  static String idUser = "";
  static String tokenUser = "";
  static UserModel user;
  static UserDao userDao;
  static LinesDao linesDao;
  static int numberNotification = 0;
  static CellDao cellDao;
  static List<CellModel> lstCell;
  static MachineDao machineDao;
  static String appId = "vn.pikatech.maintenance";
  static MachineCategolaryDao machineCategolaryDao;
  static List<LineModel> lstLine;
  static bool isTapEn = false;
  static String timeLogin = "";
  static List<MessageFirebaseModel> messages;
  static MessageFirebaseDao messageFirebaseDao;
  static bool isTapVn = true;
  static AsyncMemoizer<UserModel> memoizer_user = new AsyncMemoizer();
  static List<MachineCategolaryModel> lstMachineCata;
  static List<CellSummaryModel> lstMachineInCell; //gen gird cell
  static List<CellSummaryModel> lstMachineSelected =
      []; // tô màu border cell có loại máy trùng với loại máy đang nhấn vào
}
