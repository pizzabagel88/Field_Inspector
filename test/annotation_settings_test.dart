import 'dart:convert';

import 'package:field_inspector/models/annotation_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('new settings include eight items with optional items disabled',
      () async {
    final preferences = await SharedPreferences.getInstance();
    final settings = await AnnotationSettings.load(preferences);

    expect(settings.items, hasLength(8));
    expect(
      settings.items.skip(4).every(
            (item) => item.placement == AnnotationPlacement.disabled,
          ),
      isTrue,
    );
  });

  test('placement and order survive a save and reload', () async {
    final preferences = await SharedPreferences.getInstance();
    final settings = await AnnotationSettings.load(preferences);
    final moved = settings.items.removeLast().copyWith(
          placement: AnnotationPlacement.right,
        );
    settings.items.insert(0, moved);
    await settings.save(preferences);

    final reloaded = await AnnotationSettings.load(preferences);
    expect(reloaded.items.first.id, 'photo_sequence');
    expect(reloaded.items.first.placement, AnnotationPlacement.right);
  });

  test('older saved layouts gain new disabled items', () async {
    SharedPreferences.setMockInitialValues({
      'annotation_settings': jsonEncode([
        {'id': 'compass', 'placement': 'left'},
        {'id': 'project_name', 'placement': 'disabled'},
      ]),
    });
    final preferences = await SharedPreferences.getInstance();

    final settings = await AnnotationSettings.load(preferences);
    expect(settings.items, hasLength(8));
    expect(settings.items.first.id, 'compass');
    expect(settings.items.first.placement, AnnotationPlacement.left);
    expect(
      settings.items.firstWhere((item) => item.id == 'elevation').placement,
      AnnotationPlacement.disabled,
    );
  });
}
