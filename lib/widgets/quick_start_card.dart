import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intuitive_todo/providers/todo_provider.dart';
import 'package:intuitive_todo/models/todo.dart';
import 'package:intuitive_todo/theme/app_theme.dart';

class QuickStartCard extends StatelessWidget {
  const QuickStartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Start',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Quick suggestions grid
            Consumer<TodoProvider>(
              builder: (context, provider, child) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3.5,
                  children: TodoProvider.quickSuggestions.map((suggestion) {
                    return _buildQuickSuggestionButton(
                      context,
                      provider,
                      suggestion['text'] as String,
                      suggestion['category'] as String,
                      suggestion['priority'] as Priority,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSuggestionButton(
    BuildContext context,
    TodoProvider provider,
    String text,
    String category,
    Priority priority,
  ) {
    return OutlinedButton(
      onPressed: () {
        provider.addQuickTodo(
          text,
          category: category,
          priority: priority,
        );
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.2)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.centerLeft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$category • ${priority.name} priority',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
