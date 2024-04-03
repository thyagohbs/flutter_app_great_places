import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class PlacesSqlite {
  static const String _tableName = 'places';

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute("""
          CREATE TABLE IF NOT EXISTS $_tableName (
            id TEXT PRIMARY KEY, 
            title TEXT, 
            image TEXT,
            location_address TEXT,
            location_lat REAL,
            location_lng REAL
          );
          """);
    }, version: 1);
  }

  static Future<void> insert(Map<String, Object> data) async {
    final db = await database();
    await db.insert(
      _tableName,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await database();
    return await db.query(
      _tableName,
    );
  }
}
