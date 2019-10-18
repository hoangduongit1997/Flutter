import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:pika_maintenance/data/model/cell_model.dart';
import 'package:pika_maintenance/data/model/line_model.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';
import 'package:pika_maintenance/data/model/machine_model.dart';
import 'package:pika_maintenance/data/model/message_model.dart';
import 'package:pika_maintenance/data/model/user_model.dart';
import 'package:pika_maintenance/data/sqllite/cell_dao.dart';
import 'package:pika_maintenance/data/sqllite/line_dao.dart';
import 'package:pika_maintenance/data/sqllite/machine_categolary_dao.dart';
import 'package:pika_maintenance/data/sqllite/machine_dao.dart';
import 'package:pika_maintenance/data/sqllite/message_firebase_dao.dart';
import 'package:pika_maintenance/data/sqllite/user_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
part 'database.g.dart';

@Database(version: 1, entities: [
  UserModel,
  LineModel,
  CellModel,
  MachineModel,
  MachineCategolaryModel,
  MessageFirebaseModel
])
abstract class FlutterDatabase extends FloorDatabase {
  UserDao get taskDao;
  LinesDao get linesDao;
  MachineDao get machineDao;
  MachineCategolaryDao get machineCategolaryDao;
  CellDao get cellDao;
  MessageFirebaseDao get messageFirebaseDao;
}
