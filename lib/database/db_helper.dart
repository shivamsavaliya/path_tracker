import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/latlong_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'latlong.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE latlng(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  Future<int> insertLatLng(LatLngModel latLng) async {
    final Database db = await database;
    return await db.insert('latlng', latLng.toMap());
  }

  Future<List<LatLngModel>> getLatLngList() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('latlng');
    return List.generate(maps.length, (i) {
      return LatLngModel(
        id: maps[i]['id'],
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
      );
    });
  }
}
