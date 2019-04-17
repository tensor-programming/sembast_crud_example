import 'package:sembast/sembast.dart';
import 'package:sembast_crud_example/database/database.dart';
import 'package:sembast_crud_example/models/model.dart';

class DBLogic {
  static const String STORE = 'notes';

  final _notes = intMapStoreFactory.store(STORE);

  Future<Database> get db async => await NoteDB.instance.db;

  Future insert(Note note) async {
    await _notes.add(await db, note.toMap());
  }

  Future update(Note note) async {
    final finder = Finder(filter: Filter.byKey(note.id));

    await _notes.update(
      await db,
      note.toMap(),
      finder: finder,
    );
  }

  Future delete(Note note) async {
    final finder = Finder(filter: Filter.byKey(note.id));

    await _notes.delete(
      await db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _notes.delete(
      await db,
    );
  }

  Future<List<Note>> getAllNotes() async {
    final snapshot = await _notes.find(await db);

    return snapshot.map((map) {
      final note = Note.fromMap(map.value);

      note.id = map.key;
      return note;
    }).toList();
  }
}
