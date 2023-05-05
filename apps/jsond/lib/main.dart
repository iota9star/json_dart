import 'dart:convert';
import 'dart:ui';

import 'package:code_text_field/code_text_field.dart';
import 'package:collection/collection.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/tomorrow-night.dart';
import 'package:flutter_highlight/themes/tomorrow.dart';
import 'package:highlight/languages/handlebars.dart';
import 'package:highlight/languages/json.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_core/core.dart';
import 'package:recase/recase.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'internal/hive.dart';
import 'res/fonts.gen.dart';
import 'widget/ripple_tap.dart';

part 'main.g.dart';

Map<String, TextStyle> lightCodeTheme(Color backgroundColor) {
  final map = Map<String, TextStyle>.from(tomorrowTheme);
  map['root'] = TextStyle(
    backgroundColor: backgroundColor,
    color: const Color(0xff4d4d4c),
  );
  return map;
}

Map<String, TextStyle> darkCodeTheme(Color backgroundColor) {
  final map = Map<String, TextStyle>.from(tomorrowNightTheme);
  map['root'] = TextStyle(
    backgroundColor: backgroundColor,
    color: const Color(0xffc5c8c6),
  );
  return map;
}

Map<String, TextStyle> getCodeTheme(ThemeData theme) {
  return theme.brightness == Brightness.dark
      ? darkCodeTheme(theme.colorScheme.onSecondary)
      : lightCodeTheme(theme.colorScheme.onSecondary);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      center: true,
      size: Size(800.0, 600.0),
      minimumSize: Size(800.0, 600.0),
      skipTaskbar: false,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  await Hives.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hives.settingBox.listenable(),
      builder: (context, box, child) {
        final mode = box.get('theme_mode', defaultValue: ThemeMode.system.name);
        final color = Color(
          box.get('theme_color', defaultValue: Colors.blueAccent.value),
        );
        return MaterialApp(
          title: 'JSOND',
          scrollBehavior: const ScrollBehavior().copyWith(
            scrollbars: false,
            dragDevices: PointerDeviceKind.values.toSet(),
          ),
          themeMode: ThemeMode.values.firstWhere((e) => e.name == mode),
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: color,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: color,
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
    _codeController = CodeController(language: json);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _codeController.dispose();
    super.dispose();
  }

  @override
  void onWindowResize() {
    final md = MediaQueryData.fromWindow(window);
    final value = _jsonContentWidth.value;
    if (md.size.width - value - 240.0 < 20.0) {
      _jsonContentWidth.value = md.size.width - 240.0 - 20.0;
    }
  }

  final _builtInTemplates = [
    Template(
      name: 'No Final',
      template: no_final,
      builtIn: true,
      dartFormat: true,
      id: -1,
    ),
    Template(
      name: 'With Final',
      template: with_final,
      builtIn: true,
      dartFormat: true,
      id: -2,
    ),
    Template(
      name: 'Json Serializable',
      template: json_serializable,
      builtIn: true,
      dartFormat: true,
      id: -3,
    ),
    Template(
      name: 'Freezed',
      template: freezed,
      builtIn: true,
      dartFormat: true,
      id: -4,
    ),
  ];

  final _codes = ValueNotifier<List<String>>([]);
  final _jsonContentWidth = ValueNotifier(300.0);
  late final _selected = ValueNotifier(_builtInTemplates.first);
  late CodeController _codeController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final md = MediaQuery.of(context);
    return Scaffold(
      body: Row(
        children: [
          _buildTemplatePanel(theme),
          _buildJsonPanel(theme, md),
          _buildDragBar(md),
          _buildCodePanel(theme),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final codes = _codeController.text.trim();
          if (codes.isEmpty) {
            await _showEmptyInfo(context);
            return;
          }
          final formatted = _formatJsonContent(theme, codes);
          if (!formatted) {
            return;
          }
          final dart = render(codes, _selected.value.template);
          _codes.value = dart
              .split('\n')
              .slices(500)
              .map((e) => e.join('\n'))
              .toList(growable: false);
          await Clipboard.setData(ClipboardData(text: dart));
          if (mounted) {
            _showSnackbar(
              context,
              'The generated code has been copied to the clipboard.',
            );
          }
        },
        label: const Text('Generate'),
        icon: const Icon(
          Icons.generating_tokens_outlined,
          size: 16.0,
        ),
      ),
    );
  }

  Widget _buildDragBar(MediaQueryData md) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (d) {
          final oldWidth = _jsonContentWidth.value;
          if (oldWidth <= 300.0 && d.delta.dx < 0) {
            _jsonContentWidth.value = 300.0;
            return;
          }
          final newValue = oldWidth + d.delta.dx;
          if (md.size.width - newValue - 240.0 < 20.0) {
            return;
          }
          _jsonContentWidth.value = newValue;
        },
        child: Container(
          width: 20.0,
          height: double.infinity,
          alignment: Alignment.center,
          child: const Icon(
            Icons.drag_indicator_rounded,
            size: 16.0,
          ),
        ),
      ),
    );
  }

  Future<void> _showEmptyInfo(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please enter JSON'),
        content: const Text(
          'Before we start messing around, should we get some JSON first?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            child: const Text('Dismiss'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildCodePanel(ThemeData theme) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _codes,
              builder: (context, codes, child) {
                final length = codes.length;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return HighlightView(
                      codes[index],
                      language: 'dart',
                      textStyle: const TextStyle(
                        fontFamily: FontFamily.agave,
                        height: 1.5,
                      ),
                      theme: getCodeTheme(theme),
                      padding: index == 0
                          ? const EdgeInsets.only(
                              left: 24.0,
                              right: 24.0,
                              top: 24.0,
                            )
                          : index == length - 1
                              ? const EdgeInsets.only(
                                  left: 24.0,
                                  right: 24.0,
                                  bottom: 24.0,
                                )
                              : const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                    );
                  },
                  itemCount: length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonPanel(ThemeData theme, MediaQueryData md) {
    return ValueListenableBuilder(
      valueListenable: _jsonContentWidth,
      builder: (context, width, child) {
        return SizedBox(
          width: width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SizedBox.expand(
                child: CodeTheme(
                  data: CodeThemeData(
                    styles: getCodeTheme(theme),
                  ),
                  child: CodeField(
                    controller: _codeController,
                    wrap: true,
                    textStyle: const TextStyle(
                      fontFamily: FontFamily.agave,
                      fontSize: 14.0,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: 24.0,
                end: 24.0,
                bottom: 24.0 + md.padding.bottom,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        final codes = _codeController.text.trim();
                        _formatJsonContent(theme, codes);
                      },
                      icon: const Icon(
                        Icons.format_indent_increase_rounded,
                        size: 16.0,
                      ),
                      label: const Text('format'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _codeController.text = '';
                        _codes.value = [];
                      },
                      icon: const Icon(
                        Icons.clear_all_rounded,
                        size: 16.0,
                      ),
                      label: const Text('clear'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _formatJsonContent(
    ThemeData theme,
    String codes,
  ) {
    if (codes.isEmpty) {
      return false;
    }
    try {
      final map = jsonDecode(codes);
      final converted = const JsonEncoder.withIndent('  ').convert(map);
      _codeController.text = converted;
      return true;
    } catch (e) {
      _showJsonError(theme, e);
    }
    return false;
  }

  Future<void> _showJsonError(ThemeData theme, Object e) {
    return showModalBottomSheet<void>(
      context: context,
      constraints: const BoxConstraints(maxWidth: 640.0),
      shape: const RoundedRectangleBorder(),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please check whether the JSON content is valid.',
                style: theme.textTheme.titleMedium,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(top: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.dividerColor,
                  ),
                ),
                child: Text(
                  e.toString(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: theme.colorScheme.error,
                    fontFamily: FontFamily.agave,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemplatePanel(ThemeData theme) {
    return SizedBox(
      width: 240.0,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _selected,
                builder: (context, selected, child) {
                  return CustomScrollView(
                    slivers: [
                      SliverPinnedHeader(
                        child: Container(
                          decoration: BoxDecoration(color: theme.cardColor),
                          padding: const EdgeInsetsDirectional.only(
                            start: 24.0,
                            end: 12.0,
                            bottom: 12.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Templates',
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showSettingPanel(context);
                                },
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  size: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MultiSliver(
                        pushPinnedChildren: true,
                        children: [
                          SliverPinnedHeader(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(color: theme.cardColor),
                              child: Text(
                                'Built-in',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final tpl = _builtInTemplates[index];
                                return _buildTemplateItem(
                                  context,
                                  theme,
                                  tpl,
                                  tpl == selected,
                                );
                              },
                              childCount: _builtInTemplates.length,
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: Hives.templateBox.listenable(),
                        builder: (context, box, child) {
                          final templates = box.values.toList(growable: false);
                          if (templates.isEmpty) {
                            return const SliverToBoxAdapter();
                          }
                          return MultiSliver(
                            pushPinnedChildren: true,
                            children: [
                              SliverPinnedHeader(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 8.0,
                                  ),
                                  decoration:
                                      BoxDecoration(color: theme.cardColor),
                                  child: Text(
                                    'Custom Template',
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final tpl = templates[index];
                                    return _buildTemplateItem(
                                      context,
                                      theme,
                                      tpl,
                                      tpl == selected,
                                    );
                                  },
                                  childCount: templates.length,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton.icon(
                onPressed: () => _showTemplateEditor(context),
                icon: const Icon(
                  Icons.add_rounded,
                  size: 16.0,
                ),
                label: const Text('New Template'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateItem(
    BuildContext context,
    ThemeData theme,
    Template tpl,
    bool selected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 10.0,
      ),
      child: RippleTap(
        color: selected ? theme.colorScheme.primaryContainer : theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 16.0,
            top: 4.0,
            bottom: 4.0,
            end: 4.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: tpl.name,
                  child: Text(
                    tpl.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              MenuAnchor(
                builder: (context, controller, child) {
                  return IconButton(
                    onPressed: () {
                      controller.isOpen
                          ? controller.close()
                          : controller.open();
                    },
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 16.0,
                    ),
                  );
                },
                menuChildren: [
                  MenuItemButton(
                    child: const Text('View Template'),
                    onPressed: () {
                      _showTemplateInfo(tpl);
                    },
                  ),
                  MenuItemButton(
                    child: const Text('New Template'),
                    onPressed: () {
                      final copy = tpl.copyWith(name: '${tpl.name} Copy');
                      _showTemplateEditor(context, template: copy);
                    },
                  ),
                  if (!tpl.builtIn)
                    MenuItemButton(
                      child: const Text('Edit Template'),
                      onPressed: () {
                        _showTemplateEditor(context, template: tpl);
                      },
                    ),
                  if (!tpl.builtIn)
                    MenuItemButton(
                      child: const Text('Delete Template'),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Template'),
                            content: Text(
                              'Have you decided if you want to delete this template [${tpl.name}]?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Okay'),
                                onPressed: () {
                                  tpl.delete();
                                  Navigator.of(context).pop();
                                },
                              ),
                              FilledButton(
                                child: const Text('Dismiss'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              )
            ],
          ),
        ),
        onTap: () {
          if (_selected.value != tpl) {
            _selected.value = tpl;
          }
        },
      ),
    );
  }

  Future<void> _showTemplateEditor(
    BuildContext context, {
    Template? template,
  }) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: TempEditor(template: template),
      ),
    );
    if (mounted && (success ?? false)) {
      if (template == null || template.builtIn) {
        _showSnackbar(context, 'Template added successfully.');
      } else {
        _showSnackbar(context, 'Template edited successfully.');
      }
    }
  }

  void _showTemplateInfo(Template tpl) {
    final codes = tpl.template
        .split('\n')
        .slices(500)
        .map((e) => e.join('\n'))
        .toList(growable: false);
    final length = codes.length;
    showDialog<Template>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: tpl.dartFormat
                  ? Row(
                      children: [
                        Text(tpl.name),
                        const SizedBox(width: 8.0),
                        Chip(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          side: BorderSide.none,
                          label: Text(
                            'DartFormat',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(fontSize: 10.0),
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    )
                  : Text(tpl.name),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return HighlightView(
                  codes[index],
                  language: 'handlebars',
                  textStyle: const TextStyle(
                    fontFamily: FontFamily.agave,
                    height: 1.5,
                  ),
                  theme: getCodeTheme(theme),
                  padding: index == 0
                      ? const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          top: 24.0,
                        )
                      : index == length - 1
                          ? const EdgeInsets.only(
                              left: 24.0,
                              right: 24.0,
                              bottom: 24.0,
                            )
                          : const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                );
              },
              itemCount: length,
            ),
          ),
        );
      },
    );
  }

  void _showSettingPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(maxWidth: 640.0),
      builder: (context) {
        final theme = Theme.of(context);
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.618,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    Text(
                      'Theme Mode',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    ValueListenableBuilder(
                      valueListenable:
                          Hives.settingBox.listenable(keys: ['theme_mode']),
                      builder: (context, box, child) {
                        return Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: ThemeMode.values.map(
                            (e) {
                              return ChoiceChip(
                                label: Text(e.name.pascalCase),
                                selected: e.name ==
                                    box.get(
                                      'theme_mode',
                                      defaultValue: ThemeMode.system.name,
                                    ),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    Hives.settingBox.put('theme_mode', e.name);
                                  }
                                },
                              );
                            },
                          ).toList(growable: false),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Theme Color',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    ValueListenableBuilder(
                      valueListenable:
                          Hives.settingBox.listenable(keys: ['theme_color']),
                      builder: (context, box, child) {
                        final color = Color(
                          box.get(
                            'theme_color',
                            defaultValue: Colors.blueAccent.value,
                          ),
                        );
                        return ColorPicker(
                          color: color,
                          padding: EdgeInsets.zero,
                          pickersEnabled: const <ColorPickerType, bool>{
                            ColorPickerType.both: false,
                            ColorPickerType.primary: true,
                            ColorPickerType.accent: true,
                            ColorPickerType.bw: false,
                            ColorPickerType.custom: true,
                            ColorPickerType.wheel: true,
                          },
                          pickerTypeTextStyle: theme.textTheme.labelLarge,
                          onColorChanged: (v) {
                            box.put('theme_color', v.value);
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 24.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    width: 400.0,
    content: Text(message),
    duration: duration,
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class TempEditor extends StatefulWidget {
  const TempEditor({super.key, this.template});

  final Template? template;

  @override
  State<TempEditor> createState() => _TempEditorState();
}

class _TempEditorState extends State<TempEditor> {
  late final _codeController = CodeController(
    language: handlebars,
    text: widget.template?.template ?? '',
  );
  late final _nameEC = TextEditingController(text: widget.template?.name ?? '');

  static const _shortcuts = [
    MapEntry('Defs', '{{# defs }}{{/ defs }}'),
    MapEntry(
      'PascalCaseObjName',
      '{{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}',
    ),
    MapEntry('ObjFields', '{{# obj_fields }}{{/ obj_fields }}'),
    MapEntry('Field', '{{ field_key }}'),
    MapEntry(
      'CamelCaseField',
      '{{# @camel_case }}{{ field_key }}{{/ @camel_case }}',
    ),
    MapEntry(
      'FieldIsDynamic',
      '{{# field_is_dynamic }}{{/ field_is_dynamic }}',
    ),
    MapEntry('FieldNullable', '{{# field_nullable }}{{/ field_nullable }}'),
    MapEntry(
      'FieldIsComplex',
      '{{# field_is_complex }}{{/ field_is_complex }}',
    ),
    MapEntry(
      'DeserCamelCaseField',
      '{{# @deser_field }}{{# @camel_case }}{{ field_key }}{{/ @camel_case }}{{/ @deser_field }}',
    ),
    MapEntry('@PascalCase', '{{# @pascal_case }}{{/ @pascal_case }}'),
    MapEntry('@CamelCase', '{{# @camel_case }}{{/ @camel_case }}'),
    MapEntry('@ConstantCase', '{{# @constant_case }}{{/ @constant_case }}'),
    MapEntry('@DotCase', '{{# @dot_case }}{{/ @dot_case }}'),
    MapEntry('@HeaderCase', '{{# @header_case }}{{/ @header_case }}'),
    MapEntry('@ParamCase', '{{# @param_case }}{{/ @param_case }}'),
    MapEntry('@PathCase', '{{# @path_case }}{{/ @path_case }}'),
    MapEntry('@SentenceCase', '{{# @sentence_case }}{{/ @sentence_case }}'),
    MapEntry('@TitleCase', '{{# @title_case }}{{/ @title_case }}'),
  ];

  late final _useDartFormat =
      ValueNotifier(widget.template?.dartFormat ?? false);

  @override
  void dispose() {
    _codeController.dispose();
    _nameEC.dispose();
    super.dispose();
  }

  late final isNew = widget.template == null || !widget.template!.isInBox;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: isNew ? const Text('New Template') : const Text('Edit Template'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          _buildLeftPanel(context, theme),
          _buildCodePanel(theme),
        ],
      ),
    );
  }

  Widget _buildCodePanel(ThemeData theme) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: CodeTheme(
              data: CodeThemeData(styles: getCodeTheme(theme)),
              child: CodeField(
                controller: _codeController,
                wrap: true,
                textStyle: const TextStyle(
                  fontFamily: FontFamily.agave,
                  fontSize: 14.0,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(
    BuildContext context,
    ThemeData theme,
  ) {
    return SizedBox(
      width: 280.0,
      height: double.infinity,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 24.0,
                bottom: 16.0,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameEC,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: 'Enter template name',
                      hintText: widget.template?.name,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Expanded(child: Text('Use Dart Format')),
                      ValueListenableBuilder(
                        valueListenable: _useDartFormat,
                        builder: (context, use, child) {
                          return Switch(
                            value: use,
                            onChanged: (v) {
                              _useDartFormat.value = v;
                            },
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      final name = _nameEC.text.trim();
                      if (name.isEmpty) {
                        _showSnackbar(
                          context,
                          'Please enter the template name.',
                        );
                        return;
                      }
                      if (isNew) {
                        final box = Hives.templateBox;
                        final newTpl = Template(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: name,
                          template: _codeController.text,
                          dartFormat: _useDartFormat.value,
                        );
                        box.add(newTpl);
                      } else {
                        final template = widget.template!;
                        template.template = _codeController.text;
                        template.name = _nameEC.text;
                        template.dartFormat = _useDartFormat.value;
                        template.builtIn = false;
                        template.save();
                      }
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48.0),
                    ),
                    child: const Text('Finish'),
                  ),
                ],
              ),
            ),
          ),
          SliverPinnedHeader(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                'Shortcut',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 24.0,
              ),
              child: Wrap(
                runSpacing: 8.0,
                spacing: 8.0,
                children: List.generate(_shortcuts.length, (index) {
                  final short = _shortcuts[index];
                  return ActionChip(
                    label: Text(short.key),
                    padding: EdgeInsets.zero,
                    labelStyle: theme.textTheme.labelSmall,
                    tooltip: short.value,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: short.value));
                      _showSnackbar(context, 'Copied: ${short.value}');
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@HiveType(typeId: 1)
class Template extends HiveObject {
  Template({
    required this.id,
    required this.name,
    this.builtIn = false,
    this.dartFormat = false,
    required this.template,
  });

  factory Template.fromJson(Map json) {
    return Template(
      id: json['id'],
      name: json['name'],
      template: json['template'],
      dartFormat: json['dartFormat'],
      builtIn: json['builtIn'],
    );
  }

  @HiveField(0)
  late int id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late bool builtIn;
  @HiveField(3)
  late bool dartFormat;
  @HiveField(4)
  late String template;

  Template copyWith({
    int? id,
    String? name,
    bool? builtIn,
    bool? dartFormat,
    String? template,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      template: template ?? this.template,
      builtIn: builtIn ?? this.builtIn,
      dartFormat: dartFormat ?? this.dartFormat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'builtIn': builtIn,
      'dartFormat': dartFormat,
      'template': template,
    };
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Template &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode;
}
