import 'package:sqflite/sqflite.dart';

import '../models/music_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String musicTable = "music_table";
  String id = "id";
  String title = 'title';
  String artist = 'artist';
  String album = 'album';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = '${await getDatabasesPath()}/music.db';
    var todosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $musicTable($id TEXT PRIMARY KEY,$title TEXT, '
      '$artist TEXT, $album TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getMusicDataMapList() async {
    Database db = await database;
    var result = await db.query(musicTable);
    return result;
  }

  Future<int> insertMusicData(MusicData musicData) async {
    Database db = await database;
    var result = await db.insert(musicTable, musicData.toMap());
    return result;
  }

  Future<int> deleteMusicData(MusicData musicTitle) async {
    print('-delete---musicTitle-----$musicTitle');
    var db = await database;
    var result = await db.delete(musicTable,
        where: "$title = ?", whereArgs: [musicTitle.title]);
    print('-delete----lowerLanguageCardTable---result---$result');
    return result;
  }

  Future<List<MusicData>?> getMusicDataList() async {
    var todoMapList = await getMusicDataMapList();
    int count = todoMapList.length;
    List<MusicData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(MusicData.fromMap(todoMapList[i]));
    }
    return data;
  }
}
