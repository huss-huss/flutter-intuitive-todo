# Intuitive Todo - Flutter App

A beautiful and intuitive todo app built with Flutter, designed to work seamlessly across web, Android, and iOS platforms. This app replicates the elegant design and functionality of the original intuitive-todo web application.

## ✨ Features

- **Beautiful UI**: Modern, clean design with glassmorphism effects and indigo/blue color scheme
- **Cross-Platform**: Works on web, Android, and iOS with native performance
- **Smart Task Management**: Add, edit, delete, and organize tasks with ease
- **Categories & Priorities**: Organize tasks by category (Personal, Work, Shopping, Health, Learning) and priority (Low, Medium, High)
- **Advanced Filtering**: Search, filter by status, and filter by category
- **Bulk Operations**: Select multiple tasks for bulk completion or deletion
- **Star System**: Mark important tasks with stars for quick access
- **Progress Tracking**: Visual progress bar showing completion status
- **Quick Start**: Pre-built task suggestions to get you started
- **Local Storage**: Tasks are saved locally using SharedPreferences
- **Responsive Design**: Adapts beautifully to different screen sizes

## 🎨 Design System

The app follows a carefully crafted design system that matches the original intuitive-todo web app:

- **Color Palette**: Indigo/blue primary colors with proper contrast
- **Typography**: Clean, readable fonts with consistent sizing
- **Spacing**: Consistent spacing and padding throughout the app
- **Cards**: Glassmorphism-style cards with subtle borders and shadows
- **Icons**: Meaningful icons for different actions and states
- **Animations**: Smooth transitions and hover effects

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- For Android: Android SDK
- For iOS: Xcode (macOS only)
- For Web: Chrome or any modern browser

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd intuitive-todo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

## 📱 Platform Support

### Web
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Responsive design for desktop and tablet
- Full feature support

### Android
- Android 5.0 (API level 21) and higher
- Material Design 3 components
- Native Android performance

### iOS
- iOS 11.0 and higher
- Cupertino-style components where appropriate
- Native iOS performance

## 🏗️ Architecture

The app follows a clean, maintainable architecture:

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── todo.dart            # Todo data model
├── providers/
│   └── todo_provider.dart   # State management
├── screens/
│   └── home_screen.dart     # Main screen
├── widgets/                  # Reusable UI components
│   ├── quick_start_card.dart
│   ├── add_task_card.dart
│   ├── search_filter_bar.dart
│   ├── todo_list.dart
│   ├── todo_card.dart
│   └── progress_card.dart
└── theme/
    └── app_theme.dart        # App theme and styling
```

### Key Components

- **TodoProvider**: Manages app state using ChangeNotifier
- **Todo Model**: Represents individual todo items with all properties
- **Widgets**: Modular, reusable UI components
- **Theme**: Consistent styling across the entire app

## 🎯 Usage

### Adding Tasks
1. Type your task in the input field
2. Select category and priority (optional)
3. Press Enter or tap the Add button

### Managing Tasks
- **Complete**: Check the completion checkbox
- **Star**: Tap the star icon to mark as important
- **Edit**: Tap the edit icon to modify task text
- **Delete**: Tap the delete icon to remove tasks

### Filtering and Search
- Use the search bar to find specific tasks
- Filter by status (All, Active, Completed, Starred)
- Filter by category
- Use bulk actions for multiple selected tasks

## 🔧 Customization

### Colors
Modify the color scheme in `lib/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF4F46E5); // Change this
static const Color secondaryColor = Color(0xFF10B981); // And this
```

### Categories
Add or modify categories in `lib/providers/todo_provider.dart`:

```dart
static const List<String> categories = [
  'Personal', 'Work', 'Shopping', 'Health', 'Learning', 'Custom'
];
```

### Quick Suggestions
Modify the quick start suggestions in the same file:

```dart
static const List<Map<String, dynamic>> quickSuggestions = [
  {'text': 'Your suggestion', 'category': 'Category', 'priority': Priority.medium},
];
```

## 📦 Dependencies

- **flutter**: Core Flutter framework
- **shared_preferences**: Local data storage
- **intl**: Date formatting and localization
- **provider**: State management
- **flutter_slidable**: Swipe actions (future enhancement)
- **flutter_staggered_animations**: Smooth animations (future enhancement)

## 🚧 Future Enhancements

- [ ] Dark mode support
- [ ] Task due dates and reminders
- [ ] Task tags and labels
- [ ] Export/import functionality
- [ ] Cloud sync
- [ ] Task templates
- [ ] Statistics and analytics
- [ ] Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the beautiful design of the original intuitive-todo web app
- Built with Flutter for cross-platform excellence
- Uses Material Design 3 principles for modern UI/UX

## 📞 Support

If you have any questions or need help, please:

1. Check the existing issues
2. Create a new issue with detailed information
3. Contact the development team

---

**Happy Tasking! 🎉**