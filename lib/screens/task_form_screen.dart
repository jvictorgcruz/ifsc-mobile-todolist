import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/custom_dropdown.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedCategory = 'Pessoal';
  DateTime _selectedDate = DateTime.now();
  bool _isImportant = false;
  
  int? _editingId;
  bool _isDone = false;
  bool _isInit = true;

  final List<String> _categories = [
    'Trabalho',
    'Estudo',
    'Pessoal',
    'Lazer',
    'Outros',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final taskArg = ModalRoute.of(context)?.settings.arguments as Task?;
      if (taskArg != null) {
        _editingId = taskArg.id;
        _titleController.text = taskArg.title;
        _descriptionController.text = taskArg.description;
        _selectedCategory = _categories.contains(taskArg.category) 
            ? taskArg.category 
            : 'Outros';
        _selectedDate = taskArg.dueDate;
        _isImportant = taskArg.isImportant;
        _isDone = taskArg.isDone;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: _editingId,
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory ?? 'Outros',
      dueDate: _selectedDate,
      isImportant: _isImportant,
      isDone: _isDone,
    );

    final provider = Provider.of<TaskProvider>(context, listen: false);
    
    if (_editingId == null) {
      provider.addTask(task);
    } else {
      provider.updateTask(task);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingId == null ? 'Nova Tarefa' : 'Editar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomInput(
                label: 'Título',
                controller: _titleController,
                hint: 'Nome da tarefa',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomInput(
                label: 'Descrição',
                controller: _descriptionController,
                hint: 'Opcional',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomDropdown(
                      label: 'Categoria',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prazo',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Marcar como importante',
                    style: theme.textTheme.bodyLarge,
                  ),
                  Switch(
                    value: _isImportant,
                    onChanged: (value) {
                      setState(() {
                        _isImportant = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),
              
              CustomButton(
                label: 'Salvar',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
