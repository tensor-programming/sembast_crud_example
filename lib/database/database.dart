import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sembast_crud_example/models/model.dart';

import 'dart:async';

class NoteDB {
  NoteDB._internal();

  static NoteDB get instance => _singleton;

  static final NoteDB _singleton = NoteDB._internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();

    return _db;
  }

  Future initDB() async {
    final documentDIR = await getApplicationDocumentsDirectory();
    final dbPath = join(documentDIR.path, 'note.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }
}
