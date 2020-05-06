class NoteList {
  String noteId;
  String noteTitle;
  DateTime createDateTime;
  DateTime editedLastDateTime;

  NoteList({
    this.noteId,
    this.noteTitle,
    this.createDateTime,
    this.editedLastDateTime,
  });

  factory NoteList.fromJson(Map<String, dynamic> item) {
    return NoteList(
      noteId: item['noteID'],
      noteTitle: item['noteTitle'],
      createDateTime: DateTime.parse(item['createDateTime']),
      editedLastDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
