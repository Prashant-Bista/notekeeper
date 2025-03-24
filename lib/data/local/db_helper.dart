import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper getInstance = DBHelper._();
  //common strings

  static const TABLE_NOTE = "note";
  static const COLUMN_NOTE_SNO = "";
  static const COLUMN_NOTE_TITLE = "";
  static const COLUMN_NOTE_DESC = "";

  Database? myDB;
  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = appDir.path + "nodeDB.db";
    return await  openDatabase(dbPath, onCreate: (db, version) {
      db.execute(
          "create table  $TABLE_NOTE($COLUMN_NOTE_SNO integer primary key autoincrement");
    }, version: 1);
  }

  Future<bool> addNote({required String mtitle, required String mDesc}) async {
    var db = await getDB();
    int rowsAffected = await db.insert(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: mtitle, COLUMN_NOTE_DESC: mDesc});
    return rowsAffected > 0;
  }
  Future<List<Map<String,dynamic>>> getAllNotes()async{
    var db = await getDB();
    List<Map<String,dynamic>> mData= await db.query(TABLE_NOTE,columns: [COLUMN_NOTE_TITLE,]);
    return mData;
  }
}
