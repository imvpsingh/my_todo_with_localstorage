import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late SharedPreferences _prefs;
  late var totalTodo;
  late var competeTodo;
  var enterTodoController = TextEditingController();
  String todoTitle = "";
  List<String> todoList = [];
  List<bool> isCompletedList = [];

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    loadTodoList();
  }

  Future<void> loadTodoList() async {
    List<String> list = await getTodoList();
    List<String> completedList = await getCompletedList();
    setState(() {
      todoList = list;
      isCompletedList = completedList.map((e) => e == '1').toList();
      totalTodo = todoList.length;
      competeTodo = isCompletedList.where((element) => element).length;
    });
  }

  Future<void> saveTodoList() async {
    await _prefs.setStringList('todoList', todoList);
    await _prefs.setStringList(
        'completedList', isCompletedList.map((e) => e ? '1' : '0').toList());
  }

  Future<List<String>> getTodoList() async {
    return _prefs.getStringList('todoList') ?? [];
  }

  Future<List<String>> getCompletedList() async {
    return _prefs.getStringList('completedList') ??
        List.filled(todoList.length, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          color: Colors.white60,
        ),
        child: TextField(
          controller: enterTodoController,
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  todoTitle = enterTodoController.text.toString();
                  if (enterTodoController.text.toString() != '') {
                    todoList.add(todoTitle);
                    isCompletedList.add(false);
                    enterTodoController.clear();
                    saveTodoList();
                    totalTodo = todoList.length;
                  }
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 25,
              ),
            ),
            border: InputBorder.none,
            hintText: "Enter new task here.....",
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: Colors.white54),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "TODO DONE",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "keep it up",
                        style: TextStyle(fontSize: 14, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 30, left: 50),
                  height: 250,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.yellowAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "$competeTodo/$totalTodo",
                      style: GoogleFonts.bebasNeue(
                        textStyle: const TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 35.0, bottom: 10),
                    child: Text(
                      'YOUR TODO LIST',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  todoList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todoList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final reversedIndex = todoList.length - 1 - index;
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  top: 20, right: 10, left: 10),
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                ),
                                color: isCompletedList[reversedIndex]
                                    ? const Color(0xff06f506)
                                    : Colors.yellowAccent,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    activeColor: const Color(0xff000000),
                                    checkColor: Colors.white,
                                    value: isCompletedList[reversedIndex],
                                    onChanged: (value) {
                                      setState(() {
                                        isCompletedList[reversedIndex] = value!;
                                        saveTodoList().then((_) {
                                          setState(() {
                                            competeTodo = isCompletedList
                                                .where((element) => element)
                                                .length;
                                          }); // Force rebuild to reflect immediate changes
                                        });
                                      });
                                    },
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxHeight: 25), // Set maximum height
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            todoList[reversedIndex],
                                            style: TextStyle(
                                              fontSize:
                                                  isCompletedList[reversedIndex]
                                                      ? 14
                                                      : 15,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  isCompletedList[reversedIndex]
                                                      ? TextDecoration.lineThrough
                                                      : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          todoList.removeAt(reversedIndex);
                                          isCompletedList
                                              .removeAt(reversedIndex);
                                          saveTodoList();
                                          totalTodo = todoList.length;
                                          setState(() {
                                            competeTodo = isCompletedList
                                                .where((element) => element)
                                                .length;
                                          });
                                        });
                                      },
                                      child: const Icon(Icons.delete_forever),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              Text(
                                'No Data Available',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white24,
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
