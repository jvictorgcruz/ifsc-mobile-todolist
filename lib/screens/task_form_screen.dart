import 'package:flutter/material.dart';

class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tarefa'),
      ),
      body: const Center(
        child: Text('Formulário de Tarefa'),
      ),
    );
  }
}
