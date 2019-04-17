class Note {
  int id;

  final String body;

  Note({
    this.body,
    this.id,
  });

  Note.fromMap(Map<String, dynamic> map) : this.body = map['body'];

  Map<String, dynamic> toMap() {
    return {
      'body': body,
    };
  }
}
