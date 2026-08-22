# Changelog

All notable changes to Field Inspector will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of Field Inspector camera app
- Camera capture with front/back camera switching
- Real-time GPS location tracking
- Compass direction display with degrees and cardinal direction
- Configurable project name in settings
- Persistent storage for project name
- Flash control (off/auto/on)
- Pinch-to-zoom functionality
- Live annotation overlay on camera preview
- Photo saving to device storage
- Date/time display in local readable format
- GPS coordinates in decimal degrees
- Settings screen for project configuration
- Runtime permission handling for camera, location, and storage

### Features
- Clean, minimal UI with subtle white text annotations
- Single-row annotation layout at bottom of screen
- Support for Android 8.0+ (API 24+)
- Material Design 3 theming
- Bottom navigation between camera and settings

### Technical
- Flutter 3.47.1 with Dart 3.13.1
- Target SDK: Android 14 (API 36)
- Clean architecture with separated concerns
- Efficient sensor data handling
- Proper error handling and user feedback

## [1.0.0] - 2026-08-21

### Added
- Initial public release
- Core camera functionality
- GPS and compass integration
- Annotation system
- Settings and configuration
- Android release build

[Unreleased]: https://github.com/pizzabagel88/Field_Inspector/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/pizzabagel88/Field_Inspector/releases/tag/v1.0.0