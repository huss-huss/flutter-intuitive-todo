import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intuitive_todo/providers/todo_provider.dart';
import 'package:intuitive_todo/models/todo.dart';
import 'package:intuitive_todo/theme/app_theme.dart';
import 'package:intuitive_todo/widgets/quick_start_card.dart';
import 'package:intuitive_todo/widgets/add_task_card.dart';
import 'package:intuitive_todo/widgets/search_filter_bar.dart';
import 'package:intuitive_todo/widgets/todo_list.dart';
import 'package:intuitive_todo/widgets/progress_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // Slate-50
              Color(0xFFE0E7FF), // Indigo-100
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header
                _buildHeader(context),
                const SizedBox(height: 32),
                
                // Quick Start Card (only show when no todos)
                Consumer<TodoProvider>(
                  builder: (context, provider, child) {
                    if (provider.todos.isEmpty) {
                      return const QuickStartCard();
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Add Task Card
                const AddTaskCard(),
                const SizedBox(height: 24),
                
                // Search and Filter Bar
                const SearchFilterBar(),
                const SizedBox(height: 24),
                
                // Todo List
                const TodoList(),
                const SizedBox(height: 24),
                
                // Progress Card
                Consumer<TodoProvider>(
                  builder: (context, provider, child) {
                    if (provider.totalCount > 0) {
                      return const ProgressCard();
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Title with sparkles icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 32,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'My Tasks',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem(
                  context,
                  '${provider.completedCount} of ${provider.totalCount} completed',
                ),
                const SizedBox(width: 24),
                _buildStatItem(
                  context,
                  '${provider.starredCount} starred',
                ),
                const SizedBox(width: 24),
                _buildStatItem(
                  context,
                  '${provider.remainingCount} remaining',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppTheme.textSecondary,
      ),
    );
  }
}
