import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../models/annotation_settings.dart';

class _AnnotationValue {
  final String text;
  final AnnotationPlacement placement;

  _AnnotationValue({required this.text, required this.placement});
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  String? _projectName;
  String _inspectorName = '';
  String _customNote = '';
  int _photoSequence = 1;
  List<AnnotationItem> _annotationItems = List.of(AnnotationSettings.defaults);
  Position? _currentPosition;
  double? _compassDirection;
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  List<double>? _magnetometerValues;
  bool _isInitialized = false;
  double _zoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  FlashMode _flashMode = FlashMode.off;
  static const platform = MethodChannel('com.example.field_inspector/gallery');

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadSettings();
    _startLocationUpdates();
    _startCompassUpdates();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _controller!.initialize();

        // Get zoom levels
        _maxZoomLevel = await _controller!.getMaxZoomLevel();
        _minZoomLevel = await _controller!.getMinZoomLevel();

        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final annotationSettings = await AnnotationSettings.load(prefs);
    if (!mounted) return;
    setState(() {
      _projectName = prefs.getString('project_name') ?? 'Default Project';
      _inspectorName = prefs.getString('inspector_name') ?? '';
      _customNote = prefs.getString('custom_note') ?? '';
      _photoSequence = prefs.getInt('photo_sequence') ?? 1;
      _annotationItems = annotationSettings.items;
    });
  }

  void _startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    }, onError: (error) {
      print('Location error: $error');
    });
  }

  void _startCompassUpdates() {
    _magnetometerSubscription =
        magnetometerEventStream().listen((MagnetometerEvent event) {
      if (mounted) {
        setState(() {
          _magnetometerValues = [event.x, event.y, event.z];
          _compassDirection = _calculateCompassDirection();
        });
      }
    });
  }

  double? _calculateCompassDirection() {
    if (_magnetometerValues == null || _magnetometerValues!.length < 3) {
      return null;
    }

    final x = _magnetometerValues![0];
    final y = _magnetometerValues![1];

    // Calculate heading from magnetometer data
    var heading = math.atan2(y, x) * (180 / math.pi);

    // Normalize to 0-360
    if (heading < 0) {
      heading += 360;
    }

    return heading;
  }

  String _formatCoordinates(Position? position) {
    if (position == null) return 'GPS: N/A';
    return '${position.latitude.toStringAsFixed(6)}°, ${position.longitude.toStringAsFixed(6)}°';
  }

  String _formatCompassDirection(double? direction) {
    if (direction == null) return 'N/A';

    String cardinal = '';
    final degrees = direction % 360;

    if (degrees >= 337.5 || degrees < 22.5) {
      cardinal = 'N';
    } else if (degrees >= 22.5 && degrees < 67.5) {
      cardinal = 'NE';
    } else if (degrees >= 67.5 && degrees < 112.5) {
      cardinal = 'E';
    } else if (degrees >= 112.5 && degrees < 157.5) {
      cardinal = 'SE';
    } else if (degrees >= 157.5 && degrees < 202.5) {
      cardinal = 'S';
    } else if (degrees >= 202.5 && degrees < 247.5) {
      cardinal = 'SW';
    } else if (degrees >= 247.5 && degrees < 292.5) {
      cardinal = 'W';
    } else if (degrees >= 292.5 && degrees < 337.5) {
      cardinal = 'NW';
    }

    return '${degrees.toStringAsFixed(0)}° $cardinal';
  }

  String _formatDateTime() {
    final now = DateTime.now();
    return DateFormat('MMM d, yyyy h:mm a').format(now);
  }

  String _formatElevation(Position? position) {
    if (position == null) return 'Elevation: N/A';
    return 'Elevation: ${position.altitude.toStringAsFixed(1)} m';
  }

  String _annotationText(String id) {
    switch (id) {
      case 'project_name':
        final projectName = _projectName?.trim() ?? '';
        return projectName.isEmpty ? 'Default Project' : projectName;
      case 'date_time':
        return _formatDateTime();
      case 'coordinates':
        return _formatCoordinates(_currentPosition);
      case 'compass':
        return _formatCompassDirection(_compassDirection);
      case 'elevation':
        return _formatElevation(_currentPosition);
      case 'inspector_name':
        return _inspectorName.isEmpty
            ? 'Inspector: N/A'
            : 'Inspector: $_inspectorName';
      case 'custom_note':
        return _customNote.isEmpty ? 'Note: N/A' : 'Note: $_customNote';
      case 'photo_sequence':
        return 'Photo #${_photoSequence.toString().padLeft(4, '0')}';
      default:
        return '';
    }
  }

  List<_AnnotationValue> _getAnnotationValues() {
    return _annotationItems
        .where((item) => item.placement != AnnotationPlacement.disabled)
        .map((item) => _AnnotationValue(
              text: _annotationText(item.id),
              placement: item.placement,
            ))
        .toList();
  }

  Widget _buildAnnotationColumn(AnnotationPlacement placement) {
    final items =
        _annotationItems.where((item) => item.placement == placement).toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: placement == AnnotationPlacement.left
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: items
            .map(
              (item) => Text(
                _annotationText(item.id),
                textAlign: placement == AnnotationPlacement.left
                    ? TextAlign.left
                    : TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();

      // Add annotations to the image
      final annotatedImage = await _addAnnotationsToImage(image.path);

      // Save to device Pictures directory (accessible by gallery)
      await _saveToGallery(annotatedImage.path);

      final preferences = await SharedPreferences.getInstance();
      final nextSequence = _photoSequence + 1;
      await preferences.setInt('photo_sequence', nextSequence);

      if (mounted) {
        setState(() {
          _photoSequence = nextSequence;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo saved to gallery')),
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving photo: $e')),
        );
      }
    }
  }

  Future<void> _saveToGallery(String imagePath) async {
    try {
      // Get annotation values to embed in the image
      final annotations = _getAnnotationValues().map((a) => {
        'text': a.text,
        'placement': a.placement.toString().split('.').last,
      }).toList();

      // Use Android MediaStore to properly save to gallery with annotations
      final String? savedPath = await platform.invokeMethod('saveToGallery', {
        'imagePath': imagePath,
        'annotations': annotations,
      });
      
      if (savedPath == null) {
        throw Exception('Failed to save image to gallery');
      }
      
      print('Image saved to gallery: $savedPath');
    } catch (e) {
      print('Error saving to gallery: $e');
      rethrow;
    }
  }

  Future<void> _openGallery() async {
    try {
      // Use native Android intent to open gallery in viewing mode
      await platform.invokeMethod('openGallery');
    } catch (e) {
      print('Error opening gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening gallery: $e')),
        );
      }
    }
  }

  Future<File> _addAnnotationsToImage(String imagePath) async {
    // Annotations are now embedded in the native Android code
    // This function is kept for compatibility but does nothing
    return File(imagePath);
  }

  void _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentCameraIndex = _cameras!.indexOf(_controller!.description);
    final newCameraIndex = (currentCameraIndex + 1) % _cameras!.length;

    await _controller!.dispose();

    _controller = CameraController(
      _cameras![newCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    _maxZoomLevel = await _controller!.getMaxZoomLevel();
    _minZoomLevel = await _controller!.getMinZoomLevel();
    _zoomLevel = 1.0;

    if (mounted) {
      setState(() {});
    }
  }

  void _toggleFlash() async {
    if (_controller == null) return;

    FlashMode newFlashMode;
    switch (_flashMode) {
      case FlashMode.off:
        newFlashMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newFlashMode = FlashMode.always;
        break;
      case FlashMode.always:
        newFlashMode = FlashMode.off;
        break;
      default:
        newFlashMode = FlashMode.off;
    }

    await _controller!.setFlashMode(newFlashMode);

    if (mounted) {
      setState(() {
        _flashMode = newFlashMode;
      });
    }
  }

  void _handleZoomScale(double scale) {
    if (_controller == null) return;

    setState(() {
      _zoomLevel = (_zoomLevel * scale).clamp(_minZoomLevel, _maxZoomLevel);
    });

    _controller!.setZoomLevel(_zoomLevel);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInitialized && _controller != null
          ? Stack(
              children: [
                // Camera preview
                GestureDetector(
                  onScaleStart: (_) {},
                  onScaleUpdate: (details) {
                    _handleZoomScale(details.scale);
                  },
                  child: CameraPreview(_controller!),
                ),

                // Annotations overlay - single row at bottom
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 100,
                  child: Row(
                    children: [
                      _buildAnnotationColumn(AnnotationPlacement.left),
                      const SizedBox(width: 16),
                      _buildAnnotationColumn(AnnotationPlacement.right),
                    ],
                  ),
                ),

                // Camera controls
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80,
                    child: Stack(
                      children: [
                        // Flash button - left side
                        Positioned(
                          left: 32,
                          top: 20,
                          child: IconButton(
                            icon: Icon(_getFlashIcon()),
                            onPressed: _toggleFlash,
                            color: Colors.white,
                            iconSize: 32,
                          ),
                        ),
                        // Camera switch button - right side
                        Positioned(
                          right: 32,
                          top: 20,
                          child: IconButton(
                            icon: const Icon(Icons.flip_camera_ios),
                            onPressed: _switchCamera,
                            color: Colors.white,
                            iconSize: 32,
                          ),
                        ),
                        // Center row with gallery and shutter
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Gallery button
                              GestureDetector(
                                onTap: _openGallery,
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    color: Colors.transparent,
                                  ),
                                  child: const Icon(
                                    Icons.photo_library,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Shutter button - centered
                              GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 4),
                                    color: Colors.transparent,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing camera...'),
                ],
              ),
            ),
    );
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }
}
