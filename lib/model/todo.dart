import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoModel {
  String? id;
  String? todoText;
  bool isDone;
  DateTime? creationDate;

  ToDoModel({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.creationDate,
  });

  factory ToDoModel.fromMap(String? id, Map<String, dynamic> map) {
    var timestamp = map['creationDate'] as Timestamp?;
    var date = timestamp?.toDate();

    return ToDoModel(
      id: id,
      todoText: map['todoText'] as String?,
      isDone: map['isDone'] as bool? ?? false,
      creationDate: date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
      'creationDate': FieldValue.serverTimestamp(),
    };
  }
}
