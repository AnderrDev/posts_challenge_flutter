# Posts Challenge

Mobile challenge demonstrating Flutter advanced concepts including Clean Architecture, BLoC, and Native Integration via Pigeon.

## Architecture

This project follows **Clean Architecture** principles to separate concerns into independent layers:

- **Domain Layer**: Contains Entities, Repositories (interfaces), and Use Cases. Pure Dart, no Flutter dependencies.
- **Data Layer**: Implements Repositories and defines Datasources (Remote, Local, Native). Handles data fetching and persistence.
- **Presentation Layer**: Contains UI (Pages, Widgets) and State Management (BLoC/Cubit).
- **Injection**: Uses `get_it` for dependency injection (`lib/di/injector.dart`).

## Features

- **Posts List**: Fetched from JSONPlaceholder (with Lazy Loading support).
- **Search**: Local filtering of posts.
- **Post Detail**: Shows post content and comments.
- **Smart Notifications** (Native Integration):
    - When you "Like" a post, a native local notification is triggered ("Te ha gustado: ...").
    - Implemented using **Pigeon** for type-safe communication (no manual MethodChannels).
    - **Android**: Uses `NotificationChannel` and `NotificationManager` (Kotlin).
    - **iOS**: Uses `UNUserNotificationCenter` (Swift).

## Setup & Running

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
2. **Run Code Generation** (if needed for mocks/pigeon):
   ```bash
   flutter pub run build_runner build
   # Pigeon command used:
   # flutter pub run pigeon --input pigeons/messages.dart
   ```
3. **Run App**:
   ```bash
   flutter run
   ```

## Pigeon Setup

The native communication is defined in `pigeons/messages.dart`.
To regenerate the native code after changes:

```bash
flutter pub run pigeon --input pigeons/messages.dart
```

## AI Usage

Tools used: **Agentic AI Assistant** (Google Deepmind).
- **Native Integration**: AI generated the Kotlin and Swift code for the notification logic based on the Pigeon definition.
- **Refactoring**: AI helped refactor the `toggleLike` repository method to accept `PostEntity` to pass the title to the native layer.
- **Testing**: AI updated the unit tests to mock the new native datasource.

## Testing

Run unit tests:
```bash
flutter test
```
