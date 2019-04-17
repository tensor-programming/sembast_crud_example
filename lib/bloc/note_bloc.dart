import 'dart:async';
import 'package:sembast_crud_example/models/model.dart';
import 'package:sembast_crud_example/database/crud.dart';

class NoteBloc {
  final DBLogic logic;

  StreamController<List<Note>> _notes = StreamController.broadcast();

  StreamController<Note> _incoming = StreamController();

  Stream<List<Note>> get outgoing => _notes.stream;

  StreamSink<Note> get inSink => _incoming.sink;

  NoteBloc(this.logic) {
    _incoming.stream.listen((note) async {
      switch (note.state) {
        case NotesState.INSERT:
          logic.insert(note).then((_) async => {
                _notes.add(await logic.getAllNotes()),
              });
          break;
        case NotesState.UPDATE:
          logic.update(note).then((_) async => {
                _notes.add(await logic.getAllNotes()),
              });
          break;
        case NotesState.GETALL:
          _notes.add(await logic.getAllNotes());
          break;
        case NotesState.DETLETE:
          logic.delete(note).then((_) async => {
                _notes.add(await logic.getAllNotes()),
              });
          break;
        case NotesState.DELETE_ALL:
          logic.deleteAll().then((_) async => {
                _notes.add(await logic.getAllNotes()),
              });
          break;
        case NotesState.NOOP:
          break;
      }
    });
  }

  void dispose() {
    _incoming.close();
    _notes.close();
  }
}
