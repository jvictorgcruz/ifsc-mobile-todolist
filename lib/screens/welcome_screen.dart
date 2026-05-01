import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskProvider>(context, listen: false).loadTasks();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            Consumer<TaskProvider>(
              builder: (ctx, taskProvider, child) {
                final nextTask = taskProvider.nextTask;
                if (nextTask == null) {
                  return const Text('Nenhuma tarefa pendente.');
                }
                return Column(
                  children: [
                    const Text('Sua próxima tarefa é:'),
                    Text(
                      nextTask.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Para: ${DateFormat('dd/MM/yyyy').format(nextTask.dueDate)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/list'),
              icon: const Icon(Icons.list),
              label: const Text('Ver Minhas Tarefas'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
