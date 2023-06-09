import 'dart:io';

import 'package:json_core/core.dart';

class JsonOption {
  JsonOption({
    this.templatePath,
    this.useTemplate,
    this.useDartFormat,
  });

  factory JsonOption.fromJson(Map json) {
    return JsonOption(
      templatePath: json['template_path'],
      useTemplate: json['use_template'],
      useDartFormat: json['use_dart_format'],
    );
  }

  final String? templatePath;
  final String? useTemplate;
  final bool? useDartFormat;

  late final useBuiltIn = templatePath != null;

  late final template = () {
    final String template;
    if (templatePath != null) {
      final file = File(templatePath!);
      if (!file.existsSync()) {
        throw ArgumentError('Template file not found: $templatePath');
      }
      template = file.readAsStringSync();
    } else {
      final tpl = useTemplate ?? 'with_final';
      switch (tpl) {
        case 'with_final':
          template = withFinal;
          break;
        case 'no_final':
          template = noFinal;
          break;
        case 'json_serializable':
          template = jsonSerializable;
          break;
        case 'freezed':
          template = freezed;
          break;
        default:
          throw StateError('Unreachable...');
      }
    }
    return template;
  }();
}
