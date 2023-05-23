import 'package:antlr4/antlr4.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'antlr/JSON5Parser.dart';
import 'extension.dart';

abstract class JType<T extends RuleContext, R> {
  JType(this.ctx);

  static const ph = '@';

  final T ctx;

  String get display => ctx.text;

  FieldTypeDef typing({Map<String, String>? symbols});

  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
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

  late final FieldTypeDef type = FieldTypeDef(name: 'String');

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
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

  late final FieldTypeDef type = FieldTypeDef(name: isInt ? 'int' : 'double');

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return type;
  }

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
  }) {
    return JType.ph;
  }
}

class BooleanType<R> extends ValueType<R> {
  BooleanType(super.ctx, this.value);

  @override
  final bool value;

  late final FieldTypeDef type = FieldTypeDef(name: 'bool');

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return type;
  }

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
  }) {
    return JType.ph;
  }
}

class NullableType<R> extends ValueType<R> {
  NullableType(super.ctx);

  @override
  Object? get value => null;

  late final FieldTypeDef type = FieldTypeDef(name: 'null');

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return type;
  }

  @override
  String deser({
    bool nullable = false,
    Map<String, String>? symbols,
  }) {
    return JType.ph;
  }
}

class ArrayType<R> extends JType<ArrayContext, R> {
  ArrayType(super.ctx, this.values);

  final List<JType<RuleContext, R>> values;

  FieldTypeDef childType({Map<String, String>? symbols}) {
    if (values.isEmpty) {
      return FieldTypeDef(name: 'dynamic', type: FieldType.dynamic);
    }
    String? type;
    bool nullable = false;
    for (final value in values) {
      if (value is NullableType) {
        nullable = true;
      } else {
        final nextType = value.typing(symbols: symbols).name;
        if (type != null && nextType != type) {
          return FieldTypeDef(name: 'dynamic', type: FieldType.dynamic);
        }
        type = nextType;
      }
    }
    return FieldTypeDef(name: type!.nullable(nullable));
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
  }) {
    final obj = _getObj(symbols);
    final hasObj = obj != null;
    final array = _getArray(symbols);
    final hasArray = array != null;
    if (hasObj || hasArray) {
      final String child;
      if (hasObj && hasArray) {
        final objDeser = obj.deser().replaceAll(JType.ph, 'e');
        final arrDeser = array.deser().replaceAll(JType.ph, 'e');
        child = 'e is Map ? $objDeser : e is List ? $arrDeser : ${JType.ph}';
      } else if (hasObj) {
        child = obj.deser().replaceAll(JType.ph, 'e');
      } else if (hasArray) {
        child = array.deser().replaceAll(JType.ph, 'e');
      } else {
        throw StateError('Unreachable');
      }
      final ct = childType(symbols: symbols);
      final mapType = ct.type == FieldType.dynamic ? '' : '<${ct.name}>';
      if (nullable) {
        return '${JType.ph} is List ? ${JType.ph}.map$mapType((e) { return $child;}).toList() : null';
      }
      return '${JType.ph}.map$mapType((e) { return $child;}).toList()';
    }
    final type = typing(symbols: symbols);
    if (nullable) {
      return '${JType.ph} is List ? ${type.name}.from(${JType.ph}) : null';
    }
    return '${type.name}.from(${JType.ph})';
  }

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return FieldTypeDef(
      name: 'List<${childType(symbols: symbols).name}>',
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
          value.deser() == other.value.deser();

  @override
  int get hashCode => value.deser().hashCode;

  @override
  late final String display = '"$key": ${value.display}';

  @override
  String deser({bool nullable = false, Map<String, String>? symbols}) {
    return value.deser(nullable: nullable, symbols: symbols);
  }

  @override
  FieldTypeDef typing({Map<String, String>? symbols}) {
    return value.typing(symbols: symbols);
  }
}

class ObjectType<R> extends JType<ObjectContext, R> {
  ObjectType(super.ctx, this.pairs);

  final List<PairType<JType<RuleContext, R>, R>> pairs;

  @override
  String deser({bool nullable = false, Map<String, String>? symbols}) {
    final type = typing(symbols: symbols);
    if (nullable) {
      return '${JType.ph} == null ? null : ${type.name}.fromJson(${JType.ph} as Map<String, dynamic>,)';
    }
    return '${type.name}.fromJson(${JType.ph} as Map<String, dynamic>,)';
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
    final path = ctx.getPath();
    return FieldTypeDef(
      name: path.toPascalCase(symbols: symbols),
      path: path,
      type: FieldType.object,
    );
  }
}

class FieldTypeDef {
  FieldTypeDef({
    required this.name,
    this.path,
    this.type = FieldType.primitive,
  });

  final String name;
  final List<String>? path;
  final FieldType type;

  String? customName;

  String naming({
    Map<String, String>? symbols,
  }) {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    if (path != null) {
      return path!.toPascalCase(symbols: symbols);
    }
    return name;
  }
}

enum FieldType {
  object,
  primitive,
  array,
  dynamic,
  ;
}
