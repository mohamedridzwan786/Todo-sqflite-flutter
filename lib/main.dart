import 'package:flutter/material.dart';
import 'package:etiqa/screens/todo_list.dart';

final routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
     new MyApp()
    );
}

class MyApp extends StatelessWidget{
  get data => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: todo(data),
    );
  }

}