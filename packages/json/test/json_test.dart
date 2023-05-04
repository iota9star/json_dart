import 'package:json/cli.dart';

void main() {
  cli(['-h']);
  cli(['-d', '../core/test', '-r']);
  cli(['-p', '../core/test/test.json', '-t', 'no_final']);
  cli(['-p', '../core/test/test.json', '-e', '../core/test/test.mustache']);
}
