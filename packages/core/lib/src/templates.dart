const noFinal =
// language=handlebars
    '''
{{# objs }}
class {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} {

    {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}({{# obj_has_fields }}{ {{/ obj_has_fields }}
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  {{# obj_has_fields }} }{{/ obj_has_fields }});

  factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.fromJson(Map json) {
{{# obj_fields }}
{{# field_is_complex }}
    final {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} = json['{{ field_key }}'];
{{/ field_is_complex }}
{{/ obj_fields }}
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# field_is_complex }}{{# @deser_field }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ @deser_field }}{{/ field_is_complex }}{{^ field_is_complex }}json['{{ field_key }}']{{/ field_is_complex }},
{{/ obj_fields }}
      );
  }

{{# obj_fields }}
  {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{^ field_nullable }}late {{/ field_nullable }}{{& field_type_naming }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() {
    return {
     {{# obj_fields }}
      '{{ field_key }}': {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
     {{/ obj_fields }}
    };
  }
{{# obj_has_fields }}
  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_naming }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}
{{/ obj_fields }});
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};
  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }},
{{/ obj_fields }}
      ]);
{{/ obj_has_fields }}
}

{{/ objs }}
      ''';

const withFinal =
// language=handlebars
    '''
{{# objs }}
class {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}({{# obj_has_fields }}{ {{/ obj_has_fields }}
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
{{# obj_has_fields }}  }{{/ obj_has_fields }});

  factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.fromJson(Map json) {
{{# obj_fields }}
{{# field_is_complex }}
    final {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} = json['{{ field_key }}'];
{{/ field_is_complex }}
{{/ obj_fields }}
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# field_is_complex }}{{# @deser_field }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ @deser_field }}{{/ field_is_complex }}{{^ field_is_complex }}json['{{ field_key }}']{{/ field_is_complex }},
{{/ obj_fields }}
      );
  }

{{# obj_fields }}
  final {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_naming }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() {
    return {
     {{# obj_fields }}
      '{{ field_key }}': {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
     {{/ obj_fields }}
    };
  }
{{# obj_has_fields }}
  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_naming }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }},
{{/ obj_fields }}
      ]);
{{/ obj_has_fields }}
}

{{/ objs }}
      ''';

const jsonSerializable =
// language=handlebars
    r'''
{{# objs }}
@JsonSerializable()
class {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}({{# obj_has_fields }}{ {{/ obj_has_fields }}
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
{{# obj_has_fields }}  }{{/ obj_has_fields }});

  factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.fromJson(Map<String, dynamic> json) => _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}FromJson(json);

{{# obj_fields }}
  @JsonKey(name: '{{ field_key }}')
  final {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_naming }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() => _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}ToJson(this);
{{# obj_has_fields }}
  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_naming }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }},
{{/ obj_fields }}
      ]);
{{/ obj_has_fields }}
}

{{/ objs }}
      ''';

const freezed =
// language=handlebars
    r'''
{{# objs }}
@freezed
class {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} with _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} {

  const factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}({{# obj_has_fields }}{ {{/ obj_has_fields }}
{{# obj_fields }}
  @JsonKey(name: '{{ field_key }}') {{^ field_nullable }}required {{/ field_nullable }}{{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_naming }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},{{/ field_is_dynamic }}
{{/ obj_fields }}
{{# obj_has_fields }}  }{{/ obj_has_fields }}) = _{{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }};

  const {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}._();

  factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.fromJson(Map<String, Object?> json)
      => _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}FromJson(json);
}

{{/ objs }}
      ''';

const isar =
// language=handlebars
    r'''
{{# objs }}
{{# obj_is_first }}@collection{{/ obj_is_first }}{{^ obj_is_first }}@embedded{{/ obj_is_first }}
class {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} {

  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}();

    {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.named({{# obj_has_fields }}{ {{/ obj_has_fields }}
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
{{# obj_has_fields }}  }{{/ obj_has_fields }});

  factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.fromJson(Map json) {
{{# obj_fields }}
{{# field_is_complex }}
    final {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} = json['{{ field_key }}'];
{{/ field_is_complex }}
{{/ obj_fields }}
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.named(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# field_is_complex }}{{# @deser_field }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ @deser_field }}{{/ field_is_complex }}{{^ field_is_complex }}json['{{ field_key }}']{{/ field_is_complex }},
{{/ obj_fields }}
      );
  }

  {{# obj_is_first }}Id $id = Isar.autoIncrement;{{/ obj_is_first }}

{{# obj_fields }}
  {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{# obj_is_first }}{{^ field_nullable }}late {{/ field_nullable }}{{/ obj_is_first }}{{& field_type_naming }} {{# obj_is_first }}{{# field_nullable }}?{{/ field_nullable }}{{/ obj_is_first }}{{^ obj_is_first }}?{{/ obj_is_first }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() {
    return {
     {{# obj_fields }}
      '{{ field_key }}': {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
     {{/ obj_fields }}
    };
  }
{{# obj_has_fields }}
  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_naming }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}()
{{# obj_fields }}
      ..{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} = {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}
{{/ obj_fields }};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }},
{{/ obj_fields }}
      ]);
{{/ obj_has_fields }}
}

{{/ objs }}
      ''';

const isarWithJsonSerializable =
// language=handlebars
    r'''
{{# objs }}
@JsonSerializable(constructor: 'withoutId')
{{# obj_is_first }}@collection{{/ obj_is_first }}{{^ obj_is_first }}@embedded{{/ obj_is_first }}
class {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} {

  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}();

  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.withoutId({{# obj_has_fields }}{ {{/ obj_has_fields }}
{{# obj_fields }}
    {{# obj_is_first }}{{^ field_nullable }}required {{/ field_nullable }}{{/ obj_is_first }}this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
{{# obj_has_fields }}  }{{/ obj_has_fields }});

  factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.fromJson(Map<String, dynamic> json) => _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}FromJson(json);

  {{# obj_is_first }}Id $id = Isar.autoIncrement;{{/ obj_is_first }}

{{# obj_fields }}
  {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{# obj_is_first }}{{^ field_nullable }}late {{/ field_nullable }}{{/ obj_is_first }}{{& field_type_naming }} {{# obj_is_first }}{{# field_nullable }}?{{/ field_nullable }}{{/ obj_is_first }}{{^ obj_is_first }}?{{/ obj_is_first }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() => _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}ToJson(this);
{{# obj_has_fields }}
  {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_naming }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.withoutId(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }},
{{/ obj_fields }}
      ]);
{{/ obj_has_fields }}
}

{{/ objs }}
      ''';

const isarWithFreezed =
// language=handlebars
    r'''
{{# objs }}
@freezed
{{# obj_is_first }}@Collection(ignore: {'copyWith'}){{/ obj_is_first }}{{^ obj_is_first }}@Embedded(ignore: {'copyWith'}){{/ obj_is_first }}
class {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} with _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }} {

  const factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}({{# obj_has_fields }}{ {{/ obj_has_fields }}
  {{# obj_is_first }}@Default(Isar.autoIncrement) Id isarId,{{/ obj_is_first }}
{{# obj_fields }}
  @JsonKey(name: '{{ field_key }}') {{# obj_is_first }}{{^ field_nullable }}required {{/ field_nullable }}{{/ obj_is_first }}{{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_naming }}{{# obj_is_first }}{{# field_nullable }}?{{/ field_nullable }}{{/ obj_is_first }}{{^ obj_is_first }}?{{/ obj_is_first }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},{{/ field_is_dynamic }}
{{/ obj_fields }}
{{# obj_has_fields }}  }{{/ obj_has_fields }}) = _{{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }};

  const {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}._();

  factory {{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}.fromJson(Map<String, Object?> json)
      => _${{# @pascal_case }}{{ obj_naming }}{{/ @pascal_case }}FromJson(json);

  {{# obj_is_first }}Id get $id => isarId;{{/ obj_is_first }}
}

{{/ objs }}
      ''';
