import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_colors.dart';
import 'package:simpletodo/extensions/app_lang.dart';
import 'package:simpletodo/model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDoModel todo;
  final dynamic onToDoChanged;
  final dynamic onDeleteItem;
  final dynamic onCheckItem;

  const ToDoItem(
      {Key? key,
      required this.todo,
      required this.onToDoChanged,
      required this.onDeleteItem,
      required this.onCheckItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        tileColor: todo.isDone
            ? AppColors(context).tdInputBgColorDone
            : AppColors(context).tdInputBgColor,
        leading: InkWell(
          onTap: () {
            onCheckItem(todo);
          },
          child: Icon(
            todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            color: todo.isDone
                ? AppColors(context).tdGreen
                : AppColors(context).tdGrey,
          ),
        ),
        // leading: Icon(
        //   todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
        //   color: todo.isDone ? tdGreen : tdGrey,
        // ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: todo.isDone
                ? AppColors(context).tdTextColorDone
                : AppColors(context).tdTextColor,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            decorationColor: todo.isDone
                ? AppColors(context).tdTextColorDone
                : AppColors(context).tdTextColor,
            decorationStyle: TextDecorationStyle.solid,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.only(bottom: 10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 35,
          width: 35,
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppColors(context).tdButtonColor,
            iconSize: 26,
            onPressed: () {
              _showDeleteConfirmationDialog(context, todo.id);
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String? todoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.translate.delete),
          content: Text(context.translate.areYouSureForDelete),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(context.translate.cancel),
            ),
            TextButton(
              onPressed: () {
                onDeleteItem(todoId);
                Navigator.of(context).pop();
              },
              child: Text(context.translate.yes),
            ),
          ],
        );
      },
    );
  }
}
