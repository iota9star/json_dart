import 'dart:convert';

import 'package:antlr4/antlr4.dart';
import 'package:collection/collection.dart';

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

  void updateObjName(Obj obj, String? newObjName) {
    final key = obj.key;
    key.customName = newObjName;
    for (final item in _objs) {
      for (final field in item.fields) {
        final path = field.def.path;
        if (const ListEquality().equals(path, key.path)) {
          field.def.customName = newObjName;
        }
      }
    }
  }

  List<Map<String, dynamic>> toMaps() {
    return _objs.map((e) => e.toJson()).toList(growable: false);
  }

  static JSONDef fromString<T>(String str) {
    return fromCharStream(InputStream.fromString(str));
  }

  static JSONDef fromBytes<T>(List<int> bytes) {
    return fromCharStream(InputStream(bytes));
  }

  static Future<JSONDef> fromPath<T>(String path) async {
    final input = await InputStream.fromPath(path);
    return fromCharStream(input);
  }

  static Future<JSONDef> fromStringStream<T>(
    Stream<String> stream,
  ) async {
    final input = await InputStream.fromStringStream(stream);
    return fromCharStream(input);
  }

  static Future<JSONDef> fromStream<T>(
    Stream<List<int>> stream, {
    Encoding encoding = utf8,
  }) async {
    final input = await InputStream.fromStream(
      stream,
      encoding: encoding,
    );
    return fromCharStream(input);
  }

  static JSONDef fromCharStream<T>(
    CharStream input,
  ) {
    JSON5Lexer.checkVersion();
    JSON5Parser.checkVersion();
    final lexer = JSON5Lexer(input);
    final tokens = CommonTokenStream(lexer);
    final parser = JSON5Parser(tokens);
    parser.addErrorListener(DiagnosticErrorListener());
    parser.buildParseTree = true;
    final visitor = JVisitor();
    final type = visitor.visit(parser.json5())!;
    return JSONDef(type, visitor.objs);
  }
}
