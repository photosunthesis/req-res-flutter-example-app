# ReqRes Flutter

A modern Flutter application showcasing authentication flows, profile creation, and a rich news feed interface. Built with clean architecture principles and state management using Riverpod.

## 📱 Features

- **Authentication**: Email/password login with a multi-step registration flow (OTP, password creation).
- **Profile Wizard**: Guided setup for display name, username validation, and profile photo selection.
- **Dynamic Home Feed**: A rich, sliver-based news feed with featured carousels, category tabs, and social interactions.
- **Account Management**: User profile overview with persistent local storage and sign-out logic.
- **Premium UI**: Sleek, responsive design using custom components, gradients, and optimized scrolling.

## 🏗️ Architecture

The application follows **Clean Architecture** principles with clear separation of concerns:

```text
lib/
├── app/                      # App-level configuration
│   ├── app.dart             # Root app widget
│   ├── router.dart          # GoRouter navigation config
│   └── theme.dart           # App theme & colors
├── core/                     # Core functionality
│   ├── api_client_provider.dart        # Dio HTTP client
│   ├── shared_preferences_provider.dart # Local storage
│   ├── is_signed_in_provider.dart      # Auth state
│   └── image_picker_provider.dart      # Image selection
├── data/                     # Data layer
│   ├── models/              # Data models
│   └── repositories/        # Data access layer
│       ├── auth_repository.dart      # Authentication logic
│       └── profile_repository.dart   # Profile management
├── features/                 # Feature modules
│   ├── login/               # Login feature
│   ├── register/            # Registration flow
│   ├── create_profile/      # Profile creation wizard
│   ├── home/                # Home feed
│   └── account/             # Account management
├── ui_components/           # Reusable UI widgets
├── constants/               # App constants (icons, images)
└── l10n/                    # Internationalization (i18n)
```

### Key Architectural Patterns

- **Feature-First Organization**: Code organized by feature for better maintainability
- **Repository Pattern**: Centralized data access through repositories
- **Provider-Based State Management**: Using Riverpod for reactive state
- **Separation of Concerns**: UI logic separated from business logic

## 🛠️ Tech Stack

- **Framework**: Flutter (Dart SDK)
- **State & Routing**: Riverpod for state management and GoRouter for declarative navigation.
- **Data & Networking**: Dio (HTTP), SharedPreferences (local storage), and Path Provider.
- **UI & Assets**: Google Fonts, Flutter SVG, Image Picker, and Pinput (OTP).
- **Quality & Localization**: `intl` for i18n, `mocktail` for testing, and standard Flutter lints.

## 🎨 Design Highlights

- **Modern UI**: Clean, card-based design with subtle shadows
- **Gradient Accents**: Primary gradient used on CTAs and interactive elements
- **Responsive Layouts**: Slivers for efficient scrolling performance
- **Custom Components**: Reusable text fields, buttons, and dialogs
- **Theme System**: Centralized color palette and text styles

## ⚙️ Setup & Running

### Prerequisites

- Flutter installed
- Xcode (for iOS) or Android Studio (for Android)

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd req_res_flutter
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   # Development mode (with API key)
   flutter run --dart-define=X_API_KEY=your_api_key_here
   
   # Or use a relase build
   flutter run --release --dart-define=X_API_KEY=your_api_key_here
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests in random order (recommended for CI)
flutter test --test-randomize-ordering-seed random
```

## 🔧 Configuration Notes

### Environment Variables

The app uses `--dart-define` for configuration:

- **X_API_KEY**: Required for API authentication (passed at build/run time)

### API Integration

The app integrates with the [ReqRes API](https://reqres.in) for demonstration purposes.

## 📋 Important Implementation Notes

Due to specific requirements and time constraints, certain architectural decisions were made intentionally:

### 1. **Hardcoded Registration Credentials**

**Location**: `lib/data/repositories/auth_repository.dart`

The ReqRes API only allows registration with specific predefined accounts. To ensure the registration flow works consistently, user login and registration overrides user input with a known valid account:

```dart
email = 'eve.holt@reqres.in';
password = 'pistol';
```

**Rationale**: This ensures the demo app can complete the full registration flow without API errors. In a production app, this would use actual user credentials.

### 2. **Fake Profile Data in Repository**

**Location**: `lib/data/repositories/profile_repository.dart`

The `ProfileRepository` uses `SharedPreferences` as a mock backend rather than making actual API calls. The `initiateProfile()` method pre-populates hardcoded profile data:

```dart
await Future.wait([
  _prefs.setString('first_name', 'Eve'),
  _prefs.setString('last_name', 'Holt'),
  _prefs.setString('username', 'eve.holt'),
]);
```

**Rationale**: The ReqRes API doesn't provide endpoints for profile management. Using local storage simulates a backend while demonstrating the app's profile creation flow and state management.

### 3. **Dialog Behavior on Login Screen**

**Location**: `lib/features/login/login_screen.dart`

Two dialogs are triggered by actions that would normally perform different operations:

- **Forgot Password** → Shows "Account Locked" dialog
- **Terms & Conditions tap** → Shows consent dialog

**Rationale**: These demonstrate the dialog system and UI patterns without implementing full password recovery or terms viewing infrastructure, which was outside the scope given time constraints.

### 4. **Static Home Feed Content**

**Location**: `lib/features/home/home_screen.dart`

The news feed displays static hardcoded content rather than fetching from an API.

**Rationale**: The ReqRes API doesn't provide news/feed endpoints. The static content demonstrates the UI architecture, scrolling behavior, and card layouts.

### 5. **No Actual Social Login**

**Location**: `lib/features/login/login_screen.dart`

Google and Facebook login buttons are present but have empty `onPressed` handlers.

**Rationale**: Implementing OAuth flows requires additional setup (Firebase, Facebook App, etc.) that was beyond the scope of this demonstration app.

## 🚀 CI/CD

The project includes GitHub Actions workflows:

### Test Workflow (`.github/workflows/test.yml`)

- Runs on all pushes and pull requests
- Executes tests in randomized order for reliability
- Uses Flutter latest stable

### Build & Release Workflow (`.github/workflows/build-release.yml`)

- Triggers on pushes to `main` branch
- Builds release APKs for multiple architectures:
  - ARM v7a (32-bit devices)
  - ARM64 v8a (modern 64-bit devices)
  - x86_64 (emulators)
- Creates GitHub releases with automatic versioning
- Includes code obfuscation and split debug info for security

## 🧪 Testing

### Testing Philosophy

This project follows a **behavior-driven testing approach** with a pragmatic philosophy:

- **Mock Less, Test More**: Only mock external dependencies (API calls, local storage, file system)
- **Test What Users See**: Focus on actual UI behavior rather than implementation details
- **Behavior Over Units**: Users don't see the "why" or "how" - they see the UI and its behavior
- **Efficient Coverage**: Write fewer tests that validate real user flows, achieving good coverage with less code

### Test Coverage

The project includes widget tests for critical user flows:

- **Login Screen Tests**: Form validation, navigation, error handling
- **Create Profile Tests**: Multi-step wizard flow, state management, image picking

Tests use **mocktail** sparingly to mock only external systems (repositories, storage, image picker), while testing the actual component behavior and state management as users would experience it.
