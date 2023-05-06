import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:json_core/core.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('templates', () async {
      final dir = '${Directory.current.path}/test/';
      final def = await JSON.fromPath('$dir/test.json');
      final defs = def.defs.map((e) => e.toJson()).toList(growable: false);
      final tpls = [
        const MapEntry('no_final', no_final),
        const MapEntry('with_final', with_final),
        const MapEntry('json_serializable', json_serializable),
        const MapEntry('freezed', freezed),
      ];
      for (final tpl in tpls) {
        final rendered = renderDefs(tpl.value, defs);
        File('$dir/${tpl.key}.dart').writeAsStringSync(rendered);
        final format = DartFormatter(fixes: StyleFix.all).format(rendered);
        File('$dir/${tpl.key}.dart').writeAsStringSync(format);
      }
    });
  });
}
