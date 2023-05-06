const no_final =
// language=handlebars
'''
{{# defs }}
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}();

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map json) {
{{# obj_fields }}
{{# field_is_complex }}
    final {{# @camel_case }}{{ field_key }}{{/ @camel_case }} = json['{{ field_key }}'];
{{/ field_is_complex }}
{{/ obj_fields }}
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}()
{{# obj_fields }}
      ..{{# @camel_case }}{{ field_key }}{{/ @camel_case }} = {{# field_is_complex }}{{# @deser_field }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }}{{/ @deser_field }}{{/ field_is_complex }}{{^ field_is_complex }}json['{{ field_key }}']{{/ field_is_complex }}
{{/ obj_fields }};
  }

{{# obj_fields }}
  {{# field_is_dynamic }}dynamic {{# @camel_case }}{{ field_key }}{{/ @camel_case }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{^ field_nullable }}late {{/ field_nullable }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @camel_case }}{{ field_key }}{{/ @camel_case }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() {
    return {
     {{# obj_fields }}
      '{{ field_key }}': {{# @camel_case }}{{ field_key }}{{/ @camel_case }},
     {{/ obj_fields }}
    };
  }

  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_name }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @camel_case }}{{ field_key }}{{/ @camel_case }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}()
{{# obj_fields }}
      ..{{# @camel_case }}{{ field_key }}{{/ @camel_case }} = {{# @camel_case }}{{ field_key }}{{/ @camel_case }} ?? this.{{# @camel_case }}{{ field_key }}{{/ @camel_case }}
{{/ obj_fields }};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @camel_case }}{{ field_key }}{{/ @camel_case }}, other.{{# @camel_case }}{{ field_key }}{{/ @camel_case }}){{/ field_is_array }}{{^ field_is_array }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }} == other.{{# @camel_case }}{{ field_key }}{{/ @camel_case }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @camel_case }}{{ field_key }}{{/ @camel_case }}){{/ field_is_array }}{{^ field_is_array }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }}.hashCode{{/ field_is_array }},
{{/ obj_fields }}
      ]);

}

{{/ defs }}
      ''';

const with_final =
// language=handlebars
'''
{{# defs }}
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}({
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @camel_case }}{{ field_key }}{{/ @camel_case }},
{{/ obj_fields }}
  });

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map json) {
{{# obj_fields }}
{{# field_is_complex }}
    final {{# @camel_case }}{{ field_key }}{{/ @camel_case }} = json['{{ field_key }}'];
{{/ field_is_complex }}
{{/ obj_fields }}
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @camel_case }}{{ field_key }}{{/ @camel_case }}: {{# field_is_complex }}{{# @deser_field }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }}{{/ @deser_field }}{{/ field_is_complex }}{{^ field_is_complex }}json['{{ field_key }}']{{/ field_is_complex }},
{{/ obj_fields }}
      );
  }

{{# obj_fields }}
  final {{# field_is_dynamic }}dynamic {{# @camel_case }}{{ field_key }}{{/ @camel_case }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @camel_case }}{{ field_key }}{{/ @camel_case }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() {
    return {
     {{# obj_fields }}
      '{{ field_key }}': {{# @camel_case }}{{ field_key }}{{/ @camel_case }},
     {{/ obj_fields }}
    };
  }

  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_name }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @camel_case }}{{ field_key }}{{/ @camel_case }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @camel_case }}{{ field_key }}{{/ @camel_case }}: {{# @camel_case }}{{ field_key }}{{/ @camel_case }} ?? this.{{# @camel_case }}{{ field_key }}{{/ @camel_case }},
{{/ obj_fields }}
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @camel_case }}{{ field_key }}{{/ @camel_case }}, other.{{# @camel_case }}{{ field_key }}{{/ @camel_case }}){{/ field_is_array }}{{^ field_is_array }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }} == other.{{# @camel_case }}{{ field_key }}{{/ @camel_case }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @camel_case }}{{ field_key }}{{/ @camel_case }}){{/ field_is_array }}{{^ field_is_array }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }}.hashCode{{/ field_is_array }},
{{/ obj_fields }}
      ]);

}

{{/ defs }}
      ''';


const json_serializable =
// language=handlebars
r'''
{{# defs }}
@JsonSerializable()
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}({
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}this.{{# @camel_case }}{{ field_key }}{{/ @camel_case }},
{{/ obj_fields }}
  });

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map<String, dynamic> json) => _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}FromJson(json);

{{# obj_fields }}
  final {{# field_is_dynamic }}dynamic {{# @camel_case }}{{ field_key }}{{/ @camel_case }};{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @camel_case }}{{ field_key }}{{/ @camel_case }};{{/ field_is_dynamic }}
{{/ obj_fields }}

  Map<String, dynamic> toJson() => _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}ToJson(this);

  {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} copyWith({
{{# obj_fields }}
    {{& field_type_name }}{{^ field_is_dynamic }}?{{/ field_is_dynamic }} {{# @camel_case }}{{ field_key }}{{/ @camel_case }},
{{/ obj_fields }}
  }) {
    return {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}(
{{# obj_fields }}
      {{# @camel_case }}{{ field_key }}{{/ @camel_case }}: {{# @camel_case }}{{ field_key }}{{/ @camel_case }} ?? this.{{# @camel_case }}{{ field_key }}{{/ @camel_case }},
{{/ obj_fields }}
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} &&
          runtimeType == other.runtimeType &&
{{# obj_fields }}
          {{# field_is_array }}const DeepCollectionEquality().equals({{# @camel_case }}{{ field_key }}{{/ @camel_case }}, other.{{# @camel_case }}{{ field_key }}{{/ @camel_case }}){{/ field_is_array }}{{^ field_is_array }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }} == other.{{# @camel_case }}{{ field_key }}{{/ @camel_case }}{{/ field_is_array }}{{^ field_is_last }} &&{{/ field_is_last }}
{{/ obj_fields }};

  @override
  int get hashCode => Object.hashAll([
{{# obj_fields }}
        {{# field_is_array }}const DeepCollectionEquality().hash({{# @camel_case }}{{ field_key }}{{/ @camel_case }}){{/ field_is_array }}{{^ field_is_array }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }}.hashCode{{/ field_is_array }},
{{/ obj_fields }}
      ]);

}

{{/ defs }}
      ''';

const freezed =
// language=handlebars
r'''
{{# defs }}
@freezed
class {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} with _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }} {
  const factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}({
{{# obj_fields }}
    {{^ field_nullable }}required {{/ field_nullable }}{{# field_is_dynamic }}dynamic {{# @camel_case }}{{ field_key }}{{/ @camel_case }},{{/ field_is_dynamic }}{{^ field_is_dynamic }}{{& field_type_name }}{{# field_nullable }}?{{/ field_nullable }} {{# @camel_case }}{{ field_key }}{{/ @camel_case }},{{/ field_is_dynamic }}
{{/ obj_fields }}
  }) = _{{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }};

  factory {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}.fromJson(Map<String, Object?> json)
      => _${{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}FromJson(json);
}

{{/ defs }}
      ''';
