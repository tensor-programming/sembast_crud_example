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
    _incoming.stream.listen((notes) async {});
  }
}
