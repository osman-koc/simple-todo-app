import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/constants/app_lang.dart';
import 'package:simpletodo/util/localization.dart';
import 'package:flutter/material.dart';
import 'package:simpletodo/util/toaster.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ToDo> _todosList = [];
  List<ToDo> _foundToDo = [];

  final _todoController = TextEditingController();
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
      backgroundColor: tdBGColor,
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
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: tdInputBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate(key: AppLang.addNewItem),
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
                  image: DecorationImage(
                    image: AssetImage(AppAssets.loginBtn),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdButtonColor,
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
      stream: _userTodos.snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return ListView();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        _foundToDo = _todosList = snapshot.data!.docs
            .map((e) => ToDo.fromMap(e.id, e.data() as Map<String, dynamic>))
            .toList();

        return ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 50,
                bottom: 20,
              ),
              child: Text(
                AppLocalizations.of(context).translate(key: AppLang.allTodos),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFontStyles.freestyleScript,
                ),
              ),
            ),
            for (ToDo item in _foundToDo)
              ToDoItem(
                todo: item,
                onToDoChanged: _handleToDoChange,
                onDeleteItem: _deleteToDoItem,
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
        color: tdInputBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).translate(key: AppLang.search),
          hintStyle: const TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  void _handleToDoChange(ToDo todo) async {
    await _userTodos.doc(todo.id).update({'isDone': !todo.isDone});
  }

  void _deleteToDoItem(String id) async {
    await _userTodos.doc(id).delete();
  }

  void _addToDoItem(String toDo) async {
    await _userTodos
        .add({'todoText': toDo, 'isDone': false})
        .then((value) => _todoController.clear())
        .catchError((error) => ConstToast.error(
            AppLocalizations.of(context).translate(key: AppLang.errorSave)));
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = _todosList;
    } else {
      results = _todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(AppAssets.defaultUserAvatar),
            ),
          ),
        ],
      ),
    );
  }
}
