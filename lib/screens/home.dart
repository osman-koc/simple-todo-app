import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpletodo/components/side_menu.dart';

import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/extensions/app_lang.dart';
import 'package:simpletodo/util/toaster.dart';
import 'package:simpletodo/model/todo.dart';
import 'package:simpletodo/constants/app_colors.dart';
import 'package:simpletodo/widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _todoController = TextEditingController();
  final _searchController = TextEditingController();
  final _updateController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late User _user;
  late CollectionReference _userTodos;
  bool _searchingEnable = false;

  @override
  void initState() {
    super.initState();

    _user = FirebaseAuth.instance.currentUser!;
    _userTodos = FirebaseFirestore.instance
        .collection('todos')
        .doc(_user.uid)
        .collection('user_todos');

    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          setSearchingEnabled(_searchController.text.isNotEmpty);
        });
      }
    });
  }

  void setSearchingEnabled(bool value) {
    _searchingEnable = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors(context).tdBGColor,
      appBar: _buildAppBar(),
      drawer: SideMenu(currentUser: _user),
      body: Stack(
        children: [
          todoListContainer(context),
          !_searchingEnable
              ? addNewItemAlign(context)
              : const SizedBox(height: 1),
        ],
      ),
    );
  }

  Align addNewItemAlign(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 22,
              right: 18,
              left: 20,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors(context).tdBGColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: _todoController,
              decoration: InputDecoration(
                hintText: context.translate.addNewItem,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(AppAssets.loginBtn),
              fit: BoxFit.cover,
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              _addToDoItem(_todoController.text.trim());
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: AppColors(context).tdButtonColor,
              minimumSize: const Size(60, 60),
              elevation: 10,
            ),
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 40,
                color: AppColors(context).tdBGColor
              ),
            ),
          ),
        ),
        const SizedBox(height: 50)
      ]),
    );
  }

  Container todoListContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Column(
        children: [
          searchBox(context),
          Expanded(
            child: todoListWidget(context),
          ),
          !_searchingEnable
              ? const SizedBox(height: 80)
              : const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget todoListWidget(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userTodos.orderBy('creationDate', descending: true).snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return ListView();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<ToDoModel> todosList = snapshot.data!.docs
            .map((e) =>
                ToDoModel.fromMap(e.id, e.data() as Map<String, dynamic>))
            .toList();

        List<ToDoModel> foundToDo = todosList
            .where((item) => item.todoText!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();

        if (foundToDo.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            child: Text(
              context.translate.noRecords,
              style: TextStyle(
                color: AppColors(context).tdTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 50,
                bottom: 20,
              ),
              child: Text(
                context.translate.allTodos,
                style: TextStyle(
                  color: AppColors(context).tdTextColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFontStyles.freestyleScript,
                ),
              ),
            ),
            for (ToDoModel item in foundToDo)
              ToDoItem(
                todo: item,
                onToDoChanged: _handleToDoUpdate,
                onDeleteItem: _deleteToDoItem,
                onCheckItem: _updateStatusToDoItem,
              ),
          ],
        );
      }),
    );
  }

  Container searchBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors(context).tdInputBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchController.text = value;
            setSearchingEnabled(true);
          });
        },
        onTap: () {
          setState(() {
            setSearchingEnabled(true);
          });
        },
        onEditingComplete: () {
          setState(() {
            setSearchingEnabled(_searchController.text.isNotEmpty);
            _searchFocusNode.unfocus();
          });
        },
        focusNode: _searchFocusNode,
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: GestureDetector(
            onTap: () {
              setState(() {
                if (_searchingEnable) {
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                  setSearchingEnabled(false);
                }
              });
            },
            child: Icon(
              _searchingEnable ? Icons.close : Icons.search,
              color: AppColors(context).tdTextColor,
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: context.translate.search,
          hintStyle: TextStyle(color: AppColors(context).tdGrey),
        ),
      ),
    );
  }

  void _handleToDoUpdate(ToDoModel todo) async {
    if (todo.id == null) return;
    if (todo.isDone) {
      ConstToast.error(context.translate.updateDoneItemError);
      return;
    }

    _updateController.text = todo.todoText ?? '';
    showUpdateDialog(todo);
  }

  void showUpdateDialog(ToDoModel todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.translate.todoItemUpdateHeader),
          content: TextField(
            controller: _updateController,
            decoration: InputDecoration(
              hintText: context.translate.enterNewValue,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.translate.cancel),
            ),
            TextButton(
              onPressed: () {
                String newTodoText = _updateController.text.trim();
                if (newTodoText.isEmpty) {
                  ConstToast.error(context.translate.todoItemEmptyMessage);
                } else {
                  _updateToDoItem(todo.id!, newTodoText);
                  Navigator.pop(context);
                }
              },
              child: Text(context.translate.save),
            ),
          ],
        );
      },
    );
  }

  void _updateStatusToDoItem(ToDoModel todo) async {
    await _userTodos.doc(todo.id).update({'isDone': !todo.isDone});
  }

  void _updateToDoItem(String id, String newTodoText) async {
    await itemCheck(id, newTodoText, () async {
      await _userTodos.doc(id).update({'todoText': newTodoText});
    });
  }

  void _deleteToDoItem(String id) {
    _userTodos
        .doc(id)
        .delete()
        .then((r) =>
            ConstToast.success(context.translate.deleteItemSuccessMessage))
        .catchError((e) =>
            ConstToast.success(context.translate.deleteItemErrorMessage));
  }

  void _addToDoItem(String toDoText) async {
    await itemCheck(null, toDoText, () async {
      await _userTodos.add({
        'todoText': toDoText,
        'isDone': false,
        'creationDate': FieldValue.serverTimestamp()
      }).then((value) {
        //ConstToast.success(context.translate.todoItemSuccessMessage);
        _todoController.clear();
      }).catchError((error) {
        ConstToast.error(context.translate.errorSave);
      });
    });
  }

  Future itemCheck(
      String? id, String toDoText, void Function() onSuccessCallback) async {
    toDoText = toDoText.trim();
    if (toDoText.isEmpty) {
      ConstToast.error(context.translate.todoItemEmptyMessage);
    } else {
      Query query = _userTodos.where('todoText', isEqualTo: toDoText);
      query.get().then((snapshot) {
        bool itemExists = id == null
            ? snapshot.docs.isNotEmpty
            : snapshot.docs.where((x) => x.id != id).isNotEmpty;
        if (itemExists) {
          ConstToast.error(context.translate.todoItemExistsMesage);
        } else {
          onSuccessCallback();
        }
      }).catchError((error) {
        ConstToast.error(context.translate.errorSave);
      });
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors(context).tdBGColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors(context).tdTextColor),
    );
  }
}
