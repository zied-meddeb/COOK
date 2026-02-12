# Cuisin'Voisin - Flutter App

A homemade food ordering app built with Flutter.

## Project Structure

```
flutter_app/
├── lib/
│   ├── api/           # Mock API layer
│   ├── models/        # Data models
│   ├── navigation/    # App navigation (routes, navigators)
│   ├── providers/     # State management (Provider)
│   ├── screens/       # App screens
│   ├── theme/         # Theme configuration
│   ├── widgets/       # Reusable widgets/components
│   └── main.dart      # App entry point
├── assets/
│   └── images/        # Image assets
├── pubspec.yaml       # Flutter dependencies
└── analysis_options.yaml
```

## Features

### Client Features
- Browse homemade dishes
- View dish details and cook profiles
- Add items to cart
- Track orders in real-time

### Cook Features
- Dashboard with stats and quick actions
- Add new dishes
- Manage orders
- Profile management

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (for emulators)

### Installation

1. Navigate to the flutter_app directory:
```bash
cd flutter_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running on specific devices

```bash
# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run on Chrome (Web)
flutter run -d chrome
```

## Dependencies

- **provider**: State management
- **go_router**: Navigation
- **cached_network_image**: Image caching
- **intl**: Internationalization utils

## Architecture

The app follows a clean architecture pattern:

- **Models**: Data classes representing the app's domain
- **Providers**: State management using Provider pattern (similar to React Context)
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components
- **Navigation**: Route definitions and navigators

## Theme

The app supports both light and dark themes with automatic system detection.

Colors:
- Primary: #FA6C38 (Orange)
- Success: #4CAF50 (Green)
- Warning: #FFC107 (Yellow)
- Error: #F44336 (Red)

## Converting from React Native

This Flutter app is a complete conversion of the original React Native/Expo app. Key mappings:

| React Native | Flutter |
|--------------|---------|
| Context API | Provider |
| React Navigation | Navigator + Routes |
| StyleSheet | Widget styles |
| useState | StatefulWidget + setState |
| useEffect | initState / didChangeDependencies |
| TouchableOpacity | GestureDetector / InkWell |
| FlatList | ListView.builder |
| ScrollView | SingleChildScrollView |
