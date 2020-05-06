class Note {
  String noteId;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime editedLastDateTime;

  Note({
    this.noteId,
    this.noteTitle,
    this.noteContent,
    this.createDateTime,
    this.editedLastDateTime,
  });

  factory Note.fromJson(Map<String, dynamic> jsonData) {
    return Note(
      noteId: jsonData['noteID'],
      noteTitle: jsonData['noteTitle'],
      noteContent: jsonData['noteContent'],
      createDateTime: DateTime.parse(jsonData['createDateTime']),
      editedLastDateTime: jsonData['latestEditDateTime'] != null
          ? DateTime.parse(jsonData['latestEditDateTime'])
          : null,
    );
  }
}
