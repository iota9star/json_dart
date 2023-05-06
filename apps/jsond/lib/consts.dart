const defaultJson =
// language=json
    '''
{
  "hint": "Please enter your JSON in this field."
}
''';

const testJson =
// language=json
    '''
{
  "data": {
    "suggestions": {
      "nodes": [
        {
          "type": "Repository",
          "databaseId": 636128167,
          "name": "iota9star/json_dart",
          "path": "/iota9star/json_dart"
        }
      ]
    }
  }
}
''';

const defaultTemplate =
// language=handlebars
    '''
{{# defs }}
  {{# obj_fields }}
    // {{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}
  {{/ obj_fields }}
{{/ defs }}
    ''';
