import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool _isImportant = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            Row(
              children: [
                Text(
                  _selectedDate != null
                      ? 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0]
                      : 'Seleccione una fecha',
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            SwitchListTile(
              title: Text('Importante'),
              value: _isImportant,
              onChanged: (bool value) {
                setState(() {
                  _isImportant = value;
                });
              },
            ),
            ElevatedButton(
              child: Text('Guardar Tarea'),
              onPressed: () {
                final newTask = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dueDate: _selectedDate ?? DateTime.now(),
                  isImportant: _isImportant,
                );
                Navigator.pop(context, newTask);
              },
            ),
          ],
        ),
      ),
    );
  }
}
