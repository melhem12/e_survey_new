import 'dart:developer';
import 'dart:math';

import 'package:e_survey/Models/CarParts.dart';
import 'package:e_survey/Models/PartsModel.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE damaged(
        surveyDamagedPartsId TEXT PRIMARY KEY NOT NULL,
        surveyDamagedDescription TEXT,
        surveyDamagedPartCode INTEGER,
        surveyDamagedReview TEXT,
        surveyDamagedSeverity INTEGER,
        surveyDamagedSurveyId TEXT,
        surveyDamagedPartDescription TEXT,
        surveyDamagedPartArabicDescription TEXT,
        metParentPart TEXT
      )
      """);

  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'esurvey.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<void> createDamage(String ? surveyDamagedDescription, String? surveyDamagedPartsId,int surveyDamagedPartCode, String?  surveyDamagedReview ,int ?surveyDamagedSeverity,String? surveyDamagedSurveyId,String? surveyDamagedPartDescription,String ? surveyDamagedPartArabicDescription,String? metParentPart) async {
    final db = await SQLHelper.db();

    final data = { 'surveyDamagedDescription': surveyDamagedDescription,
      "surveyDamagedPartsId": surveyDamagedPartsId,
      'surveyDamagedPartCode': surveyDamagedPartCode,
      'surveyDamagedReview': surveyDamagedReview,
      'surveyDamagedSeverity': surveyDamagedSeverity,
      'surveyDamagedSurveyId': surveyDamagedSurveyId,
      'surveyDamagedPartDescription': surveyDamagedPartDescription,
      'surveyDamagedPartArabicDescription': surveyDamagedPartArabicDescription,
      'metParentPart': metParentPart};
    await db.insert('damaged', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

  }


  // static Future<List<Map<String, dynamic>>> getDamaged() async {
  //   final db = await SQLHelper.db();
  //   return db.query('damaged', orderBy: "surveyDamagedPartDescription") ;
  // }
  static Future<List<Map<String, dynamic>>> getDamaged() async {
    final db = await SQLHelper.db();
    return db.query('damaged') ;
  }
  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getByCode(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteByCode(int code) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("damaged", where: "surveyDamagedPartCode = ?", whereArgs: [code]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
  static Future<void> deleteByMetParent(String metParent) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("damaged", where: "metParentPart = ?", whereArgs: [metParent]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
  static Future<void> deleteAll() async {
    final db = await SQLHelper.db();
    try {
      await db.delete("damaged" );
      print("deleeeeeeeeeeeeeeeeeete");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}