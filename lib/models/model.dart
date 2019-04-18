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
  bool editing;

  final String body;

  Note({
    this.body,
    this.editing = false,
    this.state,
    this.id,
  });

  Note copyWith({
    String body,
    NotesState state,
    int id,
    bool editing,
  }) {
    return Note(
      body: body ?? this.body,
      state: state ?? this.state,
      editing: editing ?? this.editing,
      id: id ?? this.id,
    );
  }

  Note.fromMap(Map<String, dynamic> map)
      : this.body = map['body'],
        this.editing = map['editing'],
        this.state = NotesState.values[map['state']];

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'editing': editing,
      'state': state.index,
    };
  }
}
