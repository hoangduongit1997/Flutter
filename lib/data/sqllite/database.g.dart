// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final database = _$FlutterDatabase();
    database.database = await database.open(name ?? ':memory:', _migrations);
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao _taskDaoInstance;

  LinesDao _linesDaoInstance;

  MachineDao _machineDaoInstance;

  MachineCategolaryDao _machineCategolaryDaoInstance;

  CellDao _cellDaoInstance;

  MessageFirebaseDao _messageFirebaseDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);
      },
      onCreate: (database, _) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserModel` (`id` INTEGER, `userCode` TEXT, `userName` TEXT, `fullName` TEXT, `centerCode` TEXT, `roleID` TEXT, `roleName` TEXT, `url_avt` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LineModel` (`lineId` INTEGER, `name` TEXT, `code` TEXT, `centerCode` TEXT, `wt` REAL, PRIMARY KEY (`lineId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CellModel` (`id` INTEGER, `lineId` INTEGER, `name` TEXT, `code` TEXT, `wt` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MachineModel` (`machineId` INTEGER, `mCateId` INTEGER, `cell_id` INTEGER, `line_id` INTEGER, `name` TEXT, `positition` TEXT, `code` TEXT, `statusCode` TEXT, `statusName` TEXT, `wt` REAL, PRIMARY KEY (`machineId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MachineCategolaryModel` (`id` INTEGER, `name` TEXT, `code` TEXT, `img_Url` TEXT, `imageData` TEXT, `wt` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MessageFirebaseModel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT, `body` TEXT, `status` INTEGER)');
      },
    );
  }

  @override
  UserDao get taskDao {
    return _taskDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  LinesDao get linesDao {
    return _linesDaoInstance ??= _$LinesDao(database, changeListener);
  }

  @override
  MachineDao get machineDao {
    return _machineDaoInstance ??= _$MachineDao(database, changeListener);
  }

  @override
  MachineCategolaryDao get machineCategolaryDao {
    return _machineCategolaryDaoInstance ??=
        _$MachineCategolaryDao(database, changeListener);
  }

  @override
  CellDao get cellDao {
    return _cellDaoInstance ??= _$CellDao(database, changeListener);
  }

  @override
  MessageFirebaseDao get messageFirebaseDao {
    return _messageFirebaseDaoInstance ??=
        _$MessageFirebaseDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userModelInsertionAdapter = InsertionAdapter(
            database,
            'UserModel',
            (UserModel item) => <String, dynamic>{
                  'id': item.id,
                  'userCode': item.userCode,
                  'userName': item.userName,
                  'fullName': item.fullName,
                  'centerCode': item.centerCode,
                  'roleID': item.roleID,
                  'roleName': item.roleName,
                  'url_avt': item.url_avt
                },
            changeListener),
        _userModelUpdateAdapter = UpdateAdapter(
            database,
            'UserModel',
            'id',
            (UserModel item) => <String, dynamic>{
                  'id': item.id,
                  'userCode': item.userCode,
                  'userName': item.userName,
                  'fullName': item.fullName,
                  'centerCode': item.centerCode,
                  'roleID': item.roleID,
                  'roleName': item.roleName,
                  'url_avt': item.url_avt
                },
            changeListener),
        _userModelDeletionAdapter = DeletionAdapter(
            database,
            'UserModel',
            'id',
            (UserModel item) => <String, dynamic>{
                  'id': item.id,
                  'userCode': item.userCode,
                  'userName': item.userName,
                  'fullName': item.fullName,
                  'centerCode': item.centerCode,
                  'roleID': item.roleID,
                  'roleName': item.roleName,
                  'url_avt': item.url_avt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final _userModelMapper = (Map<String, dynamic> row) => UserModel(
      row['id'] as int,
      row['userCode'] as String,
      row['userName'] as String,
      row['fullName'] as String,
      row['centerCode'] as String,
      row['roleID'] as String,
      row['roleName'] as String,
      row['url_avt'] as String);

  final InsertionAdapter<UserModel> _userModelInsertionAdapter;

  final UpdateAdapter<UserModel> _userModelUpdateAdapter;

  final DeletionAdapter<UserModel> _userModelDeletionAdapter;

  @override
  Future<UserModel> findUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM UserModel WHERE id = ?',
        arguments: <dynamic>[id], mapper: _userModelMapper);
  }

  @override
  Future<List<UserModel>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM UserModel',
        mapper: _userModelMapper);
  }

  @override
  Stream<List<UserModel>> findAllUsersAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM UserModel',
        tableName: 'UserModel', mapper: _userModelMapper);
  }

  @override
  Future<List<UserModel>> countUserById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM UserModel WHERE id= ?',
        arguments: <dynamic>[id], mapper: _userModelMapper);
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await _userModelInsertionAdapter.insert(
        user, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertUsers(List<UserModel> users) async {
    await _userModelInsertionAdapter.insertList(
        users, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateUser(UserModel User) async {
    await _userModelUpdateAdapter.update(User, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateUsers(List<UserModel> user) async {
    await _userModelUpdateAdapter.updateList(
        user, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteUser(UserModel user) async {
    await _userModelDeletionAdapter.delete(user);
  }

  @override
  Future<void> deleteUsers(List<UserModel> users) async {
    await _userModelDeletionAdapter.deleteList(users);
  }
}

class _$LinesDao extends LinesDao {
  _$LinesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _lineModelInsertionAdapter = InsertionAdapter(
            database,
            'LineModel',
            (LineModel item) => <String, dynamic>{
                  'lineId': item.lineId,
                  'name': item.name,
                  'code': item.code,
                  'centerCode': item.centerCode,
                  'wt': item.wt
                },
            changeListener),
        _lineModelUpdateAdapter = UpdateAdapter(
            database,
            'LineModel',
            'lineId',
            (LineModel item) => <String, dynamic>{
                  'lineId': item.lineId,
                  'name': item.name,
                  'code': item.code,
                  'centerCode': item.centerCode,
                  'wt': item.wt
                },
            changeListener),
        _lineModelDeletionAdapter = DeletionAdapter(
            database,
            'LineModel',
            'lineId',
            (LineModel item) => <String, dynamic>{
                  'lineId': item.lineId,
                  'name': item.name,
                  'code': item.code,
                  'centerCode': item.centerCode,
                  'wt': item.wt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final _lineModelMapper = (Map<String, dynamic> row) => LineModel(
      row['lineId'] as int,
      row['name'] as String,
      row['code'] as String,
      row['centerCode'] as String,
      row['wt'] as double);

  final InsertionAdapter<LineModel> _lineModelInsertionAdapter;

  final UpdateAdapter<LineModel> _lineModelUpdateAdapter;

  final DeletionAdapter<LineModel> _lineModelDeletionAdapter;

  @override
  Future<LineModel> findLinesById(int id) async {
    return _queryAdapter.query('SELECT * FROM LineModel WHERE id = ?',
        arguments: <dynamic>[id], mapper: _lineModelMapper);
  }

  @override
  Future<List<LineModel>> findAllLiness() async {
    return _queryAdapter.queryList('SELECT * FROM LineModel',
        mapper: _lineModelMapper);
  }

  @override
  Stream<List<LineModel>> findAllLinessAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM LineModel',
        tableName: 'LineModel', mapper: _lineModelMapper);
  }

  @override
  Future<LineModel> selectMaxWT() async {
    return _queryAdapter.query(
        'SELECT * from LineModel WHERE wt=(SELECT MAX(wt) FROM LineModel ORDER BY wt DESC LIMIT 1)',
        mapper: _lineModelMapper);
  }

  @override
  Future<List<LineModel>> countLinesById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM LineModel WHERE id= ?',
        arguments: <dynamic>[id], mapper: _lineModelMapper);
  }

  @override
  Future<void> deleteAllRow() async {
    await _queryAdapter.queryNoReturn('DELETE FROM LineModel');
  }

  @override
  Future<void> insertLines(LineModel lines) async {
    await _lineModelInsertionAdapter.insert(
        lines, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertLiness(List<LineModel> lines) async {
    await _lineModelInsertionAdapter.insertList(
        lines, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateLines(LineModel lines) async {
    await _lineModelUpdateAdapter.update(
        lines, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateLiness(List<LineModel> lines) async {
    await _lineModelUpdateAdapter.updateList(
        lines, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteLines(LineModel lines) async {
    await _lineModelDeletionAdapter.delete(lines);
  }

  @override
  Future<void> deleteLiness(List<LineModel> liness) async {
    await _lineModelDeletionAdapter.deleteList(liness);
  }
}

class _$MachineDao extends MachineDao {
  _$MachineDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _machineModelInsertionAdapter = InsertionAdapter(
            database,
            'MachineModel',
            (MachineModel item) => <String, dynamic>{
                  'machineId': item.machineId,
                  'mCateId': item.mCateId,
                  'cell_id': item.cell_id,
                  'line_id': item.line_id,
                  'name': item.name,
                  'positition': item.positition,
                  'code': item.code,
                  'statusCode': item.statusCode,
                  'statusName': item.statusName,
                  'wt': item.wt
                },
            changeListener),
        _machineModelUpdateAdapter = UpdateAdapter(
            database,
            'MachineModel',
            'machineId',
            (MachineModel item) => <String, dynamic>{
                  'machineId': item.machineId,
                  'mCateId': item.mCateId,
                  'cell_id': item.cell_id,
                  'line_id': item.line_id,
                  'name': item.name,
                  'positition': item.positition,
                  'code': item.code,
                  'statusCode': item.statusCode,
                  'statusName': item.statusName,
                  'wt': item.wt
                },
            changeListener),
        _machineModelDeletionAdapter = DeletionAdapter(
            database,
            'MachineModel',
            'machineId',
            (MachineModel item) => <String, dynamic>{
                  'machineId': item.machineId,
                  'mCateId': item.mCateId,
                  'cell_id': item.cell_id,
                  'line_id': item.line_id,
                  'name': item.name,
                  'positition': item.positition,
                  'code': item.code,
                  'statusCode': item.statusCode,
                  'statusName': item.statusName,
                  'wt': item.wt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final _machineModelMapper = (Map<String, dynamic> row) => MachineModel(
      row['machineId'] as int,
      row['mCateId'] as int,
      row['cell_id'] as int,
      row['line_id'] as int,
      row['name'] as String,
      row['positition'] as String,
      row['code'] as String,
      row['statusCode'] as String,
      row['statusName'] as String,
      row['wt'] as double);

  final InsertionAdapter<MachineModel> _machineModelInsertionAdapter;

  final UpdateAdapter<MachineModel> _machineModelUpdateAdapter;

  final DeletionAdapter<MachineModel> _machineModelDeletionAdapter;

  @override
  Future<MachineModel> findLinesById(int id) async {
    return _queryAdapter.query('SELECT * FROM MachineModel WHERE id = ?',
        arguments: <dynamic>[id], mapper: _machineModelMapper);
  }

  @override
  Future<List<MachineModel>> findAllMachines() async {
    return _queryAdapter.queryList('SELECT * FROM MachineModel',
        mapper: _machineModelMapper);
  }

  @override
  Stream<List<MachineModel>> findAllMachinesAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM MachineModel',
        tableName: 'MachineModel', mapper: _machineModelMapper);
  }

  @override
  Future<MachineModel> selectMaxWT() async {
    return _queryAdapter.query(
        'SELECT * from MachineModel WHERE wt=(SELECT MAX(wt) FROM MachineModel ORDER BY wt DESC LIMIT 1)',
        mapper: _machineModelMapper);
  }

  @override
  Future<List<MachineModel>> countMachineById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM MachineModel WHERE id= ?',
        arguments: <dynamic>[id], mapper: _machineModelMapper);
  }

  @override
  Future<void> deleteAllRow() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MachineModel');
  }

  @override
  Future<void> insertMachineModel(MachineModel machineModel) async {
    await _machineModelInsertionAdapter.insert(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertMachinesModels(List<MachineModel> machineModel) async {
    await _machineModelInsertionAdapter.insertList(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateMachineModel(MachineModel machineModel) async {
    await _machineModelUpdateAdapter.update(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateMachinesModels(List<MachineModel> machineModel) async {
    await _machineModelUpdateAdapter.updateList(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteMachineModel(MachineModel machineModel) async {
    await _machineModelDeletionAdapter.delete(machineModel);
  }

  @override
  Future<void> deleteMachinesModels(List<MachineModel> machineModel) async {
    await _machineModelDeletionAdapter.deleteList(machineModel);
  }
}

class _$MachineCategolaryDao extends MachineCategolaryDao {
  _$MachineCategolaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _machineCategolaryModelInsertionAdapter = InsertionAdapter(
            database,
            'MachineCategolaryModel',
            (MachineCategolaryModel item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'img_Url': item.img_Url,
                  'imageData': item.imageData,
                  'wt': item.wt
                },
            changeListener),
        _machineCategolaryModelUpdateAdapter = UpdateAdapter(
            database,
            'MachineCategolaryModel',
            'id',
            (MachineCategolaryModel item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'img_Url': item.img_Url,
                  'imageData': item.imageData,
                  'wt': item.wt
                },
            changeListener),
        _machineCategolaryModelDeletionAdapter = DeletionAdapter(
            database,
            'MachineCategolaryModel',
            'id',
            (MachineCategolaryModel item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'img_Url': item.img_Url,
                  'imageData': item.imageData,
                  'wt': item.wt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final _machineCategolaryModelMapper = (Map<String, dynamic> row) =>
      MachineCategolaryModel(
          row['id'] as int,
          row['name'] as String,
          row['code'] as String,
          row['img_Url'] as String,
          row['imageData'] as String,
          row['wt'] as double);

  final InsertionAdapter<MachineCategolaryModel>
      _machineCategolaryModelInsertionAdapter;

  final UpdateAdapter<MachineCategolaryModel>
      _machineCategolaryModelUpdateAdapter;

  final DeletionAdapter<MachineCategolaryModel>
      _machineCategolaryModelDeletionAdapter;

  @override
  Future<MachineCategolaryModel> findMachineCategolaryModelById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM MachineCategolaryModel WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: _machineCategolaryModelMapper);
  }

  @override
  Future<List<MachineCategolaryModel>> findAllMachineCategolaryModel() async {
    return _queryAdapter.queryList('SELECT * FROM MachineCategolaryModel',
        mapper: _machineCategolaryModelMapper);
  }

  @override
  Stream<List<MachineCategolaryModel>> findAllMachineCategolaryModelAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM MachineCategolaryModel',
        tableName: 'MachineCategolaryModel',
        mapper: _machineCategolaryModelMapper);
  }

  @override
  Future<MachineCategolaryModel> selectMaxWT() async {
    return _queryAdapter.query(
        'SELECT * from MachineCategolaryModel WHERE wt=(SELECT MAX(wt) FROM MachineCategolaryModel ORDER BY wt DESC LIMIT 1)',
        mapper: _machineCategolaryModelMapper);
  }

  @override
  Future<List<MachineCategolaryModel>> countMachineCategolaryModelById(
      int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MachineCategolaryModel WHERE id= ?',
        arguments: <dynamic>[id],
        mapper: _machineCategolaryModelMapper);
  }

  @override
  Future<void> deleteAllRow() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MachineCategolaryModel');
  }

  @override
  Future<void> insertMachineCategolaryModel(
      MachineCategolaryModel machineCategolaryModel) async {
    await _machineCategolaryModelInsertionAdapter.insert(
        machineCategolaryModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertMachineCategolaryModels(
      List<MachineCategolaryModel> machineCategolaryModel) async {
    await _machineCategolaryModelInsertionAdapter.insertList(
        machineCategolaryModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateMachineCategolaryModel(
      MachineCategolaryModel machineCategolaryModel) async {
    await _machineCategolaryModelUpdateAdapter.update(
        machineCategolaryModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateMachineCategolaryModels(
      List<MachineCategolaryModel> machineCategolaryModel) async {
    await _machineCategolaryModelUpdateAdapter.updateList(
        machineCategolaryModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteMachineCategolaryModel(
      MachineCategolaryModel machineCategolaryModel) async {
    await _machineCategolaryModelDeletionAdapter.delete(machineCategolaryModel);
  }

  @override
  Future<void> deleteMachineCategolaryModels(
      List<MachineCategolaryModel> machineModel) async {
    await _machineCategolaryModelDeletionAdapter.deleteList(machineModel);
  }
}

class _$CellDao extends CellDao {
  _$CellDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _cellModelInsertionAdapter = InsertionAdapter(
            database,
            'CellModel',
            (CellModel item) => <String, dynamic>{
                  'id': item.id,
                  'lineId': item.lineId,
                  'name': item.name,
                  'code': item.code,
                  'wt': item.wt
                },
            changeListener),
        _cellModelUpdateAdapter = UpdateAdapter(
            database,
            'CellModel',
            'id',
            (CellModel item) => <String, dynamic>{
                  'id': item.id,
                  'lineId': item.lineId,
                  'name': item.name,
                  'code': item.code,
                  'wt': item.wt
                },
            changeListener),
        _cellModelDeletionAdapter = DeletionAdapter(
            database,
            'CellModel',
            'id',
            (CellModel item) => <String, dynamic>{
                  'id': item.id,
                  'lineId': item.lineId,
                  'name': item.name,
                  'code': item.code,
                  'wt': item.wt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final _cellModelMapper = (Map<String, dynamic> row) => CellModel(
      row['id'] as int,
      row['lineId'] as String,
      row['name'] as String,
      row['code'] as int,
      row['wt'] as double);

  final InsertionAdapter<CellModel> _cellModelInsertionAdapter;

  final UpdateAdapter<CellModel> _cellModelUpdateAdapter;

  final DeletionAdapter<CellModel> _cellModelDeletionAdapter;

  @override
  Future<CellModel> findLinesById(int id) async {
    return _queryAdapter.query('SELECT * FROM CellModel WHERE id = ?',
        arguments: <dynamic>[id], mapper: _cellModelMapper);
  }

  @override
  Future<List<CellModel>> findAllLiness() async {
    return _queryAdapter.queryList('SELECT * FROM CellModel',
        mapper: _cellModelMapper);
  }

  @override
  Stream<List<CellModel>> findAllLinessAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM CellModel',
        tableName: 'CellModel', mapper: _cellModelMapper);
  }

  @override
  Future<List<CellModel>> countLinesById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM CellModel WHERE id= ?',
        arguments: <dynamic>[id], mapper: _cellModelMapper);
  }

  @override
  Future<void> deleteAllRow() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CellModel');
  }

  @override
  Future<CellModel> selectMaxWT() async {
    return _queryAdapter.query(
        'SELECT * from CellModel WHERE wt=(SELECT MAX(wt) FROM CellModel ORDER BY wt DESC LIMIT 1)',
        mapper: _cellModelMapper);
  }

  @override
  Future<void> insertCellModel(CellModel cellModel) async {
    await _cellModelInsertionAdapter.insert(
        cellModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertCellModels(List<CellModel> cellModel) async {
    await _cellModelInsertionAdapter.insertList(
        cellModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateCellModel(CellModel cellModel) async {
    await _cellModelUpdateAdapter.update(
        cellModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateCellModels(List<CellModel> cellModel) async {
    await _cellModelUpdateAdapter.updateList(
        cellModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteCellModel(CellModel cellModel) async {
    await _cellModelDeletionAdapter.delete(cellModel);
  }

  @override
  Future<void> deleteCellModels(List<CellModel> cellModel) async {
    await _cellModelDeletionAdapter.deleteList(cellModel);
  }
}

class _$MessageFirebaseDao extends MessageFirebaseDao {
  _$MessageFirebaseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _messageFirebaseModelInsertionAdapter = InsertionAdapter(
            database,
            'MessageFirebaseModel',
            (MessageFirebaseModel item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'status': item.status
                },
            changeListener),
        _messageFirebaseModelUpdateAdapter = UpdateAdapter(
            database,
            'MessageFirebaseModel',
            'id',
            (MessageFirebaseModel item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'status': item.status
                },
            changeListener),
        _messageFirebaseModelDeletionAdapter = DeletionAdapter(
            database,
            'MessageFirebaseModel',
            'id',
            (MessageFirebaseModel item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'status': item.status
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final _messageFirebaseModelMapper = (Map<String, dynamic> row) =>
      MessageFirebaseModel(row['id'] as int, row['title'] as String,
          row['body'] as String, row['status'] as int);

  final InsertionAdapter<MessageFirebaseModel>
      _messageFirebaseModelInsertionAdapter;

  final UpdateAdapter<MessageFirebaseModel> _messageFirebaseModelUpdateAdapter;

  final DeletionAdapter<MessageFirebaseModel>
      _messageFirebaseModelDeletionAdapter;

  @override
  Future<MessageFirebaseModel> findLinesById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM MessageFirebaseModel WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: _messageFirebaseModelMapper);
  }

  @override
  Future<List<MessageFirebaseModel>> findAllMessageFirebases() async {
    return _queryAdapter.queryList('SELECT * FROM MessageFirebaseModel',
        mapper: _messageFirebaseModelMapper);
  }

  @override
  Future<void> deleteMessageById(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM MessageFirebaseModel WHERE id=?',
        arguments: <dynamic>[id]);
  }

  @override
  Stream<List<MessageFirebaseModel>> findAllMessageFirebasesAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM MessageFirebaseModel',
        tableName: 'MessageFirebaseModel', mapper: _messageFirebaseModelMapper);
  }

  @override
  Future<List<MessageFirebaseModel>> countMessageFirebaseById(int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MessageFirebaseModel WHERE id= ?',
        arguments: <dynamic>[id],
        mapper: _messageFirebaseModelMapper);
  }

  @override
  Future<void> deleteAllRow() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MessageFirebaseModel');
  }

  @override
  Future<void> insertMessageFirebaseModel(
      MessageFirebaseModel machineModel) async {
    await _messageFirebaseModelInsertionAdapter.insert(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertMessageFirebasesModels(
      List<MessageFirebaseModel> machineModel) async {
    await _messageFirebaseModelInsertionAdapter.insertList(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateMessageFirebaseModel(
      MessageFirebaseModel machineModel) async {
    await _messageFirebaseModelUpdateAdapter.update(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateMessageFirebasesModels(
      List<MessageFirebaseModel> machineModel) async {
    await _messageFirebaseModelUpdateAdapter.updateList(
        machineModel, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteMessageFirebaseModel(
      MessageFirebaseModel machineModel) async {
    await _messageFirebaseModelDeletionAdapter.delete(machineModel);
  }

  @override
  Future<void> deleteMessageFirebasesModels(
      List<MessageFirebaseModel> machineModel) async {
    await _messageFirebaseModelDeletionAdapter.deleteList(machineModel);
  }
}
