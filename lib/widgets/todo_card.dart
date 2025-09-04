import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intuitive_todo/providers/todo_provider.dart';
import 'package:intuitive_todo/models/todo.dart';
import 'package:intuitive_todo/theme/app_theme.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  
  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.selectedTodos.contains(todo.id);
        final isEditing = provider.editingTodoId == todo.id;
        
        return Card(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : AppTheme.primaryColor.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with checkboxes, text, and actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selection checkbox
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => provider.toggleSelection(todo.id),
                        activeColor: AppTheme.primaryColor,
                      ),
                      
                      // Completion checkbox
                      Checkbox(
                        value: todo.completed,
                        onChanged: (_) => provider.toggleTodo(todo.id),
                        activeColor: AppTheme.successColor,
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Todo content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isEditing) ...[
                              _buildEditField(context, provider),
                            ] else ...[
                              _buildTodoText(context),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Action buttons
                      _buildActionButtons(context, provider),
                    ],
                  ),
                  
                  // Bottom row with metadata
                  if (!isEditing) ...[
                    const SizedBox(height: 8),
                    _buildTodoMetadata(context),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditField(BuildContext context, TodoProvider provider) {
    return TextField(
      controller: TextEditingController(text: provider.editText),
      onChanged: (value) {
        // Update the edit text in provider
        provider.startEdit(todo.id, value);
      },
      onSubmitted: (_) => provider.saveEdit(),
      onEditingComplete: provider.saveEdit,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        hintText: 'Edit task...',
      ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
      ),
      autofocus: true,
    );
  }

  Widget _buildTodoText(BuildContext context) {
    return Text(
      todo.text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: todo.completed ? AppTheme.textMuted : AppTheme.textPrimary,
        decoration: todo.completed ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Widget _buildTodoMetadata(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Left side - Priority and Category badges
          Wrap(
            spacing: 16,
            children: [
              _buildPriorityBadge(),
              _buildCategoryBadge(),
            ],
          ),
          
          // Right side - Date (no right margin)
          Text(
            DateFormat('MMM d').format(todo.createdAt),
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    
    switch (todo.priority) {
      case Priority.low:
        backgroundColor = AppTheme.priorityLow.withOpacity(0.1);
        textColor = AppTheme.priorityLow;
        icon = Icons.flag_outlined;
        break;
      case Priority.medium:
        backgroundColor = AppTheme.priorityMedium.withOpacity(0.1);
        textColor = AppTheme.priorityMedium;
        icon = Icons.flag;
        break;
      case Priority.high:
        backgroundColor = AppTheme.priorityHigh.withOpacity(0.1);
        textColor = AppTheme.priorityHigh;
        icon = Icons.flag;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: textColor),
          const SizedBox(width: 2),
          Text(
            todo.priority.name,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.label_outline, size: 9, color: AppTheme.textSecondary),
          const SizedBox(width: 2),
          Text(
            todo.category,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, TodoProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star button
        GestureDetector(
          onTap: () => provider.toggleStar(todo.id),
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Icon(
              todo.starred ? Icons.star : Icons.star_border,
              color: todo.starred ? AppTheme.warningColor : AppTheme.textMuted,
              size: 16,
            ),
          ),
        ),
        
        // Edit button
        GestureDetector(
          onTap: () => provider.startEdit(todo.id, todo.text),
          child: Container(
            padding: const EdgeInsets.all(6),
            child: const Icon(
              Icons.edit_outlined,
              color: AppTheme.textMuted,
              size: 16,
            ),
          ),
        ),
        
        // Delete button
        GestureDetector(
          onTap: () => provider.deleteTodo(todo.id),
          child: Container(
            padding: const EdgeInsets.all(6),
            child: const Icon(
              Icons.delete_outline,
              color: AppTheme.textMuted,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
