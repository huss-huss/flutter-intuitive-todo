import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intuitive_todo/providers/todo_provider.dart';
import 'package:intuitive_todo/models/todo.dart';
import 'package:intuitive_todo/theme/app_theme.dart';
import 'package:intuitive_todo/widgets/todo_card.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        final filteredTodos = provider.filteredTodos;
        
        if (filteredTodos.isEmpty) {
          return _buildEmptyState(context, provider);
        }
        
        return Column(
          children: filteredTodos.map((todo) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TodoCard(todo: todo),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, TodoProvider provider) {
    IconData icon;
    String message;
    
    if (provider.searchTerm.isNotEmpty || 
        provider.currentFilter != TodoFilter.all || 
        provider.selectedCategory != 'all') {
      icon = Icons.search;
      message = 'No tasks match your criteria';
    } else {
      icon = Icons.check_circle_outline;
      message = 'All done! Time to add some new tasks.';
    }
    
    return Card(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
