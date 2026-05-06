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
    final theme = Theme.of(context);
    final task = ModalRoute.of(context)?.settings.arguments as Task;

    return Consumer<TaskProvider>(
      builder: (ctx, taskProvider, child) {
        final currentTask = taskProvider.tasks.firstWhere(
          (t) => t.id == task.id,
          orElse: () => task,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.of(context).pushNamed('/form', arguments: currentTask);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      currentTask.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: currentTask.isDone ? Colors.green : theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        currentTask.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: currentTask.isDone ? TextDecoration.lineThrough : null,
                          color: currentTask.isDone ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5) : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                _buildInfoRow(theme, 'Categoria', currentTask.category),
                _buildInfoRow(theme, 'Data Prevista', DateFormat('dd/MM/yyyy').format(currentTask.dueDate)),
                if (currentTask.isImportant)
                  _buildInfoRow(theme, 'Prioridade', 'Importante', isHigh: true),
                
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                
                Text(
                  'Descrição',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currentTask.description.isEmpty ? 'Sem descrição.' : currentTask.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                if (!currentTask.isDone)
                  CustomButton(
                    label: 'Concluir Tarefa',
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false).toggleDone(currentTask);
                      Navigator.of(context).pop();
                    },
                  ),
                
                const SizedBox(height: 12),
                
                TextButton(
                  onPressed: () {
                    if (currentTask.id != null) {
                      _showDeleteConfirmation(context, currentTask.id!);
                    }
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Excluir Tarefa'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value, {bool isHigh = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isHigh ? theme.colorScheme.error : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir'),
        content: const Text('Deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
