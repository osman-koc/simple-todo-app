import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simpletodo/constants/app_assets.dart';
import 'package:simpletodo/constants/app_font_styles.dart';
import 'package:simpletodo/extensions/app_lang.dart';
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
  final _todoController = TextEditingController();
  final _searchController = TextEditingController();

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
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFontStyles.freestyleScript,
                ),
              ),
            ),
            for (ToDoModel item in foundToDo)
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
        onChanged: (value) {
          setState(() {
            _searchController.text = value;
          });
        },
        controller: _searchController,
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
          hintText: context.translate.search,
          hintStyle: const TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  void _handleToDoChange(ToDoModel todo) async {
    await _userTodos.doc(todo.id).update({'isDone': !todo.isDone});
  }

  void _deleteToDoItem(String id) async {
    await _userTodos.doc(id).delete();
  }

  void _addToDoItem(String toDoText) async {
    await _userTodos
        .add({
          'todoText': toDoText,
          'isDone': false,
          'creationDate': FieldValue.serverTimestamp()
        })
        .then((value) => _todoController.clear())
        .catchError((error) => ConstToast.error(context.translate.errorSave));
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
