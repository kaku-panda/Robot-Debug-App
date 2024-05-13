import 'package:robo_debug_app/database/console_log.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName     = "myDatabase.db";
  static const _databaseVersion  = 1;
  static const consoleLogTable   = 'consoleLogTable';
  static const parameterSetTable = 'parameterSetTable';

  // テーブルカラムの定義
  static const columnId        = '_id';
  static const columnDateTime  = 'dateTime';

  static const columnContent   = 'content';
  static const columnIsError   = 'isError';
  static const columnFromRobot = 'fromRobot';

  static const columnTitle     = 'title'     ; 
  static const columnSpeed     = 'speed'     ; 
  static const columnSpeedMax  = 'speedMax'  ; 
  static const columnSpeedMin  = 'speedMin'  ; 
  static const columnKp        = 'kp'        ; 
  static const columnKpMax     = 'kpMax'     ; 
  static const columnKpMin     = 'kpMin'     ; 
  static const columnKi        = 'ki'        ; 
  static const columnKiMax     = 'kiMax'     ; 
  static const columnKiMin     = 'kiMin'     ; 
  static const columnKd        = 'kd'        ; 
  static const columnKdMax     = 'kdMax'     ; 
  static const columnKdMin     = 'kdMin'     ; 
  static const columnSensor0   = 'sensor0'   ; 
  static const columnSensor1   = 'sensor1'   ; 
  static const columnSensor2   = 'sensor2'   ; 
  static const columnSensor3   = 'sensor3'   ; 
  static const columnSensor4   = 'sensor4'   ; 
  static const columnSensor5   = 'sensor5'   ; 
  static const columnSensor6   = 'sensor6'   ; 
  static const columnSensor7   = 'sensor7'   ; 
  static const columnSensorMax = 'sensorMax' ; 
  static const columnSensorMin = 'sensorMin' ; 

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  // データベースの初期化
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $consoleLogTable (
          $columnId INTEGER PRIMARY KEY,
          $columnDateTime TEXT NOT NULL,
          $columnContent TEXT NOT NULL,
          $columnIsError INTEGER NOT NULL,
          $columnFromRobot INTEGER NOT NULL
        )
        ''');
      await db.execute('''
        CREATE TABLE $parameterSetTable (
          $columnId INTEGER PRIMARY KEY,
          $columnDateTime TEXT NOT NULL,
          $columnTitle TEXT NOT NULL,
          $columnSpeed REAL NOT NULL,
          $columnSpeedMax REAL NOT NULL,
          $columnSpeedMin REAL NOT NULL,
          $columnKp REAL NOT NULL,
          $columnKpMax REAL NOT NULL,
          $columnKpMin REAL NOT NULL,
          $columnKi REAL NOT NULL,
          $columnKiMax REAL NOT NULL,
          $columnKiMin REAL NOT NULL,
          $columnKd REAL NOT NULL,
          $columnKdMax REAL NOT NULL,
          $columnKdMin REAL NOT NULL,
          $columnSensor0 INTERGER NOT NULL,
          $columnSensor1 INTERGER NOT NULL,
          $columnSensor2 INTERGER NOT NULL,
          $columnSensor3 INTERGER NOT NULL,
          $columnSensor4 INTERGER NOT NULL,
          $columnSensor5 INTERGER NOT NULL,
          $columnSensor6 INTERGER NOT NULL,
          $columnSensor7 INTERGER NOT NULL,
          $columnSensorMax INTEGER NOT NULL,
          $columnSensorMin INTEGER NOT NULL
        )
        ''');
      },
    );
  }

  // 全てのデータを取得
  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    final Database? db = await database;
    if (tableName == consoleLogTable) {
      return await db!.query(consoleLogTable);
    } else if (tableName == parameterSetTable) {
      return await db!.query(
        parameterSetTable,
        orderBy: '_id DESC',
      );
    }
    return [{'error': 'table name is invalid'}];
  }

  // データ追加のメソッド
  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    final Database? db = await database;
    if (tableName == consoleLogTable) {
      await db!.insert(consoleLogTable, data, conflictAlgorithm: ConflictAlgorithm.replace);
      return 1;
    } else if (tableName == parameterSetTable) {
      await db!.insert(parameterSetTable, data, conflictAlgorithm: ConflictAlgorithm.replace);
      return 1;
    }
    return -1;
  }

  Future<int> updateData(String tableName, int id, Map<String, dynamic> data)  async {
    final Database? db = await database;
    if (tableName == consoleLogTable) {
      return await db!.update(consoleLogTable, data, where: '_id = ?', whereArgs: [id]);
    } else if (tableName == parameterSetTable) {
      return await db!.update(parameterSetTable, data, where: '_id = ?', whereArgs: [id]);
    }
    return -1;
  }

  Future<int> deleteData(String tableName, int id) async {
    final Database? db = await database;
    if (tableName == consoleLogTable) {
      return await db!.delete(consoleLogTable, where: '_id = ?', whereArgs: [id]);
    } else if (tableName == parameterSetTable) {
      return await db!.delete(parameterSetTable, where: '_id = ?', whereArgs: [id]);
    }
    return -1;
  }

  // サンプル
  void addLog() async {
    Map<String, dynamic> data = {
      DatabaseHelper.columnDateTime: '2022-03-21 10:00:00',
      DatabaseHelper.columnContent: 'This is a log message.',
      DatabaseHelper.columnIsError: 0,
      DatabaseHelper.columnFromRobot: 1,
    };
    await insertData(consoleLogTable, data);
  }

  void addParameterSet() async {
    Map<String, dynamic> data = {
      DatabaseHelper.columnDateTime: '2022-03-21 10:00:00',
      DatabaseHelper.columnTitle: 'Parameter Set 1',
      DatabaseHelper.columnSpeed: 0.5,
      DatabaseHelper.columnSpeedMax: 1.0,
      DatabaseHelper.columnSpeedMin: 0.0,
      DatabaseHelper.columnKp: 0.1,
      DatabaseHelper.columnKpMax: 1.0,
      DatabaseHelper.columnKpMin: 0.0,
      DatabaseHelper.columnKi: 0.1,
      DatabaseHelper.columnKiMax: 1.0,
      DatabaseHelper.columnKiMin: 0.0,
      DatabaseHelper.columnKd: 0.1,
      DatabaseHelper.columnKdMax: 1.0,
      DatabaseHelper.columnKdMin: 0.0,
      DatabaseHelper.columnSensor0: 0,
      DatabaseHelper.columnSensor1: 0,
      DatabaseHelper.columnSensor2: 0,
      DatabaseHelper.columnSensor3: 0,
      DatabaseHelper.columnSensor4: 0,
      DatabaseHelper.columnSensor5: 0,
      DatabaseHelper.columnSensor6: 0,
      DatabaseHelper.columnSensor7: 0,
      DatabaseHelper.columnSensorMax: 100,
      DatabaseHelper.columnSensorMin: 0,
    };
    await insertData(parameterSetTable, data);
  }
}