import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;


class DatabaseAlreadyOpenException implements Exception {}
class UnableToGetDocumentsDirectory implements Exception {}
class DatabaseIsNotOpen implements Exception {}
class CouldNotDeleteUser implements Exception {}
class NotesService {

  Database? _db;

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(userTable, where: 'email = ?', whereArgs:  [email.toLowerCase()],);
    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
  final db = _db;
  if (db == null) {
    throw DatabaseIsNotOpen();
  } else {
    await db.close();
    _db = null;
  }
  }

  Future<void> open() async {
    if(_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

    //creating user table 

      
      await db.execute(createUserTable);
      await db.execute(createNoteTable);

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}



class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, 
  required this.email,});

  DatabaseUser.fromRow(Map<String,Object?> map) : 
  id = map[idColumn] as int,
  email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override bool operator == (covariant DatabaseUser other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  



}

  class DatabaseNotes {
    final int id;
    final int userId;
    final String text;
    final bool isSyncedWithCloud;

  DatabaseNotes(
  {required this.id, 
  required this.userId, 
  required this.text, 
  required this.isSyncedWithCloud}
  );

  DatabaseNotes.fromRow(Map<String,Object?> map) : 
  id = map[idColumn] as int,
  userId = map[userIdColumn] as int,
  text = map[textColumn] as String,
  isSyncedWithCloud = 
  (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() => 
  'Note, ID = $id, userId = $userId,isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override bool operator == (covariant DatabaseNotes other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  
    
  }
  const dbName = 'notes.db';
  const noteTable = 'note';
  const userTable = 'user';
  const idColumn = "id";
  const emailColumn = "email";
  const userIdColumn = "user_id";
  const textColumn = "text";
  const isSyncedWithCloudColumn = "is_synced_with_cloud";
  const createUserTable = '''CREATE TABLE IF NOT EXIST "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
  const createNoteTable = '''CREATE TABLE IF NOT EXIST "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );'''; 
