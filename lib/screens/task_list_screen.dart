import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../components/task_tile.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _selectedCategoryFilter = 'Todas';
  final List<String> _categories = [
    'Todas',
    'Trabalho',
    'Estudo',
    'Pessoal',
    'Lazer',
    'Outros',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

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
        body: Column(
          children: [

            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (ctx, index) {
                  final cat = _categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: _selectedCategoryFilter == cat,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryFilter = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {

                  final allTasks = taskProvider.tasks.where((t) {
                    return _selectedCategoryFilter == 'Todas' || 
                           t.category == _selectedCategoryFilter;
                  }).toList();

                  if (taskProvider.tasks.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma tarefa encontrada.'),
                    );
                  }

                  if (allTasks.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma tarefa nesta categoria.'),
                    );
                  }

                  return TabBarView(
                    children: [
                      _buildTaskList(allTasks, context),
                      _buildTaskList(allTasks.where((t) => t.isImportant && !t.isDone).toList(), context),
                      _buildTaskList(allTasks.where((t) => t.isDone).toList(), context),
                      _buildTaskList(
                        allTasks.where((t) {
                          final taskDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day + 1);
                          return !t.isDone && taskDate.isBefore(today);
                        }).toList(),
                        context,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
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
        child: Text('Nada por aqui!'),
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
