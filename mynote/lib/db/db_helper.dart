import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mynote/model/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "task";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      debugPrint("Creating a new one.");
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        return db.execute("""
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title STRING,note TEXT,date STRING,
            startTime STRING,endTime STRING,
            remind INTEGER,repeat STRING,
            color INTEGER,
            isCompleted INTEGER
          )
          """);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<int> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toMap()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint("Query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
}
