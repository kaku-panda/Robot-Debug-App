import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "myDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'consoleLogTable';

  // テーブルカラムの定義
  static const columnId = '_id';
  static const columnDateTime = 'dateTime';
  static const columnContent = 'content';
  static const columnIsError = 'isError';
  static const columnFromRobot = 'fromRobot';

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
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY,
          $columnDateTime TEXT NOT NULL,
          $columnContent TEXT NOT NULL,
          $columnIsError INTEGER NOT NULL,
          $columnFromRobot INTEGER NOT NULL
        )
        ''');
      },
    );
  }

  // 全てのデータを取得
  Future<List<Map<String, dynamic>>> getAllData() async {
    final Database? db = await database;
    return await db!.query(table);
  }

  // データ追加のメソッド
  Future<void> insertData(Map<String, dynamic> data) async {
    final Database? db = await database;
    await db!.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateData(int id, Map<String, dynamic> data)  async {
    final Database? db = await database;
    return await db!.update(table, data, where: '_id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(int id) async {
    final Database? db = await database;
    return await db!.delete(table, where: '_id = ?', whereArgs: [id]);
  }

  // サンプル
  void addLog() async {
    Map<String, dynamic> data = {
      DatabaseHelper.columnDateTime: '2022-03-21 10:00:00',
      DatabaseHelper.columnContent: 'This is a log message.',
      DatabaseHelper.columnIsError: 0,
      DatabaseHelper.columnFromRobot: 1,
    };
    await insertData(data);
  }
}