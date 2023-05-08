import 'dart:async';

import 'package:build/build.dart';
import 'package:json_core/core.dart';

import 'option.dart';

Builder json(BuilderOptions options) =>
    JsonBuilder(JsonOption.fromJson(options.config));

class JsonBuilder implements Builder {
  JsonBuilder(this.option);

  final JsonOption option;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final contents = await buildStep.readAsString(inputId);
    final code = render(
      contents,
      option.template,
      dartFormat: (option.useDartFormat ?? false) || option.useBuiltIn,
    );
    final json = inputId.extension.endsWith('json');
    final outputId =
        inputId.changeExtension(json ? '.json.dart' : '.json5.dart');
    await buildStep.writeAsString(outputId, code);
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      '.json': ['.json.dart'],
      '.json5': ['.json5.dart'],
    };
  }
}
