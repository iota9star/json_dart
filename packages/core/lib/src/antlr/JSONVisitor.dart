// Generated from JSON.g4 by ANTLR 4.12.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'JSONParser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [JSONParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class JSONVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [JSONParser.json].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitJson(JsonContext ctx);

  /// Visit a parse tree produced by [JSONParser.object].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitObject(ObjectContext ctx);

  /// Visit a parse tree produced by [JSONParser.pair].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPair(PairContext ctx);

  /// Visit a parse tree produced by [JSONParser.array].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitArray(ArrayContext ctx);

  /// Visit a parse tree produced by [JSONParser.value].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitValue(ValueContext ctx);

  /// Visit a parse tree produced by [JSONParser.string].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitString(StringContext ctx);

  /// Visit a parse tree produced by [JSONParser.number].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumber(NumberContext ctx);

  /// Visit a parse tree produced by [JSONParser.bool].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBool(BoolContext ctx);

  /// Visit a parse tree produced by [JSONParser.null].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNull(NullContext ctx);
}