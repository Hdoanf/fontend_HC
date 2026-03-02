# Smart Home IoT Management System (Thực Tập)

A comprehensive cross-platform Flutter application for managing and monitoring Smart Home IoT devices, featuring real-time video streaming, data visualization, and automated scheduling.

## 🚀 Key Features

- **Multi-platform Support**: Fully responsive design supporting both **Mobile** and **Desktop** layouts.
- **Device Management**: Monitor and control smart devices (lights, fans, etc.) with real-time status updates.
- **Video Monitoring**: Integrated support for MJPEG and standard video streaming for security cameras.
- **Data Visualization**: Interactive charts (FL Chart) to track device usage and environmental statistics.
- **Fire Alert System**: Dedicated safety feature for real-time fire detection alerts.
- **Task Scheduler**: Automated scheduling for device operations (e.g., timing for lights or climate control).
- **Secure Authentication**: User login and profile management system.
- **Responsive UI**: Adaptive interfaces designed for different screen sizes and orientations.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.10.7)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Navigation**: [Go Router](https://pub.dev/packages/go_router)
- **Charts**: [FL Chart](https://pub.dev/packages/fl_chart)
- **Networking**: [HTTP](https://pub.dev/packages/http)
- **Multimedia**: [Video Player](https://pub.dev/packages/video_player) & [Flutter MJPEG](https://pub.dev/packages/flutter_mjpeg)
- **Icons**: [Font Awesome Flutter](https://pub.dev/packages/font_awesome_flutter) & [Cupertino Icons](https://pub.dev/packages/cupertino_icons)

## 📁 Project Structure

```text
lib/
├── app/            # Application configuration and routing
├── core/           # Constants, themes, utilities, and global widgets
├── features/       # Feature-based modular architecture
│   ├── auth/       # Login and registration
│   ├── device/     # Device control and video streaming
│   ├── fire_alert/ # Safety and alerting system
│   ├── home/       # Dashboard and main landing
│   ├── location/   # Geo-location services
│   ├── profile/    # User profile management
│   ├── scheduler/  # Timed tasks and automation
│   ├── settings/   # Application settings
│   └── stats/      # Usage analytics and charts
└── shared/         # Shared responsive layout components
```

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.7)
- Dart SDK
- Android Studio / VS Code with Flutter extension
- An emulator or physical device

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Hdoanf/fontend_HC.git
   cd fontend
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   # Run on connected device/emulator
   flutter run

   # For specific platform
   flutter run -d chrome  # Web
   flutter run -d linux   # Linux Desktop
   ```

## 🎨 Design System

The project follows a clean, modern design system using:
- **Responsive Layouts**: Separate implementations for mobile and desktop views (`lib/shared/responsive`).
- **Theming**: Centralized color and size constants in `lib/core/constants`.
- **Assets**: Custom icons and high-quality room/device images stored in `assets/images`.

## 📝 License

This project is for internal/educational use. See `pubspec.yaml` for more details.

