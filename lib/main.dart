import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intuitive_todo/screens/home_screen.dart';
import 'package:intuitive_todo/theme/app_theme.dart';

void main() {
  runApp(const IntuitiveTodoApp());
}

class IntuitiveTodoApp extends StatelessWidget {
  const IntuitiveTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Intuitive Todo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
