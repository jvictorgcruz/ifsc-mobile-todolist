# 📝 Todo List App - IFSC

Este é um aplicativo de gerenciamento de tarefas (CRUD) desenvolvido como projeto para a disciplina de Desenvolvimento Mobile no IFSC. O objetivo é permitir que o usuário gerencie suas tarefas diárias de forma eficiente, com persistência local e uma interface moderna.

## 🚀 Funcionalidades

- **CRUD Completo**: Criação, visualização, edição e exclusão de tarefas.
- **Atributos da Tarefa**: Título, Descrição, Data Prevista, Importância (Booleano), Status de Conclusão e **Categoria** (Atributo extra).
- **Tela de Boas-Vindas**: Apresenta a próxima tarefa mais urgente para o usuário.
- **Listagem Inteligente**: Filtros por tarefas Importantes, Concluídas e Atrasadas utilizando uma interface de Abas (TabBar).
- **Tela de Detalhes**: Exibição detalhada incluindo ID da tarefa e descrição completa, com opção de conclusão rápida.

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework UI.
- **SQLite (sqflite)**: Persistência de dados local.
- **Provider**: Gerenciamento de estado robusto.
- **Rotas Nomeadas**: Navegação organizada e escalável.
- **Intl**: Formatação de datas e localização.

## 📁 Organização do Projeto

O projeto segue uma estrutura de pastas organizada para facilitar a manutenção:

- `lib/models/`: Definição das classes de dados e mapeamento para o banco.
- `lib/providers/`: Lógica de negócio e gerenciamento de estado.
- `lib/screens/`: Interfaces de usuário (Telas).
- `lib/components/`: Widgets customizados e reutilizáveis.
- `lib/utils/`: Utilitários e configuração do banco de dados (SQLite).
---
