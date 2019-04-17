enum NotesState {
  GETALL,
  INSERT,
  UPDATE,
  DETLETE,
  DELETE_ALL,
  NOOP,
}

class Note {
  int id;

  NotesState state;

  final String body;

  Note({
    this.body,
    this.state,
    this.id,
  });

  Note copyWith({String body, NotesState state, int id}) {
    return Note(
      body: body ?? this.body,
      state: state ?? this.state,
      id: id ?? this.id,
    );
  }

  Note.fromMap(Map<String, dynamic> map)
      : this.body = map['body'],
        this.state = NotesState.values[map['state']];

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'state': state.index,
    };
  }
}
