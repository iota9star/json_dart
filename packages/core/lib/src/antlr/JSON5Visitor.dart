// Generated from JSON5.g4 by ANTLR 4.12.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'JSON5Parser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [JSON5Parser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class JSON5Visitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [JSON5Parser.json5].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitJson5(Json5Context ctx);

  /// Visit a parse tree produced by [JSON5Parser.object].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitObject(ObjectContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.pair].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPair(PairContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.key].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitKey(KeyContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.value].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitValue(ValueContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.array].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitArray(ArrayContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.string].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitString(StringContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.bool].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBool(BoolContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.null].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNull(NullContext ctx);

  /// Visit a parse tree produced by [JSON5Parser.number].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumber(NumberContext ctx);
}