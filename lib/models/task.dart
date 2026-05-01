class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isImportant;
  final bool isDone;
  final String category;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isImportant = false,
    this.isDone = false,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isImportant': isImportant ? 1 : 0,
      'isDone': isDone ? 1 : 0,
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      isImportant: (map['isImportant'] as int) == 1,
      isDone: (map['isDone'] as int) == 1,
      category: map['category'] as String,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isImportant,
    bool? isDone,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isImportant: isImportant ?? this.isImportant,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
    );
  }
}
