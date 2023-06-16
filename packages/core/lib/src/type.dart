import 'package:antlr4/antlr4.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../core.dart';
import 'antlr/JSON5Parser.dart';

abstract class JType<T extends RuleContext, R> {
  JType(this.ctx);

  static const ph = '@';

  final T ctx;

  String get display => ctx.text;

  late final path = ctx.getPath();

  FieldTypeDef typing({Map<String, String>? symbols});

  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  });
}

abstract class ValueType<R> extends JType<RuleContext, R> {
  ValueType(super.ctx);

  Object? get value;
}

class StringType<R> extends ValueType<R> {
  StringType(super.ctx, this.value);

  @override
  final String value;

  late final FieldTypeDef type = FieldTypeDef(def: 'String');

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  }) {
    return JType.ph;
  }

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return type;
  }
}

class NumberType<R> extends ValueType<R> {
  NumberType(super.ctx, this.value);

  @override
  final num value;

  bool get isInt => value is int;

  late final FieldTypeDef type = FieldTypeDef(def: isInt ? 'int' : 'double');

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return type;
  }

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  }) {
    return JType.ph;
  }
}

class BooleanType<R> extends ValueType<R> {
  BooleanType(super.ctx, this.value);

  @override
  final bool value;

  late final FieldTypeDef type = FieldTypeDef(def: 'bool');

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return type;
  }

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  }) {
    return JType.ph;
  }
}

class NullableType<R> extends ValueType<R> {
  NullableType(super.ctx);

  @override
  Object? get value => null;

  late final FieldTypeDef type = FieldTypeDef(def: 'null');

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return type;
  }

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  }) {
    return JType.ph;
  }
}

class ArrayType<R> extends JType<ArrayContext, R> {
  ArrayType(super.ctx, this.values);

  final List<JType<RuleContext, R>> values;

  FieldTypeDef childType({Map<String, String>? symbols}) {
    if (values.isEmpty) {
      return FieldTypeDef(def: 'dynamic', type: FieldType.dynamic);
    }
    String? type;
    List<String>? ps;
    FieldTypeDef? child;
    bool nullable = false;
    for (final value in values) {
      if (value is NullableType) {
        nullable = true;
      } else {
        final nextType =
            value.typing(symbols: symbols).naming(symbols: symbols);
        if (type != null && nextType != type) {
          return FieldTypeDef(def: 'dynamic', type: FieldType.dynamic);
        }
        type = nextType;
        if (ps == null && value is ObjectType) {
          ps = value.ctx.getPath();
        }
        if (value is ArrayType) {
          child = (value as ArrayType).childType(symbols: symbols);
        }
      }
    }
    return FieldTypeDef(
      def: type!.nullable(nullable),
      path: ps,
      child: child,
      type: child != null
          ? FieldType.array
          : ps != null
              ? FieldType.object
              : FieldType.primitive,
    );
  }

  @override
  late final String display = () {
    final left = ''.padLeft(ctx.indent() * 2);
    final sb = StringBuffer('[\n');
    final join = values.map((e) => '$left${e.display}').join(',\n');
    sb.writeln(join);
    sb.write(''.padLeft((ctx.indent() - 1) * 2));
    sb.write(']');
    return sb.toString();
  }();

  JType? _getObj(Map<String, String>? symbols) => values.firstWhereOrNull(
        (e) => e.typing(symbols: symbols).type == FieldType.object,
      );

  JType? _getArray(Map<String, String>? symbols) => values.firstWhereOrNull(
        (e) => e.typing(symbols: symbols).type == FieldType.array,
      );

  bool isPrimitive(Map<String, String>? symbols) =>
      _getObj(symbols) == null && _getArray(symbols) == null;

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  }) {
    final obj = _getObj(symbols);
    final hasObj = obj != null;
    final array = _getArray(symbols);
    final hasArray = array != null;
    if (hasObj || hasArray) {
      final String child;
      if (hasObj && hasArray) {
        final objDeser = obj
            .deser(symbols: symbols, context: context)
            .replaceAll(JType.ph, 'e');
        final arrDeser = array
            .deser(symbols: symbols, context: context)
            .replaceAll(JType.ph, 'e');
        child = 'e is Map ? $objDeser : e is List ? $arrDeser : ${JType.ph}';
      } else if (hasObj) {
        child = obj
            .deser(symbols: symbols, context: context)
            .replaceAll(JType.ph, 'e');
      } else if (hasArray) {
        child = array
            .deser(symbols: symbols, context: context)
            .replaceAll(JType.ph, 'e');
      } else {
        throw StateError('Unreachable');
      }
      final ct = childType(symbols: symbols);
      String? gt;
      if (ct.path != null) {
        final obj = context[ObjKey(ct.path!)];
        if (obj != null) {
          gt = obj.key.naming(symbols: symbols);
        }
      }
      final mapType = gt != null
          ? '<$gt>'
          : ct.type == FieldType.dynamic
              ? ''
              : '<${ct.naming(symbols: symbols)}>';
      if (nullable) {
        return '${JType.ph} is List ? ${JType.ph}.map$mapType((e) { return $child;}).toList() : null';
      }
      return '${JType.ph}.map$mapType((e) { return $child;}).toList()';
    }
    final type = typing(symbols: symbols);
    if (nullable) {
      return '${JType.ph} is List ? ${type.naming(symbols: symbols)}.from(${JType.ph}) : null';
    }
    return '${type.naming(symbols: symbols)}.from(${JType.ph})';
  }

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return FieldTypeDef(
      child: childType(symbols: symbols),
      type: FieldType.array,
    );
  }
}

@immutable
class PairType<T extends JType<RuleContext, R>, R>
    extends JType<PairContext, R> {
  PairType(super.ctx, this.key, this.value);

  final String key;
  final T value;

  bool get nullable => value is NullableType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PairType &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(value.path, other.value.path);

  @override
  int get hashCode => const ListEquality().hash(value.path);

  @override
  late final String display = '"$key": ${value.display}';

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  }) {
    return value.deser(nullable: nullable, symbols: symbols, context: context);
  }

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return value.typing(symbols: symbols);
  }
}

class ObjectType<R> extends JType<ObjectContext, R> {
  ObjectType(super.ctx, this.pairs);

  final List<PairType<JType<RuleContext, R>, R>> pairs;

  late final key = ObjKey(path);

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
    required Map<ObjKey, Obj> context,
  }) {
    final obj = context[key]!;
    final naming = obj.key.naming(symbols: symbols);
    if (nullable) {
      return '${JType.ph} == null ? null : $naming.fromJson(${JType.ph} as Map<String, dynamic>,)';
    }
    return '$naming.fromJson(${JType.ph} as Map<String, dynamic>,)';
  }

  @override
  late final String display = () {
    final left = ''.padLeft(ctx.indent() * 2);
    final sb = StringBuffer('{\n');
    final join = pairs.map((e) => '$left${e.display}').join(',\n');
    sb.writeln(join);
    sb.write(''.padLeft((ctx.indent() - 1) * 2));
    sb.write('}');
    return sb.toString();
  }();

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return FieldTypeDef(
      def: path.toPascalCase(symbols: symbols),
      path: path,
      type: FieldType.object,
    );
  }
}

class FieldTypeDef {
  FieldTypeDef({
    this.def,
    this.child,
    this.path,
    this.type = FieldType.primitive,
  });

  final String? def;
  final FieldTypeDef? child;
  final List<String>? path;
  final FieldType type;

  String? customName;

  String naming({Map<String, String>? symbols}) {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    return name(symbols: symbols);
  }

  String name({Map<String, String>? symbols}) {
    if (path != null) {
      return path!.toPascalCase(symbols: symbols);
    }
    if (type == FieldType.array) {
      return 'List<${child?.naming(symbols: symbols)}>';
    }
    return def!;
  }
}

enum FieldType {
  object,
  primitive,
  array,
  dynamic,
  ;
}
