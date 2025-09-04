import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intuitive_todo/providers/todo_provider.dart';
import 'package:intuitive_todo/models/todo.dart';
import 'package:intuitive_todo/theme/app_theme.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and category filter
        Row(
          children: [
            Expanded(
              child: _buildSearchField(context),
            ),
            const SizedBox(width: 8),
            _buildCategoryFilter(context),
          ],
        ),
        const SizedBox(height: 12),
        
        // Filter buttons and bulk actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFilterButtons(context),
            _buildBulkActions(context),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.inputBorderColor),
          ),
          child: TextField(
            onChanged: provider.updateSearchTerm,
            decoration: const InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: Icon(Icons.search, color: AppTheme.textMuted),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.inputBorderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.selectedCategory,
              items: [
                const DropdownMenuItem(
                  value: 'all',
                  child: Text('All Categories'),
                ),
                ...TodoProvider.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }),
              ],
              onChanged: (value) {
                if (value != null) {
                  provider.updateSelectedCategory(value);
                }
              },
              icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted),
              style: const TextStyle(color: AppTheme.textPrimary),
              dropdownColor: AppTheme.surfaceColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButtons(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            _buildFilterButton(
              context,
              'All',
              TodoFilter.all,
              provider.currentFilter,
              provider.updateFilter,
            ),
            const SizedBox(width: 4),
            _buildFilterButton(
              context,
              'Active',
              TodoFilter.active,
              provider.currentFilter,
              provider.updateFilter,
            ),
            const SizedBox(width: 4),
            _buildFilterButton(
              context,
              'Completed',
              TodoFilter.completed,
              provider.currentFilter,
              provider.updateFilter,
            ),
            const SizedBox(width: 4),
            _buildFilterButton(
              context,
              'Starred',
              TodoFilter.starred,
              provider.currentFilter,
              provider.updateFilter,
              icon: Icons.star,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    String text,
    TodoFilter filter,
    TodoFilter currentFilter,
    Function(TodoFilter) onTap, {
    IconData? icon,
  }) {
    final isSelected = currentFilter == filter;
    
    return ElevatedButton(
      onPressed: () => onTap(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primaryColor : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : AppTheme.textPrimary,
        elevation: 0,
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActions(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        if (provider.selectedTodos.isEmpty) {
          return _buildClearCompletedButton(context, provider);
        }
        
        return Row(
          children: [
            _buildBulkActionButton(
              context,
              'Complete (${provider.selectedTodos.length})',
              Icons.check_circle_outline,
              provider.bulkComplete,
            ),
            const SizedBox(width: 8),
            _buildBulkActionButton(
              context,
              'Delete (${provider.selectedTodos.length})',
              Icons.delete_outline,
              provider.bulkDelete,
              isDestructive: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBulkActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
        side: BorderSide(
          color: isDestructive ? AppTheme.errorColor : AppTheme.borderColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildClearCompletedButton(BuildContext context, TodoProvider provider) {
    if (provider.completedCount == 0) return const SizedBox.shrink();
    
    return OutlinedButton(
      onPressed: provider.clearCompleted,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textSecondary,
        side: BorderSide(color: AppTheme.borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.archive_outlined, size: 16),
          const SizedBox(width: 4),
          const Text(
            'Clear Completed',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
