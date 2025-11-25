# Khelmitra Frontend

A Flutter mobile application for tracking live sports matches, scores, and team information.

## Features

- User authentication (register, login, profile management)
- Browse live, upcoming, and completed matches
- Filter matches by sport
- View detailed match information and score history
- Real-time score updates for live matches

## Prerequisites

- Flutter SDK (2.10.0 or higher)
- Dart SDK (2.16.0 or higher)
- Android Studio / VS Code with Flutter extensions
- A connected device or emulator

## Getting Started

### Installation

1. Clone the repository

```bash
git clone <repository-url>
cd khelmitra_frontend
```

2. Install dependencies

```bash
flutter pub get
```

3. Update the API base URL

Open `lib/services/api_service.dart` and update the `baseUrl` variable to point to your backend server.

```dart
static const String baseUrl = 'http://your-backend-url/api';
```

4. Run the application

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── providers/                # State management
│   ├── auth_provider.dart    # Authentication state
│   └── match_provider.dart   # Match data state
├── screens/                  # UI screens
│   ├── auth/                 # Authentication screens
│   ├── home/                 # Home screen and tabs
│   ├── match/                # Match detail screen
│   └── profile/              # User profile screen
├── services/                 # API services
│   └── api_service.dart      # Backend API communication
├── utils/                    # Utilities
│   └── app_theme.dart        # Theme configuration
└── widgets/                  # Reusable UI components
    ├── empty_state.dart      # Empty state display
    ├── match_card.dart       # Match card component
    └── score_board.dart      # Score display component
```

## API Integration

The application communicates with the Khelmitra backend API for all data operations. The `ApiService` class in `lib/services/api_service.dart` handles all API requests and responses.

## Authentication

The application uses token-based authentication. When a user logs in, the backend returns an authentication token that is stored securely using `flutter_secure_storage`. This token is included in the headers of subsequent API requests.

## State Management

The application uses the Provider pattern for state management:

- `AuthProvider`: Manages user authentication state
- `MatchProvider`: Manages match data and loading states

## Theming

The application supports both light and dark themes, configured in `lib/utils/app_theme.dart`.

## Building for Production

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.