import 'package:json_core/core.dart';

void main() {
  final code = render(
    // language=json
    '''
{
  "a": 1,
  "b": "string",
  "c": false,
  "d": 2.2,
  "e": null,
  "f": {
    "a": 1,
    "b": "string",
    "c": false,
    "d": 2.2,
    "e": null
  }
}
  ''',
    noFinal,
    dartFormat: true,
  );
  '\n$code'.$debug();
}
