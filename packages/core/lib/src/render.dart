import 'package:dart_style/dart_style.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:recase/recase.dart';

import 'json.dart';
import 'type.dart';

String renderDefs(String template, List<Map> defs) {
  final tpl = Template(template, lenient: true);
  return tpl.renderString({
    'defs': defs,
    '@deser_field': (LambdaContext ctx) => ctx
        .lookup('field_deser')
        .toString()
        .replaceAll(JType.ph, ctx.renderString()),
    '@pascal_case': (LambdaContext ctx) => ctx.renderString().pascalCase,
    '@camel_case': (LambdaContext ctx) => ctx.renderString().camelCase,
    '@constant_case': (LambdaContext ctx) => ctx.renderString().constantCase,
    '@dot_case': (LambdaContext ctx) => ctx.renderString().dotCase,
    '@header_case': (LambdaContext ctx) => ctx.renderString().headerCase,
    '@param_case': (LambdaContext ctx) => ctx.renderString().paramCase,
    '@path_case': (LambdaContext ctx) => ctx.renderString().pathCase,
    '@sentence_case': (LambdaContext ctx) => ctx.renderString().sentenceCase,
    '@title_case': (LambdaContext ctx) => ctx.renderString().titleCase,
  });
}

String render(
  String json,
  String template, {
  bool dartFormat = false,
}) {
  final def = JSON.fromString(json);
  final code = renderDefs(
    template,
    def.defs.map((e) => e.toJson()).toList(growable: false),
  );
  if (dartFormat) {
    return DartFormatter(fixes: StyleFix.all).format(code);
  }
  return code;
}
