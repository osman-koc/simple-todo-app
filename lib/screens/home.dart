import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/extensions/app_lang.dart';
import 'package:simpletodo/popup/about.dart';
import 'package:simpletodo/screens/splash.dart';
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

  late User _user;
  late CollectionReference _userTodos;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _userTodos = FirebaseFirestore.instance
        .collection('todos')
        .doc(_user.uid)
        .collection('user_todos');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors(context).tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
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
                const SizedBox(height: 80),
              ],
            ),
          ),
          Align(
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
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ]),
          ),
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
          });
        },
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors(context).tdTextColor,
            size: 20,
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          menuWidget(),
          profileWidget(),
        ],
      ),
    );
  }

  SizedBox menuWidget() {
    return SizedBox(
      height: 40,
      width: 40,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        onSelected: (value) async {
          if (value == context.translate.about) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AboutScreenPopup();
              },
            );
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: context.translate.home,
              child: ListTile(
                title: Text(context.translate.home),
                onTap: () {
                  Navigator.of(context).pop(context.translate.home);
                },
              ),
            ),
            PopupMenuItem<String>(
              value: context.translate.about,
              child: ListTile(
                title: Text(context.translate.about),
                onTap: () {
                  Navigator.of(context).pop(context.translate.about);
                },
              ),
            ),
          ];
        },
        child: Container(
          padding: const EdgeInsets.only(left: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Icon(
              Icons.menu,
              color: AppColors(context).tdTextColor,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox profileWidget() {
    return SizedBox(
      height: 40,
      width: 40,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        onSelected: (value) async {
          if (value == context.translate.logout) {
            await _logout();
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: context.translate.logout,
              child: ListTile(
                title: Text(context.translate.logout),
                onTap: () {
                  Navigator.of(context).pop(context.translate.logout);
                },
              ),
            ),
          ];
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(AppAssets.defaultUserAvatar),
        ),
      ),
    );
  }

  _logout() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            ))
        .catchError((error) => ConstToast.error(context.translate.errorLogout));
  }
}
