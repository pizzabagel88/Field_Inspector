# Field Inspector

A Flutter camera app with GPS, compass, and annotation capabilities, designed for field work and documentation. Similar to Conota Camera, this app provides real-time annotations on camera photos including project name, GPS coordinates, date/time, and compass direction.

## 🌟 Features

- **Camera Capture**: Take pictures using any camera on your phone (front/back)
- **Real-time Annotations**: Live overlay showing:
  - Project Name (configurable in settings)
  - Date and time the photo was taken
  - GPS coordinates in decimal degrees
  - Compass direction with degrees and cardinal direction
- **Camera Controls**:
  - Flash control (off/auto/on)
  - Camera switching (front/back)
  - Pinch-to-zoom functionality
- **Persistent Settings**: Project name persists between sessions
- **Clean UI**: Subtle white text annotations, no background overlay

## 📸 Screenshots

*Coming soon - Add screenshots of the camera interface and settings screen*

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.47.1 or higher
- **Dart**: 3.13.1 or higher
- **Android SDK**: API 36 or higher
- **Android Studio** (for Android development)
- **A physical Android device or emulator**

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/pizzabagel88/Field_Inspector.git
   cd Field_Inspector/field_inspector
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure local paths** (if needed):
   - Edit `android/local.properties`
   - Set `sdk.dir` to your Android SDK path
   - Set `flutter.sdk` to your Flutter SDK path

4. **Run the app**:
   ```bash
   flutter devices
   flutter run -d <device-id>
   ```

### Building for Release

**Android APK**:
```bash
flutter build apk --release
```
The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle** (for Play Store):
```bash
flutter build appbundle --release
```

## 📱 Usage

### Camera Screen
- **Take Photo**: Tap the center circular button
- **Flash Control**: Tap the flash icon to cycle through off/auto/on
- **Switch Camera**: Tap the flip icon to switch between front/back cameras
- **Zoom**: Pinch the screen to zoom in/out
- **Annotations**: View real-time annotations at the bottom of the screen

### Settings Screen
- Navigate to the Settings tab
- Enter your project name
- Tap "Save Settings" to persist the name
- The project name will appear on all photos until changed

## 🔐 Permissions

The app requires the following permissions:

- **Camera**: To take photos
- **Location** (Fine & Coarse): To get GPS coordinates
- **Storage**: To save photos to device storage

Permissions are requested at runtime and must be granted for full functionality.

## 🛠️ Development

### Tech Stack

- **Framework**: Flutter 3.47.1
- **Language**: Dart 3.13.1
- **Target SDK**: Android 14 (API 36)
- **Min SDK**: Android 8.0 (API 24)
- **Architecture**: Clean Architecture with separation of concerns

### Key Dependencies

- `camera`: Camera functionality
- `geolocator`: GPS location tracking
- `sensors_plus`: Compass and sensor data
- `permission_handler`: Runtime permissions
- `shared_preferences`: Persistent settings storage
- `path_provider`: File system access

### Project Structure

```
lib/
├── main.dart                 # App entry point
└── screens/
    ├── camera_screen.dart    # Camera functionality and annotations
    └── settings_screen.dart # Settings configuration
```

### Development Commands

```bash
# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Format code
flutter format .

# Clean build files
flutter clean
```

## 🐛 Troubleshooting

### Common Issues

**Camera not working**:
- Ensure camera permissions are granted
- Check if another app is using the camera
- Try restarting the app

**GPS showing "N/A"**:
- Ensure location permissions are granted
- Enable location services on your device
- For emulator: Set mock location via emulator controls

**Compass not working**:
- Ensure your device has a magnetometer
- Calibrate compass by moving device in figure-8 pattern
- Check if magnetic interference is present

**Build errors**:
- Run `flutter clean` and `flutter pub get`
- Ensure Flutter and Android SDK are properly configured
- Check `flutter doctor` for missing dependencies

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📧 Contact

For questions or support, please open an issue on GitHub.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Conota Camera for the inspiration
- Open-source community for the helpful libraries

---

**Note**: This app is designed for field work and documentation purposes. Always ensure you have proper permissions when taking photos in restricted areas.
