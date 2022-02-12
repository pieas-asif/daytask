import 'package:daytask/controller/db.dart';
import 'package:daytask/models/constants.dart';
import 'package:daytask/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBProvider _dbProvider = DBProvider.instance;
  final TextEditingController taskTextFieldController = TextEditingController();
  final FocusNode taskTextFieldFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Task> tasks = [];
  int taskCounter = 0;
  int completedTaskCounter = 0;
  bool updateTask = false;
  Task? updateableTask;
  late DateTime dateTime;
  late DateTime taskDate;

  @override
  void initState() {
    dateTime = DateTime.now();
    taskDate = dateTime;
    fetchTasksFromDB();
    super.initState();
  }

  void fetchTasksFromDB() async {
    List<Map<String, dynamic>> tableData = await _dbProvider.query(
      TaskTable.name,
      where: "${TaskTable.colTaskDate} = ?",
      whereArgs: [
        taskDate.toString().split(" ").first,
      ],
    );

    tasks = [];
    taskCounter = 0;
    completedTaskCounter = 0;
    for (Map<String, dynamic> data in tableData) {
      taskCounter += 1;
      if (data[TaskTable.colIsChecked] == 1) completedTaskCounter += 1;
      tasks.add(
        Task(
          id: data["id"],
          task: data[TaskTable.colTaskTitle],
          isCompleted: data[TaskTable.colIsChecked] == 0 ? false : true,
        ),
      );
    }

    setState(() {});
  }

  void addTaskToDB({required String task}) async {
    await _dbProvider.insert(TaskTable.name, {
      TaskTable.colIsChecked: 0,
      TaskTable.colTaskDate: dateTime.toString().split(" ").first,
      TaskTable.colTaskTitle: task
    });

    fetchTasksFromDB();
  }

  void updateTaskToDB({
    required Task task,
    required String text,
  }) async {
    await _dbProvider.update(
      TaskTable.name,
      {TaskTable.colTaskTitle: text},
      where: "id = ?",
      whereArgs: [task.id],
    );
    setState(() {
      task.task = text;
    });
  }

  void toggleCompleted(Task task) async {
    await _dbProvider.update(
      TaskTable.name,
      {TaskTable.colIsChecked: task.isCompleted == false ? 1 : 0},
      where: "id = ?",
      whereArgs: [task.id],
    );

    setState(() {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        completedTaskCounter += 1;
      } else {
        completedTaskCounter -= 1;
      }
    });
  }

  void deleteTask(Task task) async {
    await _dbProvider.delete(
      TaskTable.name,
      where: "id = ?",
      whereArgs: [task.id],
    );

    setState(() {
      if (task.isCompleted) completedTaskCounter -= 1;
      taskCounter -= 1;
      tasks.remove(task);
    });
  }

  String? greet() {
    int hours = dateTime.hour;
    String? greeting;

    if (hours >= 0 && hours <= 12) {
      greeting = "Good Morning";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Noon";
    } else if (hours >= 16 && hours <= 18) {
      greeting = "Good Afternoon";
    } else if (hours >= 18 && hours <= 21) {
      greeting = "Good Evening";
    } else if (hours >= 21 && hours <= 24) {
      greeting = "Good Night";
    }

    return greeting;
  }

  _setTaskDate({DateTime? date}) {
    setState(() {
      taskDate = date ?? dateTime;
    });
    fetchTasksFromDB();
  }

  _moveTaskToDate({
    required Task task,
    DateTime? date,
  }) async {
    await _dbProvider.update(
      TaskTable.name,
      {
        TaskTable.colTaskDate: date?.toString().split(" ").first ??
            dateTime.toString().split(" ").first,
      },
      where: "id = ?",
      whereArgs: [task.id],
    );
    fetchTasksFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DTTheme.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Agenda",
                    style: TextStyle(
                      fontSize: 24,
                      color: DTTheme.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                    child: Icon(
                      FeatherIcons.menu,
                      color: DTTheme.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    greet() ?? "Hello there, ",
                    style: TextStyle(
                      fontSize: 16,
                      color: DTTheme.white,
                    ),
                  ),
                  Text(
                    "Today is ${DateFormat('EEEE').format(dateTime)}, ${DateFormat('MMMM d, y').format(dateTime)}.",
                    style: TextStyle(
                      fontSize: 16,
                      color: DTTheme.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  MaterialButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: taskDate,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025),
                      ).then((value) => _setTaskDate(date: value));
                    },
                    color: DTTheme.white,
                    child: Text(
                      dateTime.toString().split(" ").first ==
                              taskDate.toString().split(" ").first
                          ? "TODAY"
                          : taskDate.toString().split(" ").first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: DTTheme.black,
                      ),
                    ),
                  ),
                  Text(
                    "$completedTaskCounter out of $taskCounter completed",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: DTTheme.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i in tasks)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              toggleCompleted(i);
                            },
                            icon: Icon(
                              i.isCompleted
                                  ? FeatherIcons.checkSquare
                                  : FeatherIcons.square,
                              color: DTTheme.white,
                            ),
                          ),
                          title: Text(
                            i.task,
                            style: TextStyle(
                              color: DTTheme.white,
                              decoration: i.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(FeatherIcons.moreHorizontal),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Text("Edit"),
                                value: 1,
                              ),
                              const PopupMenuItem(
                                child: Text("Delete"),
                                value: 2,
                              ),
                              const PopupMenuItem(
                                child: Text("Move"),
                                value: 3,
                              ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  {
                                    setState(() {
                                      updateTask = true;
                                      updateableTask = i;
                                      taskTextFieldController.text = i.task;
                                    });
                                    taskTextFieldFocusNode.requestFocus();
                                  }
                                  break;
                                case 2:
                                  {
                                    deleteTask(i);
                                  }
                                  break;
                                case 3:
                                  {
                                    showDatePicker(
                                      context: context,
                                      initialDate: taskDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2025),
                                    ).then(
                                      (value) => _moveTaskToDate(
                                        date: value,
                                        task: i,
                                      ),
                                    );
                                  }
                                  break;
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: dateTime.toString().split(" ").first ==
                      taskDate.toString().split(" ").first
                  ? Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: TextField(
                              controller: taskTextFieldController,
                              focusNode: taskTextFieldFocusNode,
                              cursorColor: DTTheme.white,
                              cursorWidth: 3.0,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  borderSide: BorderSide(
                                    color: DTTheme.white,
                                    width: 3.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  borderSide: BorderSide(
                                    color: DTTheme.white,
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  borderSide: BorderSide(
                                    color: DTTheme.white,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              onSubmitted: (task) {
                                if (!updateTask) {
                                  addTaskToDB(task: task);
                                  taskTextFieldController.clear();
                                  taskTextFieldFocusNode.unfocus();
                                } else {
                                  if (updateableTask != null) {
                                    updateTaskToDB(
                                      task: updateableTask!,
                                      text: task,
                                    );
                                    taskTextFieldController.clear();
                                    setState(() {
                                      updateTask = false;
                                      updateableTask = null;
                                    });
                                    taskTextFieldFocusNode.unfocus();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 80,
                          decoration: BoxDecoration(
                            color: DTTheme.white,
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                String task =
                                    taskTextFieldController.value.text;
                                if (task.isNotEmpty) {
                                  if (!updateTask) {
                                    addTaskToDB(task: task);
                                    taskTextFieldController.clear();
                                    taskTextFieldFocusNode.unfocus();
                                  } else {
                                    if (updateableTask != null) {
                                      updateTaskToDB(
                                        task: updateableTask!,
                                        text: task,
                                      );
                                      taskTextFieldController.clear();
                                      setState(() {
                                        updateTask = false;
                                        updateableTask = null;
                                      });
                                      taskTextFieldFocusNode.unfocus();
                                    }
                                  }
                                } else {
                                  // TODO: some to do here
                                }
                              },
                              icon: Icon(
                                FeatherIcons.send,
                                color: DTTheme.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : MaterialButton(
                      onPressed: () => _setTaskDate(),
                      child: Text(
                        "BACK TO TODAY",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: DTTheme.black,
                        ),
                      ),
                      color: DTTheme.white,
                      height: 55,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
