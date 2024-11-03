import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Daily Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskListScreen(),
    );
  }
}
