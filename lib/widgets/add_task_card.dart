import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intuitive_todo/providers/todo_provider.dart';
import 'package:intuitive_todo/models/todo.dart';
import 'package:intuitive_todo/theme/app_theme.dart';

class AddTaskCard extends StatefulWidget {
  const AddTaskCard({super.key});

  @override
  State<AddTaskCard> createState() => _AddTaskCardState();
}

class _AddTaskCardState extends State<AddTaskCard> {
  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'Personal';
  Priority _selectedPriority = Priority.medium;
  bool _showOptions = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            // Input field and add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'What needs to be done?',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _showOptions = value.isNotEmpty;
                      });
                    },
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _textController.text.trim().isNotEmpty ? _addTodo : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
            
            // Category and priority options
            if (_showOptions) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  // Category dropdown
                  Expanded(
                    child: _buildDropdown<String>(
                      value: _selectedCategory,
                      items: TodoProvider.categories,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                      label: 'Category',
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Priority dropdown
                  Expanded(
                    child: _buildDropdown<Priority>(
                      value: _selectedPriority,
                      items: Priority.values,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        }
                      },
                      label: 'Priority',
                      itemBuilder: (priority) => _buildPriorityItem(priority),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String label,
    Widget Function(T)? itemBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.inputBorderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder != null 
                  ? itemBuilder(item)
                  : Text(
                      item.toString(),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                      ),
                    ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted),
          style: const TextStyle(color: AppTheme.textPrimary),
          dropdownColor: AppTheme.surfaceColor,
        ),
      ),
    );
  }

  Widget _buildPriorityItem(Priority priority) {
    Color priorityColor;
    IconData priorityIcon;
    
    switch (priority) {
      case Priority.low:
        priorityColor = AppTheme.priorityLow;
        priorityIcon = Icons.flag_outlined;
        break;
      case Priority.medium:
        priorityColor = AppTheme.priorityMedium;
        priorityIcon = Icons.flag;
        break;
      case Priority.high:
        priorityColor = AppTheme.priorityHigh;
        priorityIcon = Icons.flag;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          priorityIcon,
          size: 16,
          color: priorityColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${priority.name[0].toUpperCase()}${priority.name.substring(1)} Priority',
          style: TextStyle(
            color: priorityColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _addTodo() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<TodoProvider>().addTodo(
        text,
        category: _selectedCategory,
        priority: _selectedPriority,
      );
      _textController.clear();
      setState(() {
        _showOptions = false;
      });
    }
  }
}
