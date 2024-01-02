import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_lang.dart';
import 'package:simpletodo/lang/app_localizations.dart';

import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  void _showDeleteConfirmationDialog(BuildContext context, String? todoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate(key: AppLang.delete)),
          content: Text(AppLocalizations.of(context).translate(key: AppLang.areYouSureForDelete)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate(key: AppLang.no)),
            ),
            TextButton(
              onPressed: () {
                onDeleteItem(todoId);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate(key: AppLang.yes)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // print('Clicked on Todo Item.');
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: tdInputBgColor,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdGrey,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: tdButtonColor,
            iconSize: 26,
            onPressed: () {
              _showDeleteConfirmationDialog(context, todo.id);
            },
          ),
        ),
      ),
    );
  }
}
