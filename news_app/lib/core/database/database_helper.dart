import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "NewsDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'news_table';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnAuthor = 'author';

  DatabaseHelper._private();
  static final DatabaseHelper instance = DatabaseHelper._private();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var appDirectory = await getApplicationDocumentsDirectory();
    var path = join(appDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnAuthor TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    var db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    var db = await instance.database;
    return await db!.update(table, row);
  }

  Future<int> delete(int id) async {
    var db = await instance.database;
    return await db!.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> fetchAllNews() async {
    var db = await instance.database;
    return await db!.query(table);
  }

  Future<List<Map<String, dynamic>>> searchNews(String keyword) async {
    var db = await instance.database;
    return await db!
        .query(table, where: "title LIKE ?", whereArgs: ['%$keyword%']);
  }
}
