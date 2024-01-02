class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  factory ToDo.fromMap(String? id, Map<String, dynamic> map) {
    return ToDo(
      id: id,
      todoText: map['todoText'] as String?,
      isDone: map['isDone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }
}
