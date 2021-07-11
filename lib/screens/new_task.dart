import 'package:flutter/material.dart';
import 'package:etiqa/utilities/database_helper.dart';
import 'package:etiqa/models/task.dart';
import 'package:etiqa/screens/todo_list.dart';
import 'package:etiqa/utilities/utils.dart';
import 'dart:convert';
import 'dart:core';
import 'package:intl/intl.dart';

var globalDate = "Pick Date";

class new_task extends StatefulWidget {
  final String appBarTitle;
  final Task task;
  todo_state todoState;
  new_task(this.task, this.appBarTitle, this.todoState);
  bool _isEditable = false;

  @override
  State<StatefulWidget> createState() {
    return task_state(this.task, this.appBarTitle, this.todoState);
  }
}

class task_state extends State<new_task> {


  todo_state todoState;
  String appBarTitle;
  Task task;
  List<Widget> icons;
  task_state(this.task, this.appBarTitle, this.todoState);

  bool marked = false;

  TextStyle titleStyle = new TextStyle(
    fontSize: 18,
    fontFamily: "Lato",
  );

  TextStyle buttonStyle =
      new TextStyle(fontSize: 18, fontFamily: "Lato", color: Colors.white);

  final scaffoldkey = GlobalKey<ScaffoldState>();

  DatabaseHelper helper = DatabaseHelper();
  Utils utility = new Utils();
  TextEditingController taskController = new TextEditingController();


  var formattedstartDate = "Pick Date";
  var formattedendDate = "Select Time";
  var formattedtimeleft = "time left";
  var _minPadding = 10.0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay();

  @override
  Widget build(BuildContext context) {
    taskController.text = task.task;
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          leading: new GestureDetector(
            child: Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.black),
            onTap: () {
              Navigator.pop(context);
              todoState.updateListView();
            },
          ),
          title: Text(appBarTitle, style: TextStyle(fontSize: 23, color: Colors.black, fontWeight: FontWeight.w800)),
        ),
        body: ListView(children: <Widget>[

          SizedBox(height: 45),
          Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 16,right: 16),
              child: Text(
                "To-Do Title",
                style: titleStyle,
              )
          ),

          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 16,right: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              // borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              maxLines: 100,
              decoration: new InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    )),
                hintText: 'Please key in your To-Do title here',
              ),
              controller: taskController,
              onChanged: (value) {
                updateTask();
              },
            ),
          ),
          SizedBox(height: 22),


          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 16,right: 16),
            child: Text(
                "Start Date",
                style: titleStyle,
              )
          ),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 16,right: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              // borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: task.startDate.isEmpty
                  ? Text(
                "Select a date",
                style: titleStyle,
              )
                  : Text(task.startDate),
              subtitle: Text(""),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: () async {
                var pickedDate = await utility.selectDate(context, task.startDate);
                if (pickedDate != null && !pickedDate.isEmpty)
                  setState(() {
                    this.formattedstartDate = pickedDate.toString();
                    task.startDate = formattedstartDate;

                  });
              },
            ), //Dat
          ),

          SizedBox(height: 28),


          Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 16,right: 16),
              child: Text(
                "Estimated End Date",
                style: titleStyle,
              )
          ),

          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 16,right: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              // borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: task.endDate.isEmpty
                  ? Text(
                "Select a date",
                style: titleStyle,
              )
                  : Text(task.endDate),
              subtitle: Text(""),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: () async {
                var pickedDate = await utility.selectDate(context, task.endDate);
                if (pickedDate != null && !pickedDate.isEmpty)
                  setState(() {
                    this.formattedendDate = pickedDate.toString();
                    task.endDate = formattedendDate;

                    // this.formattedtimeleft = (formattedendDate).difference(formattedstartDate);
                    // task.timeLeft = formattedtimeleft;
                    //  the different between "two dates" is not working
                  });
              },
            ), //Dat
          ),

        ]),
        bottomNavigationBar: BottomAppBar(
    child:Container( height: 60,
        child: RaisedButton(
    child: Text("Create Now"),
    color: Colors.black,
    textColor: Colors.white,
    onPressed: () {
    _save();
    },
    )),
    ),//ListView

        ); //Scaffold
  } //build()

  void markedDone() {}

  bool _isEditable() {
    if (this.appBarTitle == "Add new To-Do List")
      return false;
    else {
      return true;
    }
  }

  void updateTask() {
    task.task = taskController.text;
  }

  //InputConstraints
  bool _checkNotNull() {
    bool res;
    if (taskController.text.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Task cannot be empty');
      res = false;
    } else if (task.startDate.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Please select the Date');
      res = false;
    } else if (task.endDate.isEmpty) {
      utility.showSnackBar(scaffoldkey, 'Please select the Date');
      res = false;
    }

    else {
      res = true;
    }
    return res;
  }

  //Save data
  void _save() async {
    int result;
    if(_isEditable()) {
      if (marked) {
        task.status = "Task Completed";
      }
      else
        task.status = "";
    }


    if (_checkNotNull() == true) {
      if (task.id != null) {
        //Update Operation
        result = await helper.updateTask(task);
      } else {
        //Insert Operation
        result = await helper.insertTask(task);
      }

      todoState.updateListView();

      Navigator.pop(context);

      if (result != 0) {
        utility.showAlertDialog(context, 'Status', 'Task saved successfully.');
      } else {
        utility.showAlertDialog(context, 'Status', 'Problem saving task.');
      }
    }
  } //_save()
} //class task_state
