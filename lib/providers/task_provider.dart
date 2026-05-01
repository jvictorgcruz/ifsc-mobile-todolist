import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/db_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => [..._tasks];

  Task? get nextTask {
    final pendingTasks = _tasks.where((t) => !t.isDone).toList();
    if (pendingTasks.isEmpty) return null;

    pendingTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return pendingTasks.first;
  }

  Future<void> loadTasks() async {
    _tasks = await DbHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DbHelper().insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DbHelper().updateTask(task);
    await loadTasks();
  }

  Future<void> toggleDone(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await updateTask(updatedTask);
  }

  Future<void> deleteTask(int id) async {
    await DbHelper().deleteTask(id);
    await loadTasks();
  }
}
