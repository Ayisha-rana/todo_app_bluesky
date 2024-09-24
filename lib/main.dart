import 'package:flutter/material.dart';
import 'package:todo_app_bluesky/frontend/getstartedpage.dart';
import 'package:todo_app_bluesky/frontend/loginpage.dart';
import 'package:todo_app_bluesky/frontend/tasklistpage.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      home: LoginPage(),
    );
  }
}
