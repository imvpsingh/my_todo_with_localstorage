import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var totalTodo;
  late var competeTodo;
  var enterTodoController = TextEditingController();
  bool isCompleted = false;
  String todoTitle = "";
  var todoList = [
    "KISI KO KUCH NAHI BTANA THA",
    "SABSE ACHA KON HAI",
    "HEy RAm YE Kya Hogya",
    "Aye Dil Bta Ye tuje Kya huaa"
  ];
  List<bool> isCompletedList = [];
@override
  void initState() {
  totalTodo = todoList.length;
  competeTodo = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.white54),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 250,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "TODO DONE",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "keep it up",
                            style:
                            TextStyle(fontSize: 12, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 30, bottom: 30, left: 50),
                      height: 250,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "$competeTodo/$totalTodo",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 45,
                width: double.infinity,
                margin: EdgeInsets.only(top: 15, right: 40, left: 40),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.grey,
                ),
                child: TextField(
                  controller: enterTodoController,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {

                            todoTitle = enterTodoController.text.toString();
                            if(enterTodoController.text.toString() != ''){
                            todoList.add(todoTitle); // Add the new todo to the list
                            enterTodoController.clear();
                            totalTodo = todoList.length;
                            competeTodo = isCompletedList.where((element) => element).length;
                          }

                        });
                      },
                      child: Icon(
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= isCompletedList.length) {

                    isCompletedList.add(false);
                  }
                  return Container(
                    // height: 45,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.grey,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isCompletedList[index], // Use the completion state for this item
                          onChanged: (value) {
                            setState(() {
                              isCompletedList[index] = value!;
                              totalTodo = todoList.length;
                              competeTodo = isCompletedList.where((element) => element).length;
                            });
                          },
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            todoList[index],
                            style: TextStyle(
                              fontSize: isCompletedList[index] ? 13 : 16,
                              fontWeight: FontWeight.bold,
                              decoration: isCompletedList[index]
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                todoList.removeAt(index);
                                isCompletedList.removeAt(index);
                                totalTodo = todoList.length;
                                competeTodo = isCompletedList.where((element) => element).length;
                              });
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
