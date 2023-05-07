import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:json_core/core.dart';

import 'option.dart';

Future<void> cli(List<String> arguments) async {
  final watch = Stopwatch()..start();
  final parser = ArgParser();
  parser.addOption(
    'path',
    abbr: 'p',
    help: 'Specify the path of the `.json` file.',
  );
  parser.addOption(
    'dir',
    abbr: 'd',
    help: 'Specify the directory where the `.json` files are located.',
  );
  parser.addFlag(
    'dart-format',
    abbr: 'f',
    negatable: false,
    help: 'Should dart-format be used?',
  );
  parser.addFlag(
    'recursive',
    abbr: 'r',
    negatable: false,
    help:
        'Determine whether to search for `.json` files recursively. This option only works when specifying a directory.',
  );
  parser.addOption(
    'template',
    abbr: 't',
    defaultsTo: 'with_final',
    allowed: ['with_final', 'no_final', 'json_serializable', 'freezed'],
    help: 'Which built-in template to use?',
  );
  parser.addOption(
    'external-template',
    abbr: 'e',
    help: 'Pass an external custom template file path.',
  );
  parser.addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'View help options.',
  );
  final parse = parser.parse(arguments);
  if (parse['help'] == true) {
    // ignore: avoid_print
    print(parser.usage);
    return;
  }
  final path = parse['path'];
  final dir = parse['dir'];
  if (path == null && dir == null) {
    'Please specify at least one argument: `-path` or `-dir`.'.$warn(tag: '🚨');
    return;
  }
  final option = JsonOption(
    templatePath: parse['external-template'],
    useTemplate: parse['template'],
    useDartFormat: parse['dart-format'] ?? false,
  );
  if (path != null) {
    _writeCode(File(path), option);
  }
  if (dir != null) {
    Directory(dir).listSync(recursive: parse['recursive']).forEach((f) {
      if (f is File) {
        _writeCode(f, option);
      }
    });
  }
  'took ${watch.elapsed}.'.$info(tag: '  completed');
}

void _writeCode(File f, JsonOption option) {
  final filePath = f.path;
  if (filePath.endsWith('.json')) {
    final contents = f.readAsStringSync();
    filePath.$debug(tag: '.json found');
    final code = render(
      contents,
      option.template,
      dartFormat: (option.useDartFormat ?? false) || option.useBuiltIn,
    );
    final newPath = filePath.replaceAll(RegExp(r'.json$'), '.json.dart');
    File(newPath).writeAsStringSync(code);
    newPath.$debug(tag: '  generated');
  }
}
