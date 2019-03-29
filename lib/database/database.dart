import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:animey/models/anime.dart';

import 'package:animey/main.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    //Directory docDirectory = await getApplicationDocumentsDirectory();
    //String path = join(docDirectory.path,'test.db');
    //String fromPath = 'database/test.db';
    //
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = join(appDocDir.path, "data.db");

    if (await File(path).exists()) {
      //return await openDatabase(path);
      return await openDatabase(
        path,
        version: 1,
        onUpgrade: (db, _, __) async {},
        onOpen: (db) {
          loaded = true;
        },
      );
    } else {
      ByteData data = await rootBundle.load("database/data.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      //File(path).delete();
      File(path).writeAsBytes(bytes);
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, _){
          db.rawQuery("CREATE TABLE IF NOT EXISTS Records (id INTEGER PRIMARY KEY AUTOINCREMENT,data Text, finishDate Text);");
        },
        onOpen: (db) {
          loaded = true;
        },
      );
    }
  }

  Future<int> getLastId() async {
    final db = await database;
    var table = await db.rawQuery('SELECT MAX(Id)+1 as Id FROM Records');
    int id = table.first['Id'];
    return id;
  }

  newRecord(AnimeData data) async {
    final db = await database;
    var table = await db.rawQuery('SELECT MAX(Id)+1 as Id FROM Records');
    data.id = table.first['Id'];
    var map = data.toJson();

    var raw = await db.rawInsert(
        'INSERT Into Records (id, data, finishDate) VALUES (?,?,?)',
        [map['id'], map['data'], map["finishDate"]]);
    return raw;
  }

  updateRecords(AnimeData data) async {
    final db = await database;
    var res = await db.update("Records", data.toJson(),
        where: "id = ?", whereArgs: [data.id]);
    return res;
  }

  deleteRecord(AnimeData data) async {
    final db = await database;
    var res = await db.delete("Records", where: "id = ?", whereArgs: [data.id]);
    return res;
  }

  deleteAllRecords() async {
    final db = await database;
    var res = await db.delete("Records");
    return res;
  }

  Future<List<AnimeData>> getAllRecords() async {
    final db = await database;
    var res = await db.query('Records');

    return res.isNotEmpty
        ? res.map((r) {
            return AnimeData.fromDbJson(r);
          }).toList()
        : [];
  }
}
