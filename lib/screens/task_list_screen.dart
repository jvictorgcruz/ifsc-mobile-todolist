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
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Todas',
    'Trabalho',
    'Estudo',
    'Pessoal',
    'Lazer',
    'Outros',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar tarefas...',
                    border: InputBorder.none,
                    filled: false,
                  ),
                  style: theme.textTheme.bodyLarge,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                )
              : const Text('Tarefas'),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = '';
                    _searchController.clear();
                  }
                });
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Todas'),
              Tab(text: 'Importantes'),
              Tab(text: 'Concluídas'),
              Tab(text: 'Atrasadas'),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (ctx, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategoryFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryFilter = cat;
                        });
                      },
                      selectedColor: theme.colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      showCheckmark: false,
                      side: BorderSide(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  var filteredTasks = taskProvider.tasks.where((t) {
                    final matchesCategory = _selectedCategoryFilter == 'Todas' || t.category == _selectedCategoryFilter;
                    final matchesSearch = t.title.toLowerCase().contains(_searchQuery.toLowerCase());
                    return matchesCategory && matchesSearch;
                  }).toList();

                  if (taskProvider.tasks.isEmpty) {
                    return _buildEmptyState('Nenhuma tarefa.');
                  }

                  return TabBarView(
                    children: [
                      _buildTaskList(filteredTasks, context),
                      _buildTaskList(filteredTasks.where((t) => t.isImportant && !t.isDone).toList(), context),
                      _buildTaskList(filteredTasks.where((t) => t.isDone).toList(), context),
                      _buildTaskList(
                        filteredTasks.where((t) {
                          final taskDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
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
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState(_searchQuery.isEmpty ? 'Lista vazia.' : 'Nenhum resultado encontrado.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
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
              _showDeleteConfirmation(context, task.id!);
            }
          },
          onTap: () {
            Navigator.of(context).pushNamed('/details', arguments: task);
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
