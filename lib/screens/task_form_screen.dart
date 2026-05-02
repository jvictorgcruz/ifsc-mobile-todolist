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
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingId == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomInput(
                  label: 'Título',
                  controller: _titleController,
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O título é obrigatório.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomInput(
                  label: 'Descrição (Opcional)',
                  controller: _descriptionController,
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'Categoria',
                  value: _selectedCategory,
                  items: _categories,
                  icon: Icons.category,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Data Prevista: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Alterar Data'),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                

                SwitchListTile(
                  title: const Text('Tarefa Importante?'),
                  subtitle: const Text('Tarefas importantes são destacadas.'),
                  value: _isImportant,
                  activeTrackColor: Colors.red[100],
                  activeThumbColor: Colors.redAccent, 
                  onChanged: (value) {
                    setState(() {
                      _isImportant = value;
                    });
                  },
                ),
                const SizedBox(height: 32),
                
                CustomButton(
                  label: 'Salvar Tarefa',
                  icon: Icons.save,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
