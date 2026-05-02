import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../components/custom_button.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final task = ModalRoute.of(context)?.settings.arguments as Task;



    return Consumer<TaskProvider>(
      builder: (ctx, taskProvider, child) {

        final currentTask = taskProvider.tasks.firstWhere(
          (t) => t.id == task.id,
          orElse: () => task,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes da Tarefa'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed('/form', arguments: currentTask);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      currentTask.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: currentTask.isDone ? Colors.green : Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        currentTask.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          decoration: currentTask.isDone ? TextDecoration.lineThrough : null,
                          color: currentTask.isDone ? Colors.grey : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),


                _buildDetailRow(Icons.tag, 'ID', currentTask.id.toString()),
                _buildDetailRow(Icons.category, 'Categoria', currentTask.category),
                _buildDetailRow(
                  Icons.calendar_today,
                  'Data Prevista',
                  DateFormat('dd/MM/yyyy').format(currentTask.dueDate),
                ),
                
                if (currentTask.isImportant)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.priority_high, color: Colors.red),
                        SizedBox(width: 12),
                        Text(
                          'Tarefa Importante',
                          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                const Divider(height: 32),
                

                const Text(
                  'Descrição:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      currentTask.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),


                if (!currentTask.isDone)
                  CustomButton(
                    label: 'Concluir Tarefa',
                    icon: Icons.check,
                    color: Colors.green,
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false).toggleDone(currentTask);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tarefa concluída! 🎉')),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
