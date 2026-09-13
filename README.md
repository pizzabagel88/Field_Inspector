# Field Inspector

A professional Flutter camera app designed for field work and documentation. Inspired by Conota Camera, this app provides real-time camera annotations with GPS, compass, and customizable metadata that are permanently embedded in saved photos.

## 🌟 Features

### Camera & Capture
- **Multi-Camera Support**: Use front or rear cameras
- **Advanced Camera Controls**:
  - Flash modes (off/auto/on)
  - Pinch-to-zoom with smooth scaling
  - Camera switching
- **Image Orientation Preservation**: Photos save in the same orientation as captured

### Annotation System
- **8 Annotation Types**:
  - Project Name (configurable)
  - Date and Time (local timezone)
  - GPS Coordinates (decimal degrees)
  - Compass Direction (degrees + cardinal direction)
  - Elevation (meters)
  - Inspector Name
  - Custom Note
  - Photo Sequence Number (auto-incrementing)
- **Flexible Placement**: Position each annotation on left, right, or disable
- **Drag-to-Reorder**: Customize annotation order via drag-and-drop
- **Embedded Annotations**: All annotations are burned into saved photos
- **Clean Overlay**: Subtle white text, no background overlay

### Gallery Integration
- **Automatic Gallery Saving**: Photos save to device gallery in "Field Inspector" album
- **Gallery Button**: Quick access to device gallery from camera screen
- **Samsung Camera-Style Layout**: Gallery button left of centered shutter

### Settings & Persistence
- **Persistent Configuration**: All settings saved between sessions
- **Auto-Save**: Changes save automatically
- **Customizable Metadata**: Project name, inspector name, custom notes

## 📸 Screenshots

*Coming soon - Screenshots of the camera interface with annotations, settings screen, and gallery integration*

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.47.1 or higher
- **Dart**: 3.13.1 or higher
- **Android SDK**: API 36 (Android 16) or higher
- **Android Studio** (for Android development)
- **A physical Android device or emulator**
- **Minimum Android Version**: Android 8.0 (API 24)

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

**For Windows users**: Use `flutter.bat` instead of `flutter` if Flutter is not in your PATH.

### Building for Release

**Android APK** (for direct distribution):
```bash
flutter build apk --release
```
The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle** (for Google Play Store):
```bash
flutter build appbundle --release
```
The AAB will be located at `build/app/outputs/bundle/release/app-release.aab`

**Note**: Before building for release, ensure you have:
- Updated the version number in `pubspec.yaml`
- Configured signing keys for the Play Store
- Updated app icons and launcher assets

## 📱 Usage

### Camera Screen
- **Take Photo**: Tap the center circular shutter button
- **Flash Control**: Tap the flash icon (left) to cycle through off/auto/on
- **Switch Camera**: Tap the flip icon (right) to switch between front/back cameras
- **Zoom**: Pinch the screen to zoom in/out
- **Gallery Access**: Tap the gallery button (left of shutter) to open device gallery
- **Annotations**: View real-time annotations at the bottom of the screen
- **Photo Saving**: Photos automatically save to device gallery with embedded annotations

### Settings Screen
- Navigate to the Settings tab
- **Project Information**:
  - Set project name (appears on all photos)
  - Add inspector name
  - Add custom notes
- **Annotation Configuration**:
  - Drag items to reorder annotations
  - Use dropdown to set placement (Left/Right/Disabled)
  - Disable annotations you don't want to show
- **Auto-Save**: All changes save automatically

### Gallery Integration
- Photos save to `Pictures/Field Inspector/` folder
- Annotations are permanently embedded in saved images
- Gallery button opens device gallery in viewing mode
- Images preserve capture orientation (vertical/horizontal)

## 🔐 Permissions

The app requires the following Android permissions:

- **CAMERA**: To capture photos and access camera hardware
- **ACCESS_FINE_LOCATION**: To get precise GPS coordinates
- **ACCESS_COARSE_LOCATION**: To get approximate location when precise location unavailable
- **READ_EXTERNAL_STORAGE**: To access device gallery (legacy Android versions)
- **WRITE_EXTERNAL_STORAGE**: To save photos to device storage (legacy Android versions)
- **READ_MEDIA_IMAGES**: To access gallery images (Android 13+)

Permissions are requested at runtime and must be granted for full functionality. The app gracefully handles permission denials with appropriate user feedback.

## 🛠️ Development

### Tech Stack

- **Framework**: Flutter 3.47.1
- **Language**: Dart 3.13.1
- **Target SDK**: Android 16 (API 36)
- **Min SDK**: Android 8.0 (API 24)
- **Build Tools**: Gradle 8.14.0, AGP 8.11.1, Kotlin 2.2.20
- **Architecture**: Clean Architecture with separation of concerns

### Key Dependencies

- `camera`: Camera functionality and preview
- `geolocator`: GPS location tracking
- `sensors_plus`: Compass and magnetometer data
- `permission_handler`: Runtime permission management
- `shared_preferences`: Persistent settings storage
- `intl`: Date/time formatting
- `image_picker`: Gallery access

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── annotation_settings.dart  # Annotation configuration model
└── screens/
    ├── camera_screen.dart    # Camera functionality and annotations
    └── settings_screen.dart # Settings configuration

android/
├── app/
│   └── src/main/
│       ├── kotlin/com/example/field_inspector/
│       │   └── MainActivity.kt  # Native Android code for gallery/annotations
│       └── AndroidManifest.xml  # Permissions and app configuration
└── build.gradle              # Android build configuration
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
- Try restarting the app or device
- Verify camera hardware is functional

**GPS showing "N/A"**:
- Ensure location permissions are granted
- Enable location services on your device
- For emulator: Set mock location via extended controls
- Check if GPS is enabled in device settings

**Compass not working**:
- Ensure your device has a magnetometer
- Calibrate compass by moving device in figure-8 pattern
- Check for magnetic interference (metal objects, electronics)
- Ensure device is not in a magnetic case

**Annotations not appearing in saved photos**:
- Ensure storage permissions are granted
- Check that the MediaStore integration is working
- Verify the app has write access to Pictures directory
- Try taking another photo after granting permissions

**Gallery button not opening gallery**:
- Ensure the app has gallery access permissions
- Check that a gallery app is installed on the device
- Try opening the gallery app manually first

**Build errors**:
- Run `flutter clean` and `flutter pub get`
- Ensure Flutter and Android SDK are properly configured
- Check `flutter doctor` for missing dependencies
- Verify Gradle version compatibility (requires 8.14.0+)

**Photos saved in wrong orientation**:
- This should be fixed with EXIF orientation handling
- If issues persist, check device camera orientation settings
- Verify the native Android code is processing EXIF data correctly

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Run `flutter analyze` before committing
- Test on both physical devices and emulators
- Update documentation for new features
- Ensure all permissions are properly handled

## 📧 Contact

For questions or support, please open an issue on GitHub.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Conota Camera for the inspiration
- Open-source community for the helpful libraries
- Android documentation for MediaStore and EXIF handling

## 📄 Privacy & Data

This app:
- Does not collect or transmit any personal data
- All data is stored locally on the device
- Photos are saved to device gallery only
- No internet connection required for core functionality
- No analytics or tracking implemented

## 🌐 Deployment

### Google Play Store

Before deploying to the Play Store:

1. **Update app metadata**:
   - App name and description
   - Screenshots and promotional graphics
   - Privacy policy URL
   - Content rating

2. **Configure signing**:
   - Generate signing key
   - Configure `android/key.properties`
   - Update `android/app/build.gradle` with signing config

3. **Testing**:
   - Test on multiple Android versions
   - Test on different screen sizes
   - Verify all permissions work correctly
   - Test in-app purchases (if any)

4. **Submit**:
   - Create AAB file: `flutter build appbundle --release`
   - Upload to Google Play Console
   - Complete store listing
   - Submit for review

---

**Note**: This app is designed for field work and documentation purposes. Always ensure you have proper permissions when taking photos in restricted areas.
