import 'package:antlr4/antlr4.dart';
import 'package:recase/recase.dart';

import 'antlr/JSONParser.dart';

extension StringExtension on String {
  String get noQuot => replaceAll('"', '');

  String nullable(bool value) => value ? '$this?' : this;
}

extension ListString on List<String> {
  String toPascalCase() {
    final path = this;
    if (path.isEmpty) {
      return 'Obj';
    }
    return path
        .map((e) {
          if (e == ARRAY_CHAR) {
            return 'Item';
          } else if (e == OBJECT_CHAR) {
            return 'Obj';
          }
          return e;
        })
        .join('_')
        .pascalCase;
  }
}

const ARRAY_CHAR = '🈲';
const OBJECT_CHAR = '㊙';

extension RuleContextExtension on RuleContext {
  static final caches = <RuleContext?, List<String>>{};

  List<String> getPath() {
    RuleContext? p = parent ?? RuleContext.EMPTY;
    if (caches.containsKey(p)) {
      return caches[p]!;
    }
    final ps = [];
    while (p != null) {
      ps.add(p);
      p = p.parent;
    }
    final rps = ps.reversed;
    final ids = <String>[];
    for (final rp in rps) {
      if (rp is ArrayContext) {
        ids.add(ARRAY_CHAR);
      } else if (rp is PairContext) {
        ids.add(rp.STRING()!.text!.noQuot);
      } else if (rp is ObjectContext) {
        ids.add(OBJECT_CHAR);
      }
    }
    caches[parent] = ids;
    return ids;
  }
}