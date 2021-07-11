import 'package:flutter/material.dart';
import 'package:etiqa/screens/new_task.dart';
import 'dart:async';
import 'package:etiqa/models/task.dart';
import 'package:etiqa/utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:etiqa/utilities/utils.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class todo extends StatefulWidget {

  todo(data);

  @override
  State<StatefulWidget> createState() {
    return todo_state();
  }
}

class todo_state extends State<todo> {
  external Duration difference(DateTime other);
  var task_completed;
  DatabaseHelper databaseHelper = DatabaseHelper();
  todo_state todoState;
  TextEditingController taskController = new TextEditingController();
  String appBarTitle;
  Task task;
  Utils utility = new Utils();
  List<Task> taskList;
  int count = 0;
  bool marked;
  bool isLoaded = false;

  final scaffoldkey = GlobalKey<ScaffoldState>();

  TextStyle titleStyle = new TextStyle(
    fontSize: 18,
    fontFamily: "Lato",
  );

  TextStyle buttonStyle =
      new TextStyle(fontSize: 18, fontFamily: "Lato", color: Colors.white);
  final homeScaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    marked = false;
    super.initState();
    task_status();
  }

  task_status() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    task_completed = sharedPreferences.getString('task_completed');

  }

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }
    return Scaffold(
      key: homeScaffold,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "To-Do List",
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ), //AppBar
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                future: databaseHelper.getInCompleteTaskList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Text("Loading");
                  } else {
                    if (snapshot.data.length < 1) {
                      return Center(
                        child: Text(
                          'No Tasks Added',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int position) {
                          return new GestureDetector(
                              onTap: () {
                                if (snapshot.data[position].status !=
                                    "Task Completed")
                                  navigateToTask(snapshot.data[position],
                                      "Edit Task", this);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Card(
                                    margin: new EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 22.0,
                                        bottom: 5.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    // margin: EdgeInsets.all(15),
                                    elevation: 6,
                                    child: SizedBox(
                                      height: 170,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          SizedBox(height: 18),
                                          Row(children: <Widget>[
                                            SizedBox(width: 18),
                                            Text(
                                              snapshot.data[position].task,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ]),
                                          SizedBox(height: 18),
                                          Row(children: <Widget>[
                                            SizedBox(width: 18),
                                            Text(
                                              "Start Date",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(width: 65),
                                            Text(
                                              "End Date",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(width: 65),
                                            Text(
                                              "Time left",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ]),

                                          SizedBox(height: 12),

                                          Row(children: <Widget>[
                                            SizedBox(width: 18),
                                            Text(
                                              snapshot.data[position].startDate,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            SizedBox(width: 51),
                                            Text(
                                              snapshot.data[position].endDate,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            SizedBox(width: 45),
                                            Text("-" ?? (snapshot.data[position].endDate).difference
                                              (snapshot.data[position].startDate).inDays,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ]),
                                          SizedBox(height: 30),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 18),
                                                  Text(
                                                    "Status",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    task_completed ??
                                                        "Incomplete",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  SizedBox(width: 102),
                                                  Text(
                                                    "Tick if completed",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                  Checkbox(
                                                    checkColor: Colors.white,
                                                    value: marked,
                                                    onChanged:
                                                        (bool value) async {
                                                      SharedPreferences
                                                          sharedPreferences =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      setState(() {
                                                        if (marked = value) {
                                                          sharedPreferences
                                                              .setString(
                                                                  "task_completed",
                                                                  'Completed');
                                                        } else {
                                                          sharedPreferences
                                                              .setString(
                                                                  "task_completed",
                                                                  'Incomplete');
                                                        }
                                                      });
                                                      task_status();
                                                    },
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.amber[100],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              );
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          tooltip: "Add new To-Do List",
          child: Icon(Icons.add),
          onPressed: () {
            navigateToTask(Task('', '', '', '',''), "Add new To-Do List", this);
          }),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, //FloatingActionButton
    );
  } //build()

  void navigateToTask(Task task, String title, todo_state obj) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new_task(task, title, obj)),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  } //updateListView()
}
