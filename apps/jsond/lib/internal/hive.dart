import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

class Hives {
  const Hives._();

  static late final Box _settingBox;
  static late final Box<Template> _templateBox;

  static Box get settingBox => _settingBox;

  static Box<Template> get templateBox => _templateBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TemplateAdapter());
    _settingBox = await Hive.openBox('settings');
    _templateBox = await Hive.openBox<Template>('templates');
  }
}
