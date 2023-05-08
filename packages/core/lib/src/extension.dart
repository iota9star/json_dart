import 'package:antlr4/antlr4.dart';
import 'package:recase/recase.dart';

import 'antlr/JSON5Parser.dart';

extension StringExtension on String {
  String get noQuot {
    if (startsWith('"') && endsWith('"')) {
      return substring(1, length - 1);
    }
    if (startsWith("'") && endsWith("'")) {
      return substring(1, length - 1);
    }
    return this;
  }

  String nullable(bool value) => value ? '$this?' : this;

  String unicodeToRawString() {
    const regex = r'\u';
    String content = this;
    int offset = content.indexOf(regex) + regex.length;
    while (offset > 1) {
      final str = content.substring(offset, offset + 4);
      if (str.isNotEmpty) {
        final uni = String.fromCharCode(int.parse(str, radix: 16));
        content = content.replaceFirst(regex + str, uni);
      }
      offset = content.indexOf(regex) + regex.length;
    }
    return content;
  }
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
        ids.add(rp.key()!.text.noQuot);
      } else if (rp is ObjectContext) {
        ids.add(OBJECT_CHAR);
      }
    }
    caches[parent] = ids;
    return ids;
  }

  int indent() {
    RuleContext? p = parent;
    int n = 0;
    while (p != null) {
      if (p is ValueContext) {
        n++;
      }
      p = p.parent;
    }
    return n;
  }
}
