import 'dart:convert';

import 'package:antlr4/antlr4.dart';

import 'antlr/JSONLexer.dart';
import 'antlr/JSONParser.dart';
import 'visitor.dart';

class JsonDefs {
  const JsonDefs._();

  static List<Def> fromString<T>(String str) {
    return fromCharStream(InputStream.fromString(str));
  }

  static List<Def> fromBytes<T>(List<int> bytes) {
    return fromCharStream(InputStream(bytes));
  }

  static Future<List<Def>> fromPath<T>(String path) async {
    final input = await InputStream.fromPath(path);
    return fromCharStream(input);
  }

  static Future<List<Def>> fromStringStream<T>(
    Stream<String> stream,
  ) async {
    final input = await InputStream.fromStringStream(stream);
    return fromCharStream(input);
  }

  static Future<List<Def>> fromStream<T>(
    Stream<List<int>> stream, {
    Encoding encoding = utf8,
  }) async {
    final input = await InputStream.fromStream(
      stream,
      encoding: encoding,
    );
    return fromCharStream(input);
  }

  static List<Def> fromCharStream<T>(
    CharStream input,
  ) {
    JSONLexer.checkVersion();
    JSONParser.checkVersion();
    final lexer = JSONLexer(input);
    final tokens = CommonTokenStream(lexer);
    final parser = JSONParser(tokens);
    parser.addErrorListener(DiagnosticErrorListener());
    parser.buildParseTree = true;
    final visitor = JVisitor();
    visitor.visit(parser.json())!;
    return visitor.defs;
  }
}
