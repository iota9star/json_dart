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

  FieldDef get type;

  String deser({bool nullable = false});
}

abstract class ValueType<R> extends JType<RuleContext, R> {
  ValueType(super.ctx);

  Object? get value;
}

class StringType<R> extends ValueType<R> {
  StringType(super.ctx, this.value);

  @override
  final String value;

  @override
  late final FieldDef type = FieldDef(name: 'String');

  @override
  String deser({bool nullable = false}) {
    return JType.ph;
  }
}

class NumberType<R> extends ValueType<R> {
  NumberType(super.ctx, this.value);

  @override
  final num value;

  bool get isInt => value is int;

  @override
  late final FieldDef type = FieldDef(name: isInt ? 'int' : 'double');

  @override
  String deser({bool nullable = false}) {
    return JType.ph;
  }
}

class BooleanType<R> extends ValueType<R> {
  BooleanType(super.ctx, this.value);

  @override
  final bool value;

  @override
  late final FieldDef type = FieldDef(name: 'bool');

  @override
  String deser({bool nullable = false}) {
    return JType.ph;
  }
}

class NullableType<R> extends ValueType<R> {
  NullableType(super.ctx);

  @override
  Object? get value => null;

  @override
  late final FieldDef type = FieldDef(name: 'null');

  @override
  String deser({bool nullable = false}) {
    return JType.ph;
  }
}

class ArrayType<R> extends JType<ArrayContext, R> {
  ArrayType(super.ctx, this.values);

  final List<JType<RuleContext, R>> values;

  late FieldDef childType = () {
    if (values.isEmpty) {
      return FieldDef(name: 'dynamic', type: FieldDefType.dynamic);
    }
    String? type;
    bool nullable = false;
    for (final value in values) {
      if (value is NullableType) {
        nullable = true;
      } else {
        final nextType = value.type.name;
        if (type != null && nextType != type) {
          return FieldDef(name: 'dynamic', type: FieldDefType.dynamic);
        }
        type = nextType;
      }
    }
    return FieldDef(name: type!.nullable(nullable));
  }();

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

  late final obj =
      values.firstWhereOrNull((e) => e.type.type == FieldDefType.object);
  late final hasObj = obj != null;
  late final array =
      values.firstWhereOrNull((e) => e.type.type == FieldDefType.array);
  late final hasArray = array != null;

  late final isPrimitive = !hasObj && !hasArray;

  @override
  late final FieldDef type = FieldDef(
    name: 'List<${childType.name}>',
    type: FieldDefType.array,
  );

  @override
  String deser({bool nullable = false}) {
    if (hasObj || hasArray) {
      final String child;
      if (hasObj && hasArray) {
        final objDeser = obj!.deser().replaceAll(JType.ph, 'e');
        final arrDeser = array!.deser().replaceAll(JType.ph, 'e');
        child = 'e is Map ? $objDeser : e is List ? $arrDeser : ${JType.ph}';
      } else if (hasObj) {
        child = obj!.deser().replaceAll(JType.ph, 'e');
      } else if (hasArray) {
        child = array!.deser().replaceAll(JType.ph, 'e');
      } else {
        throw StateError('Unreachable');
      }
      final mapType =
          childType.type == FieldDefType.dynamic ? '' : '<${childType.name}>';
      if (nullable) {
        return '${JType.ph} is List ? ${JType.ph}.map$mapType((e) { return $child;}).toList() : null';
      }
      return '${JType.ph}.map$mapType((e) { return $child;}).toList()';
    }
    if (nullable) {
      return '${JType.ph} is List ? ${type.name}.from(${JType.ph}) : null';
    }
    return '${type.name}.from(${JType.ph})';
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
  FieldDef get type => value.type;

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
  String deser({bool nullable = false}) {
    return value.deser(nullable: nullable);
  }
}

class ObjectType<R> extends JType<ObjectContext, R> {
  ObjectType(super.ctx, this.pairs);

  final List<PairType<JType<RuleContext, R>, R>> pairs;

  late final fields =
      pairs.map((e) => MapEntry(e.key, e.type)).toList(growable: false);

  @override
  late final FieldDef type = () {
    final path = ctx.getPath();
    return FieldDef(
      name: path.toPascalCase(),
      path: path,
      type: FieldDefType.object,
    );
  }();

  @override
  String deser({bool nullable = false}) {
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
}

class FieldDef {
  FieldDef({
    required this.name,
    this.path,
    this.type = FieldDefType.primitive,
  });

  final String name;
  final List<String>? path;
  final FieldDefType type;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type.name,
    };
  }
}

enum FieldDefType {
  object,
  primitive,
  array,
  dynamic,
  ;
}
