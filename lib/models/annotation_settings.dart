import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum AnnotationPlacement { left, right, disabled }

class AnnotationItem {
  const AnnotationItem({
    required this.id,
    required this.label,
    required this.placement,
  });

  final String id;
  final String label;
  final AnnotationPlacement placement;

  AnnotationItem copyWith({AnnotationPlacement? placement}) {
    return AnnotationItem(
      id: id,
      label: label,
      placement: placement ?? this.placement,
    );
  }
}

class AnnotationSettings {
  AnnotationSettings(this.items);

  static const _preferencesKey = 'annotation_settings';
  final List<AnnotationItem> items;

  static const defaults = <AnnotationItem>[
    AnnotationItem(
        id: 'project_name',
        label: 'Project name',
        placement: AnnotationPlacement.left),
    AnnotationItem(
        id: 'date_time',
        label: 'Date and time',
        placement: AnnotationPlacement.left),
    AnnotationItem(
        id: 'coordinates',
        label: 'GPS coordinates',
        placement: AnnotationPlacement.left),
    AnnotationItem(
        id: 'compass',
        label: 'Compass heading',
        placement: AnnotationPlacement.right),
    AnnotationItem(
        id: 'elevation',
        label: 'Elevation',
        placement: AnnotationPlacement.disabled),
    AnnotationItem(
        id: 'inspector_name',
        label: 'Inspector name',
        placement: AnnotationPlacement.disabled),
    AnnotationItem(
        id: 'custom_note',
        label: 'Custom note',
        placement: AnnotationPlacement.disabled),
    AnnotationItem(
        id: 'photo_sequence',
        label: 'Photo sequence number',
        placement: AnnotationPlacement.disabled),
  ];

  static Future<AnnotationSettings> load(SharedPreferences preferences) async {
    final savedValue = preferences.getString(_preferencesKey);
    if (savedValue == null) return AnnotationSettings(List.of(defaults));

    try {
      final decoded = jsonDecode(savedValue) as List<dynamic>;
      final savedItems = <AnnotationItem>[];
      for (final value in decoded) {
        final map = value as Map<String, dynamic>;
        final id = map['id'] as String;
        final definition = defaults.where((item) => item.id == id).firstOrNull;
        final placement = AnnotationPlacement.values
            .where((value) => value.name == map['placement'])
            .firstOrNull;
        if (definition != null && placement != null) {
          savedItems.add(definition.copyWith(placement: placement));
        }
      }
      for (final definition in defaults) {
        if (!savedItems.any((item) => item.id == definition.id)) {
          savedItems.add(definition);
        }
      }
      return AnnotationSettings(savedItems);
    } catch (_) {
      return AnnotationSettings(List.of(defaults));
    }
  }

  Future<void> save(SharedPreferences preferences) async {
    final value = items
        .map((item) => {'id': item.id, 'placement': item.placement.name})
        .toList();
    await preferences.setString(_preferencesKey, jsonEncode(value));
  }
}
