import 'dart:convert';

import 'package:antlr4/antlr4.dart';
import 'package:collection/collection.dart';

import '../core.dart';
import 'antlr/JSON5Lexer.dart';
import 'antlr/JSON5Parser.dart';
import 'type.dart';
import 'visitor.dart';

class JSONDef {
  JSONDef(this.type, this._objs);

  final JType type;
  final List<Obj> _objs;

  late final objs = List<Obj>.unmodifiable(_objs);

  bool get isObject => type is ObjectType;

  bool get isArray => type is ArrayType;

  void keepUniqueObjName({
    Map<String, String>? symbols,
  }) {
    final keys = <String, int>{};
    bool hasConflict = false;
    for (final obj in _objs) {
      final name = obj.key.naming(symbols: symbols);
      if (keys.containsKey(name)) {
        final i = keys[name]!;
        final next = i + 1;
        keys[name] = next;
        updateObjName(obj.key, '$name$next');
        hasConflict = true;
      } else {
        keys[name] = 0;
      }
    }
    if (hasConflict) {
      keepUniqueObjName(symbols: symbols);
    }
  }

  void updateObjName(ObjKey key, String? newObjName) {
    if (newObjName != null && newObjName.isEmpty) {
      newObjName = null;
    }
    key.customName = newObjName;
    for (final item in _objs) {
      for (final field in item.fields) {
        final path = field.def.path;
        if (const ListEquality().equals(path, key.path)) {
          field.def.customName = newObjName;
        }
        FieldTypeDef? child = field.def.child;
        while (child != null) {
          if (const ListEquality().equals(child.path, key.path)) {
            child.customName = newObjName;
          }
          child = child.child;
        }
      }
    }
  }

  List<Map<String, dynamic>> toJson({
    Map<String, String>? symbols,
  }) {
    return _objs.map((e) => e.toJson(symbols: symbols)).toList(growable: false);
  }

  static JSONDef fromString<T>(
    String str, {
    Map<String, String>? symbols,
  }) {
    return fromCharStream(
      InputStream.fromString(str),
      symbols: symbols,
    );
  }

  static JSONDef fromBytes<T>(
    List<int> bytes, {
    Map<String, String>? symbols,
  }) {
    return fromCharStream(InputStream(bytes), symbols: symbols);
  }

  static Future<JSONDef> fromPath<T>(
    String path, {
    Map<String, String>? symbols,
  }) async {
    final input = await InputStream.fromPath(path);
    return fromCharStream(input, symbols: symbols);
  }

  static Future<JSONDef> fromStringStream<T>(
    Stream<String> stream, {
    Map<String, String>? symbols,
  }) async {
    final input = await InputStream.fromStringStream(stream);
    return fromCharStream(input, symbols: symbols);
  }

  static Future<JSONDef> fromStream<T>(
    Stream<List<int>> stream, {
    Encoding encoding = utf8,
    Map<String, String>? symbols,
  }) async {
    final input = await InputStream.fromStream(
      stream,
      encoding: encoding,
    );
    return fromCharStream(input, symbols: symbols);
  }

  static JSONDef fromCharStream<T>(
    CharStream input, {
    Map<String, String>? symbols,
  }) {
    JSON5Lexer.checkVersion();
    JSON5Parser.checkVersion();
    final lexer = JSON5Lexer(input);
    final tokens = CommonTokenStream(lexer);
    final parser = JSON5Parser(tokens);
    parser.addErrorListener(DiagnosticErrorListener());
    parser.buildParseTree = true;
    final visitor = JVisitor();
    final type = visitor.visit(parser.json5())!;
    return JSONDef(type, visitor.objs)..keepUniqueObjName(symbols: symbols);
  }
}
