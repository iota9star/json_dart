import 'dart:convert';

import 'package:antlr4/antlr4.dart';

import 'antlr/JSON5Lexer.dart';
import 'antlr/JSON5Parser.dart';
import 'type.dart';
import 'visitor.dart';

class JSON {
  const JSON._();

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
    return JSONDef(type, visitor.defs);
  }
}

class JSONDef {
  JSONDef(this.type, this.defs);

  final JType type;
  final List<Def> defs;
}
