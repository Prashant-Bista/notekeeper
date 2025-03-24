import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper getInstance = DBHelper._();
  //common strings

  static const TABLE_NOTE = "note";
  static const COLUMN_NOTE_SNO = "id";
  static const COLUMN_NOTE_TITLE = "title";
  static const COLUMN_NOTE_DESC = "desc";

  Database? myDB;
  Future<Database> getDB() async {
    myDB ??= await openDB();
    print("returned from openDB");
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = appDir.path + "/nodeDB.db";
    print("dbpath: $dbPath");
    return await  openDatabase(dbPath, onCreate: (db, version) async{
      await db.execute(
          "create table $TABLE_NOTE($COLUMN_NOTE_SNO integer primary key autoincrement,$COLUMN_NOTE_TITLE TEXT NOT NULL,$COLUMN_NOTE_DESC TEXT NOT NULL)");
      print("Table created");
    }, version: 1);

  }

  Future<bool> addNote({required String mtitle, required String mDesc}) async {
    print(mtitle);
    print("Inside addNote");
    print(mDesc);
    var db = await getDB();
    print("after getDB");
    int rowsAffected = await db.insert(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: mtitle, COLUMN_NOTE_DESC: mDesc});
    print("after insert");

    return rowsAffected > 0;
  }
  Future<List<Map<String,dynamic>>> getAllNotes()async{
    var db = await getDB();
    List<Map<String,dynamic>> mData= await db.query(TABLE_NOTE);
    return mData;
  }
}
