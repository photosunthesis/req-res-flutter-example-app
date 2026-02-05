# ReqRes Flutter

A modern Flutter application showcasing authentication flows, profile creation, and a rich news feed interface. Built with clean architecture principles and state management using Riverpod.

## 📱 Features

- **Authentication**: Email/password login with a multi-step registration flow (OTP, password creation).
- **Profile Wizard**: Guided setup for display name, username validation, and profile photo selection.
- **Dynamic Home Feed**: A rich, sliver-based news feed with featured carousels, category tabs, and social interactions.
- **Account Management**: User profile overview with persistent local storage and sign-out logic.
- **Premium UI**: Sleek, responsive design using custom components, gradients, and optimized scrolling.

## ⚠️ Demo Limitations

This app uses the [ReqRes API](https://reqres.in) which has limited endpoints. The following workarounds are in place:

| Area | Workaround |
| ------ | ------------ |
| **Login/Register** | Credentials are overridden with `eve.holt@reqres.in` / `pistol` since ReqRes only accepts predefined accounts. |
| **Profile Data** | Stored locally via `SharedPreferences` as ReqRes has no profile endpoints. `initiateProfile()` pre-populates default data. |
| **Home Feed** | Static hardcoded content—ReqRes doesn't provide news/feed endpoints. |
| **Forgot Password** | Shows an "Account Locked" dialog as a placeholder. |
| **Terms & Conditions** | Tapping opens a consent dialog instead of navigating to actual terms. |
| **Social Login** | Google/Facebook buttons are present but non-functional (no OAuth configured). |

## 🏗️ Architecture

The application follows **Clean Architecture** principles with clear separation of concerns:

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── api_client_provider.dart
│   ├── shared_preferences_provider.dart
│   ├── is_signed_in_provider.dart
│   └── image_picker_provider.dart
├── data/
│   ├── models/
│   └── repositories/
│       ├── auth_repository.dart
│       └── profile_repository.dart
├── features/
│   ├── login/
│   ├── register/
│   ├── create_profile/
│   ├── home/
│   └── account/
├── ui_components/
├── constants/
└── l10n/
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

## ⚙️ Getting Started

1. **Install dependencies**: `flutter pub get`
2. **Run the app**: `flutter run --dart-define=X_API_KEY=your_key`
3. **Run tests**: `flutter test --test-randomize-ordering-seed random`

## � CI/CD

Automated workflows (GitHub Actions):

- **Testing**: Runs on all PRs and pushes to ensure code quality.
- **Release**: On pushes to `main`, builds obfuscated APKs (ARMv7, ARM64, x86_64) and creates GitHub releases.

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
