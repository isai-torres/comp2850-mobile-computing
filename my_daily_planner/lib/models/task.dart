class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isImportant;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isImportant = false,
    this.isCompleted = false,
  });
}
