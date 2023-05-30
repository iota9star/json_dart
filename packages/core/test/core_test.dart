import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:json_core/core.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('templates', () async {
      final dir = '${Directory.current.path}/test/';
      final def = await JSONDef.fromPath('$dir/github.json');
      final objs = def.toJson(symbols: builtInSymbols);
      final tpls = [
        const MapEntry('no_final', noFinal),
        const MapEntry('with_final', withFinal),
        const MapEntry('json_serializable', jsonSerializable),
        const MapEntry('freezed', freezed),
        const MapEntry('isar', isar),
        const MapEntry('isar_with_json_serializable', isarWithJsonSerializable),
        const MapEntry('isar_with_freezed', isarWithFreezed),
      ];
      for (final tpl in tpls) {
        final rendered =
            renderObjs(tpl.value, objs, keywords: builtInDartKeywords);
        File('$dir/${tpl.key}.dart').writeAsStringSync(rendered);
        final format = DartFormatter(fixes: StyleFix.all).format(rendered);
        File('$dir/${tpl.key}.dart').writeAsStringSync(format);
      }
    });
  });
}
