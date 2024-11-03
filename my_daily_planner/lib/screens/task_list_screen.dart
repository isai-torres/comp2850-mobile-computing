import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Daily Planner')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tarea eliminada')),
                );
              },
            ),
            onTap: () {
              // Transition to edit the task
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          ).then((newTask) {
            if (newTask != null) {
              setState(() {
                tasks.add(newTask);
              });
            }
          });
        },
      ),
    );
  }
}
