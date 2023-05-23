const no_final =
// language=handlebars
    '''
{{# objs }}
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}();

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map json) {
{{# obj_fields }}
{{# field_is_complex }}
    final {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} = json['{{ field_key }}'];
{{/ field_is_complex }}
{{/ obj_fields }}
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}()
{{# obj_fields }}
      ..{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}= {{# field_is_complex }}{{# @deser_field }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ @deser_field }}{{/ field_is_complex }}{{^ field_is_complex }}json['{{ field_key }}']{{/ field_is_complex }}
{{/ obj_fields }};
  }

{{# obj_fields }}
  {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{^ field_nullable }}late {{/ field_nullable }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() {
    return {
     {{# obj_fields }}
      '{{ field_key }}': {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
     {{/ obj_fields }}
    };
  }

  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_name }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}()
{{# obj_fields }}
      ..{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} = {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}
{{/ obj_fields }};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}.hashCode{{/ field_is_array }},
{{/ obj_fields }}
      ]);

}

{{/ objs }}
      ''';

const with_final =
// language=handlebars
    '''
{{# objs }}
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}({
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  });

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map json) {
{{# obj_fields }}
{{# field_is_complex }}
    final {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} = json['{{ field_key }}'];
{{/ field_is_complex }}
{{/ obj_fields }}
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# field_is_complex }}{{# @deser_field }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ @deser_field }}{{/ field_is_complex }}{{^ field_is_complex }}json['{{ field_key }}']{{/ field_is_complex }},
{{/ obj_fields }}
      );
  }

{{# obj_fields }}
  final {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() {
    return {
     {{# obj_fields }}
      '{{ field_key }}': {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
     {{/ obj_fields }}
    };
  }

  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_name }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}.hashCode{{/ field_is_array }},
{{/ obj_fields }}
      ]);

}

{{/ objs }}
      ''';

const json_serializable =
// language=handlebars
    r'''
{{# objs }}
@JsonSerializable()
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}({
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  });

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map<String, dynamic> json) => _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}FromJson(json);

{{# obj_fields }}
  @JsonKey(name: '{{ field_key }}')
  final {{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() => _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}ToJson(this);

  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_name }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}: {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} ?? this.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},
{{/ obj_fields }}
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}, other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }} == other.{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}){{/ field_is_array }}{{^ field_is_array }}{{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }}.hashCode{{/ field_is_array }},
{{/ obj_fields }}
      ]);

}

{{/ objs }}
      ''';

const freezed =
// language=handlebars
    r'''
{{# objs }}
@freezed
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} with _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  const factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}({
{{# obj_fields }}
  @JsonKey(name: '{{ field_key }}') {{^ field_nullable }}required {{/ field_nullable }}{{# field_is_dynamic }}dynamic {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @keywords }}{{# @camel_case }}{{ field_without_symbol_key }}{{/ @camel_case }}{{/ @keywords }},{{/ field_is_dynamic }}
{{/ obj_fields }}
  }) = _{{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }};

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map<String, Object?> json)
      => _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}FromJson(json);
}

{{/ objs }}
      ''';
