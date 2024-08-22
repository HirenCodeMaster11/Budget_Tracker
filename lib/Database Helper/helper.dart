import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  static const String databaseName = 'notes.db';
  static const String tableName = 'notes';

  Database? _database;

  Future<Database?> get database async => _database ?? await initDatabase();

  Future<Database?> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
      CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount INTEGER NOT NULL,
      description TEXT NOT NULL,
      category TEXT
      )
      ''';
        db.execute(sql);
      },
    );
  }

  Future<int> insertData() async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName (amount, description)
    VALUES (10000000, 'Car');
    ''';
    final result = await db!.rawInsert(sql);
    return result;
  }
}