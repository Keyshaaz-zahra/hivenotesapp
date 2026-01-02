# Notes App - Flutter with Hive & BLoC

A complete Flutter Notes application implementing CRUD operations, search functionality, category filtering, tags, and dark mode using Hive for local storage and BLoC pattern for state management.

## 🚀 Features

- ✅ **CRUD Operations**: Create, Read, Update, and Delete notes
- 🔍 **Search Functionality**: Search notes by title, content, or tags
- 📁 **Categories**: Organize notes with categories
- 🏷️ **Tags**: Add multiple tags to notes for better organization
- 🌓 **Dark Mode**: Toggle between light and dark themes
- 💾 **Local Storage**: Data persistence using Hive database
- 🎨 **Modern UI**: Material Design 3 with beautiful card layouts
- 🏗️ **BLoC Pattern**: Clean architecture with state management

## 📁 Project Structure

```
notes_app/
├── lib/
│   ├── main.dart                      # Application entry point
│   ├── models/
│   │   └── note.dart                  # Note data model
│   ├── repositories/
│   │   └── notes_repository.dart      # Data layer (Hive)
│   ├── blocs/
│   │   ├── notes_list_bloc/
│   │   │   ├── notes_list_bloc.dart
│   │   │   ├── notes_list_event.dart
│   │   │   └── notes_list_state.dart
│   │   ├── note_form_cubit/
│   │   │   ├── note_form_cubit.dart
│   │   │   └── note_form_state.dart
│   │   └── theme_cubit/
│   │       └── theme_cubit.dart
│   ├── screens/
│   │   ├── notes_list_screen.dart
│   │   └── note_form_screen.dart
│   └── widgets/
│       └── note_card.dart
├── pubspec.yaml
└── README.md
```

## 🛠️ Installation & Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Steps

1. **Clone or navigate to the project directory**:
   ```bash
   cd /workspace/notes_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

   For web:
   ```bash
   flutter run -d chrome
   ```

   For specific device:
   ```bash
   flutter devices  # List available devices
   flutter run -d <device_id>
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3      # State management
  hive: ^2.2.3              # Local database
  hive_flutter: ^1.1.0      # Hive Flutter integration
  equatable: ^2.0.5         # Value equality
  intl: ^0.18.1             # Date formatting

dev_dependencies:
  hive_generator: ^2.0.1    # Code generation for Hive
  build_runner: ^2.4.6      # Code generation runner
```

## 🎯 Usage Guide

### Creating a Note

1. Tap the **+** floating action button
2. Enter title and content
3. (Optional) Add category and tags
4. Tap the **save** icon in the app bar

### Editing a Note

1. Tap on any note card from the list
2. Modify the content
3. Tap **save** to update

### Deleting a Note

1. Tap the **delete** icon on the note card
2. Confirm deletion in the dialog

### Searching Notes

1. Type in the search bar at the top
2. Results update in real-time
3. Searches through title, content, and tags

### Filtering by Category

1. Tap the **filter** icon in the app bar
2. Select a category from the dropdown
3. View filtered notes

### Dark Mode

1. Tap the **moon/sun** icon in the app bar
2. Theme switches between light and dark mode

## 🏗️ Architecture

### BLoC Pattern

The app follows the BLoC (Business Logic Component) pattern:

- **Events**: User actions (LoadNotes, SearchNotes, DeleteNote, etc.)
- **States**: UI states (Loading, Loaded, Error)
- **Blocs**: Business logic processors

### Data Flow

```
UI (Widget) → Event → Bloc → Repository → Hive Database
                ↓
            State → UI Update
```

### Key Components

1. **NotesRepository**: Handles all database operations
2. **NotesListBloc**: Manages notes list state and operations
3. **NoteFormCubit**: Manages note creation/editing form state
4. **ThemeCubit**: Manages app theme state

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📝 Code Quality

Check code formatting:

```bash
flutter analyze
```

Format code:

```bash
flutter format .
```

## 🎨 Customization

### Changing Theme Colors

Edit `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Change this color
  brightness: Brightness.light,
),
```

### Adding New Fields to Note Model

1. Update `lib/models/note.dart`
2. Update `toMap()` and `fromMap()` methods
3. Update UI forms in `note_form_screen.dart`

## 🐛 Troubleshooting

### Hive Box Not Opening

```bash
flutter clean
flutter pub get
flutter run
```

### State Not Updating

- Ensure you're using `BlocBuilder` or `BlocListener`
- Check if events are being added correctly
- Verify repository methods are being called

## 📄 License

This project is created for educational purposes.

## 👥 Contributors

- KEYSHA AZ-ZAHRA ULFITRIA 

## 📞 Support

- Email: [keyshaazzahraulfitria07@gmail.com]
- GitHub: [github.com/Keyshaaz-zahra]


---

**Happy Coding! 🚀**