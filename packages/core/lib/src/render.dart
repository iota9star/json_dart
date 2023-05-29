import 'package:dart_style/dart_style.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:recase/recase.dart';

import '../core.dart';
import 'type.dart';

String renderObjs(
  String template,
  List<Map> objs, {
  Set<String>? keywords,
}) {
  final tpl = Template(template, lenient: true);
  return tpl.renderString({
    'objs': objs,
    '@deser_field': (LambdaContext ctx) => ctx
        .lookup('field_deser')
        .toString()
        .replaceAll(JType.ph, ctx.renderString()),
    '@keywords': (LambdaContext ctx) {
      final str = ctx.renderString();
      if (keywords != null && keywords.contains(str)) {
        return '${str}_';
      }
      return str;
    },
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
  Set<String> keywords = builtInDartKeywords,
  Map<String, String> symbols = builtInSymbols,
  bool dartFormat = false,
}) {
  final ret = JSONDef.fromString(json, symbols: symbols);
  final code = renderObjs(
    template,
    ret.toJson(symbols: symbols),
    keywords: keywords,
  );
  if (dartFormat) {
    return DartFormatter(fixes: StyleFix.all).format(code);
  }
  return code;
}
