import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intuitive_todo/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  String _searchTerm = '';
  TodoFilter _currentFilter = TodoFilter.all;
  String _selectedCategory = 'all';
  Set<String> _selectedTodos = {};
  String? _editingTodoId;
  String _editText = '';

  // Getters
  List<Todo> get todos => _todos;
  String get searchTerm => _searchTerm;
  TodoFilter get currentFilter => _currentFilter;
  String get selectedCategory => _selectedCategory;
  Set<String> get selectedTodos => _selectedTodos;
  String? get editingTodoId => _editingTodoId;
  String get editText => _editText;

  // Computed values
  int get totalCount => _todos.length;
  int get completedCount => _todos.where((todo) => todo.completed).length;
  int get remainingCount => totalCount - completedCount;
  int get starredCount => _todos.where((todo) => todo.starred).length;

  // Categories
  static const List<String> categories = ['Personal', 'Work', 'Shopping', 'Health', 'Learning'];

  // Quick suggestions
  static const List<Map<String, dynamic>> quickSuggestions = [
    {'text': 'Buy groceries', 'category': 'Shopping', 'priority': Priority.medium},
    {'text': 'Exercise for 30 minutes', 'category': 'Health', 'priority': Priority.high},
    {'text': 'Check emails', 'category': 'Work', 'priority': Priority.low},
    {'text': 'Read for 20 minutes', 'category': 'Learning', 'priority': Priority.low},
  ];

  TodoProvider() {
    _loadTodos();
  }

  // Load todos from SharedPreferences
  Future<void> _loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString('intuitive-todos');
      if (todosJson != null) {
        final List<dynamic> todosList = json.decode(todosJson);
        _todos = todosList.map((json) => Todo.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
  }

  // Save todos to SharedPreferences
  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = json.encode(_todos.map((todo) => todo.toJson()).toList());
      await prefs.setString('intuitive-todos', todosJson);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  // Add new todo
  void addTodo(String text, {String category = 'Personal', Priority priority = Priority.medium}) {
    if (text.trim().isNotEmpty) {
      final todo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text.trim(),
        completed: false,
        createdAt: DateTime.now(),
        priority: priority,
        category: category,
        starred: false,
      );
      _todos.insert(0, todo);
      _saveTodos();
      notifyListeners();
    }
  }

  // Add quick todo
  void addQuickTodo(String text, {String? category, Priority? priority}) {
    addTodo(
      text,
      category: category ?? 'Personal',
      priority: priority ?? Priority.medium,
    );
  }

  // Toggle todo completion
  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(completed: !_todos[index].completed);
      _saveTodos();
      notifyListeners();
    }
  }

  // Delete todo
  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    _selectedTodos.remove(id);
    _saveTodos();
    notifyListeners();
  }

  // Toggle star
  void toggleStar(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(starred: !_todos[index].starred);
      _saveTodos();
      notifyListeners();
    }
  }

  // Start editing
  void startEdit(String id, String text) {
    _editingTodoId = id;
    _editText = text;
    notifyListeners();
  }

  // Save edit
  void saveEdit() {
    if (_editingTodoId != null && _editText.trim().isNotEmpty) {
      final index = _todos.indexWhere((todo) => todo.id == _editingTodoId);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(text: _editText.trim());
        _saveTodos();
      }
    }
    _editingTodoId = null;
    _editText = '';
    notifyListeners();
  }

  // Cancel edit
  void cancelEdit() {
    _editingTodoId = null;
    _editText = '';
    notifyListeners();
  }

  // Toggle selection
  void toggleSelection(String id) {
    if (_selectedTodos.contains(id)) {
      _selectedTodos.remove(id);
    } else {
      _selectedTodos.add(id);
    }
    notifyListeners();
  }

  // Bulk complete
  void bulkComplete() {
    for (final id in _selectedTodos) {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(completed: true);
      }
    }
    _selectedTodos.clear();
    _saveTodos();
    notifyListeners();
  }

  // Bulk delete
  void bulkDelete() {
    _todos.removeWhere((todo) => _selectedTodos.contains(todo.id));
    _selectedTodos.clear();
    _saveTodos();
    notifyListeners();
  }

  // Clear completed
  void clearCompleted() {
    _todos.removeWhere((todo) => todo.completed);
    _saveTodos();
    notifyListeners();
  }

  // Update search term
  void updateSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  // Update filter
  void updateFilter(TodoFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Update selected category
  void updateSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Get filtered todos
  List<Todo> get filteredTodos {
    return _todos.where((todo) {
      final matchesSearch = todo.text.toLowerCase().contains(_searchTerm.toLowerCase());
      final matchesFilter = _currentFilter == TodoFilter.all ||
          (_currentFilter == TodoFilter.active && !todo.completed) ||
          (_currentFilter == TodoFilter.completed && todo.completed) ||
          (_currentFilter == TodoFilter.starred && todo.starred);
      final matchesCategory = _selectedCategory == 'all' || todo.category == _selectedCategory;
      return matchesSearch && matchesFilter && matchesCategory;
    }).toList();
  }

  // Get progress percentage
  double get progressPercentage {
    if (totalCount == 0) return 0.0;
    return completedCount / totalCount;
  }
}
