# GEMINI.md - Smart Home IoT Management System (Thực Tập)

This file provides context and instructions for AI agents working on the Smart Home IoT Management System project.

## 🚀 Project Overview

A cross-platform Flutter application designed for managing and monitoring Smart Home IoT devices. The project is structured to support both Mobile and Desktop platforms with a responsive and modular architecture.

### 🛠 Tech Stack
- **Framework**: Flutter (SDK ^3.10.7)
- **Language**: Dart
- **State Management**: [Riverpod](https://riverpod.dev/) (StateNotifier, FutureProvider, Notifier)
- **Navigation**: [Go Router](https://pub.dev/packages/go_router)
- **Networking**: [HTTP](https://pub.dev/packages/http) with a custom `ApiClient` handler.
- **Real-time**: [SignalR](https://pub.dev/packages/signalr_netcore) for fire alerts and device status.
- **Multimedia**: `video_player` and `flutter_mjpeg` for security camera feeds.
- **Configuration**: `flutter_dotenv` for environment variables.

## 📁 Architecture & Directory Structure

The project follows a **Feature-based Modular Architecture** with Clean Architecture principles within each module.

```text
lib/
├── app/                # Global app config, providers, and router
├── core/               # Shared logic across the app
│   ├── constants/      # App-wide constants (Colors, Strings, Sizes)
│   ├── localization/   # Multi-language support
│   ├── services/       # Base services (ApiClient, Storage, SignalR)
│   ├── theme/          # App themes (Light/Dark)
│   ├── utils/          # Helper functions and UI utilities
│   └── widgets/        # Common UI components (AppButton, AppTextField)
├── features/           # Independent feature modules
│   └── <feature_name>/
│       ├── data/       # Repositories, Data Sources, and Models
│       ├── domain/     # Entities and Business Logic State
│       └── presentation/ # UI Screens, Controllers, and Widgets
└── shared/             # Shared components specifically for layout
```

## 🛠 Building and Running

### Prerequisites
- Flutter SDK (>= 3.10.7)
- Dart SDK
- Environment file: Create a `.env` file based on `.env.example`.

### Commands
- **Install dependencies**: `flutter pub get`
- **Run the app**: `flutter run`
- **Build for Web**: `flutter build web`
- **Build for Android**: `flutter build apk`
- **Code Analysis**: `flutter analyze`

## 📝 Development Conventions

### Coding Style
- **State Management**: Use Riverpod for all state handling. Prefer `Notifier` or `StateNotifier` for complex state.
- **Service Injection**: Access services (like `ApiClient`) through global providers defined in `lib/app/providers.dart`.
- **UI Consistency**: Use constants from `lib/core/constants` for colors, spacing, and font sizes.
- **Responsiveness**: Check `lib/core/utils/responsive_layout.dart` and `lib/shared/responsive` when building screens to ensure compatibility across Mobile and Desktop.

### Network Layer
- All API calls should go through the `ApiClient` located in `lib/core/services/api_client.dart`.
- Endpoints should be relative paths; the base URL is managed by `dotenv`.

### Assets
- **Icons**: Place in `assets/icon`.
- **Images**: Place in `assets/images`. Room images follow specific naming (e.g., `living_room.png`).

## 🚨 Feature Specifics

### Fire Alert System
- **Real-time Monitoring**: Handled via `FireSignalRService` in `lib/core/services`.
- **History**: Temperature data history can be retrieved using `getSensorDataByDeviceId` in `FireAlertRepository`.

### Video Streaming
- Supports both standard video and MJPEG streams. See `lib/core/widgets/webcam_mjpeg_view.dart` for implementation details.
