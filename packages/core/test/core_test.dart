import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:json_core/core.dart';
import 'package:json_core/src/consts.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('templates', () async {
      final dir = '${Directory.current.path}/test/';
      final def = await JSONDef.fromPath('$dir/test.json');
      final objs = def.toJson(symbols: builtInSymbols);
      final tpls = [
        const MapEntry('no_final', no_final),
        const MapEntry('with_final', with_final),
        const MapEntry('json_serializable', json_serializable),
        const MapEntry('freezed', freezed),
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
