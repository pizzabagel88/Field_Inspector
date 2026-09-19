import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/annotation_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _platform = MethodChannel('com.example.field_inspector/gallery');
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _inspectorNameController =
      TextEditingController();
  final TextEditingController _customNoteController = TextEditingController();
  List<AnnotationItem> _annotationItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final annotationSettings = await AnnotationSettings.load(preferences);
    if (!mounted) return;

    setState(() {
      _projectNameController.text =
          preferences.getString('project_name') ?? 'Default Project';
      _inspectorNameController.text =
          preferences.getString('inspector_name') ?? '';
      _customNoteController.text = preferences.getString('custom_note') ?? '';
      _annotationItems = annotationSettings.items;
      _isLoading = false;
    });
  }

  Future<void> _saveTextSetting(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value.trim());
  }

  Future<void> _saveAnnotationSettings() async {
    final preferences = await SharedPreferences.getInstance();
    await AnnotationSettings(_annotationItems).save(preferences);
  }

  Future<void> _openPrivacyPolicy() async {
    try {
      await _platform.invokeMethod<void>('openPrivacyPolicy');
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the privacy policy')),
        );
      }
    }
  }

  Future<void> _openTipPage() async {
    try {
      await _platform.invokeMethod<void>('openTipPage');
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the tip page')),
        );
      }
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _inspectorNameController.dispose();
    _customNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Project Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _projectNameController,
              onChanged: (value) => _saveTextSetting('project_name', value),
              decoration: const InputDecoration(
                labelText: 'Project Name',
                hintText: 'Enter project name',
                border: OutlineInputBorder(),
                helperText: 'This name will appear on all photos until changed',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inspectorNameController,
              onChanged: (value) => _saveTextSetting('inspector_name', value),
              decoration: const InputDecoration(
                labelText: 'Inspector Name',
                hintText: 'Enter inspector name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customNoteController,
              onChanged: (value) => _saveTextSetting('custom_note', value),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Custom Note',
                hintText: 'Enter a note to display on photos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Photo Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose where each item appears. Drag the handle to change its order.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: _annotationItems.length,
              onReorderItem: (oldIndex, newIndex) {
                setState(() {
                  final item = _annotationItems.removeAt(oldIndex);
                  _annotationItems.insert(newIndex, item);
                });
                _saveAnnotationSettings();
              },
              itemBuilder: (context, index) {
                final item = _annotationItems[index];
                return Card(
                  key: ValueKey(item.id),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, right: 4),
                    title: Text(item.label),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<AnnotationPlacement>(
                          value: item.placement,
                          underline: const SizedBox.shrink(),
                          items: AnnotationPlacement.values
                              .map(
                                (placement) => DropdownMenuItem(
                                  value: placement,
                                  child: Text(_placementLabel(placement)),
                                ),
                              )
                              .toList(),
                          onChanged: (placement) {
                            if (placement == null) return;
                            setState(() {
                              _annotationItems[index] =
                                  item.copyWith(placement: placement);
                            });
                            _saveAnnotationSettings();
                          },
                        ),
                        ReorderableDragStartListener(
                          index: index,
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.drag_handle),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Field Inspector',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Version 1.0.0'),
                    SizedBox(height: 8),
                    Text(
                      'A camera app with GPS, compass, and annotation capabilities.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy policy'),
              subtitle: const Text('How Field Inspector handles your data'),
              onTap: _openPrivacyPolicy,
            ),
            ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: const Text('Tip the developer'),
              subtitle:
                  const Text('Optional support via PayPal; unlocks nothing'),
              onTap: _openTipPage,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_done_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text('Changes are saved automatically'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _placementLabel(AnnotationPlacement placement) {
    switch (placement) {
      case AnnotationPlacement.left:
        return 'Left';
      case AnnotationPlacement.right:
        return 'Right';
      case AnnotationPlacement.disabled:
        return 'Disabled';
    }
  }
}
