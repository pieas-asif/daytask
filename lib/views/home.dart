import 'package:daytask/controller/db.dart';
import 'package:daytask/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBProvider _dbProvider = DBProvider.instance;
  TextEditingController taskTextFieldController = TextEditingController();

  void addTaskToDB({required String task}) async {
    await _dbProvider.insert(TaskTable.name, {
      TaskTable.colIsChecked: 0,
      TaskTable.colTaskDate: DateTime.now().toString().split(" ").first,
      TaskTable.colTaskTitle: task
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onTap: () =>
                        print(DateTime.now().toString().split(" ").first),
                    child: Icon(
                      FeatherIcons.settings,
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
                    "Good Morning, ",
                    style: TextStyle(
                      fontSize: 16,
                      color: DTTheme.white,
                    ),
                  ),
                  Text(
                    "Today is Friday, 17-12-2021.",
                    style: TextStyle(
                      fontSize: 16,
                      color: DTTheme.white,
                    ),
                  ),
                  Text(
                    "It's 19°C in Dhaka, Bangladesh.",
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
                top: 30.0,
                bottom: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "Goals",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DTTheme.white,
                    ),
                  ),
                  Text(
                    "3 out of 5 completed",
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
                    for (var i = 0; i < 2; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ListTile(
                          leading: Icon(
                            FeatherIcons.square,
                            color: DTTheme.white,
                          ),
                          title: Text(
                            "This task needs to be completed",
                            style: TextStyle(
                              color: DTTheme.white,
                            ),
                          ),
                          trailing: const IconButton(
                            onPressed: null,
                            icon: Icon(FeatherIcons.moreHorizontal),
                          ),
                        ),
                      ),
                    for (var i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ListTile(
                          leading: Icon(
                            FeatherIcons.checkSquare,
                            color: DTTheme.white,
                          ),
                          title: Text(
                            "This task is completed",
                            style: TextStyle(
                              color: DTTheme.white,
                            ),
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: TextField(
                        controller: taskTextFieldController,
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
                          addTaskToDB(task: task);
                          taskTextFieldController.clear();
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                      color: DTTheme.white,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          String task = taskTextFieldController.value.text;
                          if (task.isNotEmpty) {
                            addTaskToDB(task: task);
                            taskTextFieldController.clear();
                          } else {
                            print("Empty");
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
