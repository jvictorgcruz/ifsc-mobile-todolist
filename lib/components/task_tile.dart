import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleDone,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: IconButton(
          icon: Icon(
            task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.isDone ? Colors.green : Colors.blue,
            size: 28,
          ),
          onPressed: onToggleDone,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat('dd/MM/yyyy').format(task.dueDate)} • ${task.category}',
              style: const TextStyle(fontSize: 12),
            ),
            if (task.isImportant)
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.priority_high, size: 14, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      'Importante',
                      style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
