import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../components/task_tile.dart';
import '../models/task.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Tarefas'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Importantes'),
              Tab(text: 'Concluídas'),
              Tab(text: 'Atrasadas'),
            ],
          ),
        ),
        body: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final tasks = taskProvider.tasks;

            if (tasks.isEmpty) {
              return const Center(
                child: Text('Nenhuma tarefa encontrada. Adicione uma!'),
              );
            }

            return TabBarView(
              children: [
                _buildTaskList(tasks, context),
                _buildTaskList(tasks.where((t) => t.isImportant && !t.isDone).toList(), context),
                _buildTaskList(tasks.where((t) => t.isDone).toList(), context),
                _buildTaskList(
                  tasks.where((t) => !t.isDone && t.dueDate.isBefore(DateTime.now())).toList(),
                  context,
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/form');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('Nenhuma tarefa nesta categoria.'),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          onToggleDone: () {
            Provider.of<TaskProvider>(context, listen: false).toggleDone(task);
          },
          onDelete: () {

            if (task.id != null) {
              Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id!);
            }
          },
          onTap: () {
            Navigator.of(context).pushNamed('/details', arguments: task);
          },
        );
      },
    );
  }
}
