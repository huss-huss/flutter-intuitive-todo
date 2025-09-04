enum Priority { low, medium, high }
enum TodoFilter { all, active, completed, starred }

class Todo {
  final String id;
  final String text;
  final bool completed;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final String category;
  final bool starred;

  Todo({
    required this.id,
    required this.text,
    required this.completed,
    required this.createdAt,
    this.dueDate,
    required this.priority,
    required this.category,
    required this.starred,
  });

  Todo copyWith({
    String? id,
    String? text,
    bool? completed,
    DateTime? createdAt,
    DateTime? dueDate,
    Priority? priority,
    String? category,
    bool? starred,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      starred: starred ?? this.starred,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'category': category,
      'starred': starred,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      text: json['text'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: Priority.values.firstWhere((e) => e.name == json['priority']),
      category: json['category'],
      starred: json['starred'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
