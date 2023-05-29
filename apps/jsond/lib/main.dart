import 'dart:async';
import 'dart:ui';

import 'package:code_text_field/code_text_field.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
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
import 'package:url_launcher/url_launcher_string.dart';
import 'package:window_manager/window_manager.dart';

import 'consts.dart';
import 'internal/hive.dart';
import 'notifiers.dart';
import 'res/assets.gen.dart';
import 'styles.dart';
import 'widget/ripple_tap.dart';

part 'main.g.dart';

MediaQueryData get mediaQuery => MediaQueryData.fromWindow(window);

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
      valueListenable: Hives.settingBox.listenable(
        keys: [
          'theme_mode',
          'theme_color',
        ],
      ),
      builder: (context, box, child) {
        final mode = box.get('theme_mode', defaultValue: ThemeMode.system.name);
        final color = Color(
          box.get('theme_color', defaultValue: Colors.green.value),
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
    _tryNewCode();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _jsonController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void onWindowResize() {
    final value = _jsonContentWidth.value;
    if (mediaQuery.size.width - value - 240.0 < 20.0) {
      _jsonContentWidth.value = mediaQuery.size.width - 240.0 - 20.0;
    }
  }

  final _builtInTemplates = [
    Template(
      name: 'With Final',
      template: with_final,
      builtIn: true,
      dartFormat: true,
      id: -1,
    ),
    Template(
      name: 'No Final',
      template: no_final,
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
  final _jsonContentWidth = ValueNotifier(() {
    final width = mediaQuery.size.width - 240.0 - 20.0;
    if (width > 800.0) {
      return width / 2.0;
    }
    return 400.0;
  }());
  late final _selected = ValueNotifier(_builtInTemplates.first);
  late final _expanded = ValueNotifier(true);
  late final _jsonController = CodeController(
    language: json,
    text: Hives.settingBox.get('json', defaultValue: defaultJson),
  );
  final _codeDef = ValueNotifier<JSONDef?>(null);
  final _focusNode = FocusNode();
  final _objs = NewValueNotifier<Map<ObjKey, TextEditingController>>({});

  Timer? _inputTimer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          _buildTemplatePanel(theme),
          _buildJsonPanel(theme),
          _buildDragBar(),
          _buildCodePanel(theme),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: _codes.value.join('\n')));
          _showSnackbar(
            context,
            'The generated code has been copied to the clipboard.',
          );
        },
        label: const Text('Copy'),
        icon: const Icon(
          Icons.copy_all_rounded,
          size: 16.0,
        ),
      ),
    );
  }

  Widget _buildDragBar() {
    return Container(
      width: 20.0,
      height: double.infinity,
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          onHorizontalDragUpdate: (d) {
            final oldWidth = _jsonContentWidth.value;
            if (oldWidth <= 400.0 && d.delta.dx < 0) {
              _jsonContentWidth.value = 400.0;
              return;
            }
            final newValue = oldWidth + d.delta.dx;
            if (mediaQuery.size.width - newValue - 240.0 < 20.0) {
              return;
            }
            _jsonContentWidth.value = newValue;
          },
          child: const Icon(
            Icons.drag_indicator_rounded,
            size: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCodePanel(ThemeData theme) {
    return Expanded(
      child: Container(
        color: theme.colorScheme.onSecondary,
        height: double.infinity,
        child: Column(
          children: [
            _buildCustomObjectNamePanel(theme),
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
                        textStyle: codeTextStyle,
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
      ),
    );
  }

  Widget _buildCustomObjectNamePanel(ThemeData theme) {
    return ValueListenableBuilder(
      valueListenable: _objs,
      builder: (context, objs, child) {
        final list = objs.entries.toList();
        if (list.isEmpty) {
          return const SizedBox.shrink();
        }
        return ValueListenableBuilder(
          valueListenable: _expanded,
          builder: (context, value, child) {
            return Column(
              children: [
                RippleTap(
                  onTap: () {
                    _expanded.value = !_expanded.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Custom Object Name',
                            style: theme.textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AnimatedRotation(
                          turns: value ? -0.5 : 0.0,
                          duration: const Duration(milliseconds: 360),
                          child: const Icon(Icons.expand_more_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: Container(height: 0.0),
                  firstCurve: const Interval(
                    0.0,
                    0.6,
                    curve: Curves.fastOutSlowIn,
                  ),
                  secondCurve: const Interval(
                    0.4,
                    1.0,
                    curve: Curves.fastOutSlowIn,
                  ),
                  sizeCurve: Curves.fastOutSlowIn,
                  secondChild: SizedBox(
                    height: mediaQuery.size.height * 0.5,
                    child: _buildCustomNameFields(list),
                  ),
                  crossFadeState: value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 360),
                ),
                Divider(
                  height: 8.0,
                  thickness: 8.0,
                  color: theme.colorScheme.background,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCustomNameFields(
    List<MapEntry<ObjKey, TextEditingController>> list,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisExtent: 42.0,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        final entry = list[index];
        final label = entry.key.path.toPascalCase(symbols: builtInSymbols);
        return TextField(
          controller: entry.value,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            isDense: true,
            isCollapsed: true,
            labelText: label,
            contentPadding: const EdgeInsets.all(12.0),
          ),
          style: const TextStyle(fontSize: 14.0),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\d_]'))
          ],
          onChanged: (v) {
            _inputTimer?.cancel();
            _inputTimer = Timer(const Duration(milliseconds: 500), () {
              final def = _codeDef.value!;
              if (v.isEmpty) {
                def.updateObjName(entry.key, label);
              } else {
                def.updateObjName(entry.key, v);
              }
              _objs.newValue(_objs.value);
              try {
                final tpl = _selected.value;
                String code = renderObjs(
                  tpl.template,
                  def.toJson(symbols: builtInSymbols),
                  keywords: builtInDartKeywords,
                );
                if (tpl.dartFormat) {
                  code = DartFormatter(fixes: StyleFix.all).format(code);
                }
                _codes.value = code
                    .split('\n')
                    .slices(500)
                    .map((e) => e.join('\n'))
                    .toList(growable: false);
              } catch (e, s) {
                e.$error(stackTrace: s);
              }
            });
          },
        );
      },
      itemCount: list.length,
    );
  }

  Widget _buildJsonPanel(ThemeData theme) {
    return ValueListenableBuilder(
      valueListenable: _jsonContentWidth,
      builder: (context, width, child) {
        return SizedBox(
          width: width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (!_focusNode.hasFocus) {
                      _focusNode.requestFocus();
                    }
                  },
                  child: CodeTheme(
                    data: CodeThemeData(
                      styles: getCodeTheme(theme),
                    ),
                    child: CodeField(
                      controller: _jsonController,
                      focusNode: _focusNode,
                      wrap: true,
                      textStyle: codeTextStyle,
                      onChanged: (v) {
                        if (v.isEmpty) {
                          _codeDef.value = null;
                          _codes.value = [];
                          _objs.value = {};
                          return;
                        }
                        _inputTimer?.cancel();
                        _inputTimer = Timer(
                          const Duration(milliseconds: 500),
                          _tryNewCode,
                        );
                      },
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: 24.0,
                end: 24.0,
                bottom: 24.0 + mediaQuery.padding.bottom,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        final codes = _jsonController.text.trim();
                        _formatJsonContent(context, codes);
                      },
                      icon: const Icon(
                        Icons.format_indent_increase_rounded,
                        size: 16.0,
                      ),
                      label: const Text('Format'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final codes = _jsonController.text.trim();
                        _jsonController.text = codes.unicodeToRawString();
                        _tryNewCode();
                      },
                      icon: const Icon(
                        Icons.transform,
                        size: 16.0,
                      ),
                      label: const Text('Escape'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _jsonController.text = '';
                        _codes.value = [];
                        _codeDef.value = null;
                        _objs.value = {};
                      },
                      icon: const Icon(
                        Icons.clear_all_rounded,
                        size: 16.0,
                      ),
                      label: const Text('Clear'),
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

  void _tryNewCode() {
    _inputTimer?.cancel();
    try {
      final json = _jsonController.text;
      final def = JSONDef.fromString(json, symbols: builtInSymbols);
      final map = _objs.value;
      final newMap = <ObjKey, TextEditingController>{};
      for (final obj in def.objs) {
        final key = obj.key;
        if (map.containsKey(key)) {
          final old = map[key]!;
          def.updateObjName(key, old.text);
          newMap[key] = old;
        } else {
          newMap[key] =
              TextEditingController(text: key.naming(symbols: builtInSymbols));
        }
      }
      _objs.newValue(newMap);
      _codeDef.value = def;
      final tpl = _selected.value;
      String code = renderObjs(
        tpl.template,
        def.toJson(symbols: builtInSymbols),
        keywords: builtInDartKeywords,
      );
      if (tpl.dartFormat) {
        code = DartFormatter(fixes: StyleFix.all).format(code);
      }
      _codes.value = code
          .split('\n')
          .slices(500)
          .map((e) => e.join('\n'))
          .toList(growable: false);
      Hives.settingBox.put('json', def.type.display);
    } catch (e, s) {
      e.$error(stackTrace: s);
    }
  }

  bool _formatJsonContent(
    BuildContext context,
    String codes,
  ) {
    if (codes.isEmpty) {
      return false;
    }
    try {
      final def = JSONDef.fromString(codes, symbols: builtInSymbols);
      _codeDef.value = def;
      _jsonController.text = def.type.display;
      return true;
    } catch (e) {
      _showJsonError(context, e);
    }
    return false;
  }

  Widget _buildTemplatePanel(ThemeData theme) {
    final colors = theme.colorScheme;
    return SizedBox(
      width: 240.0,
      height: double.infinity,
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
                          end: 24.0,
                          bottom: 12.0,
                          top: 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Transform.translate(
                                  offset: const Offset(-12.0, 0.0),
                                  child: IconButton(
                                    onPressed: () {
                                      launchUrlString(
                                        'https://github.com/iota9star/json_dart',
                                      );
                                    },
                                    tooltip: 'Open Github',
                                    icon: Assets.github.image(width: 36.0),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    _showSettingPanel(context);
                                  },
                                  tooltip: 'Settings',
                                  icon: const Icon(
                                    Icons.settings_outlined,
                                    size: 20.0,
                                  ),
                                  style: IconButton.styleFrom(
                                    foregroundColor: colors.primary,
                                    backgroundColor: colors.surfaceVariant,
                                    disabledForegroundColor:
                                        colors.onSurface.withOpacity(0.38),
                                    disabledBackgroundColor:
                                        colors.onSurface.withOpacity(0.12),
                                    hoverColor:
                                        colors.primary.withOpacity(0.08),
                                    focusColor:
                                        colors.primary.withOpacity(0.12),
                                    highlightColor:
                                        colors.primary.withOpacity(0.12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'Templates',
                              style: theme.textTheme.titleLarge,
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
                    const SliverToBoxAdapter(child: SizedBox(height: 8.0)),
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
            _tryNewCode();
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
                  textStyle: codeTextStyle,
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
                    const SizedBox(height: 12.0),
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
                    const SizedBox(height: 12.0),
                    ValueListenableBuilder(
                      valueListenable:
                          Hives.settingBox.listenable(keys: ['theme_color']),
                      builder: (context, box, child) {
                        final color = Color(
                          box.get(
                            'theme_color',
                            defaultValue: Colors.green.value,
                          ),
                        );
                        return ColorPicker(
                          color: color,
                          padding: EdgeInsets.zero,
                          pickersEnabled: const <ColorPickerType, bool>{
                            ColorPickerType.both: true,
                            ColorPickerType.primary: false,
                            ColorPickerType.accent: false,
                            ColorPickerType.bw: false,
                            ColorPickerType.custom: true,
                            ColorPickerType.wheel: true,
                          },
                          pickerTypeTextStyle: theme.textTheme.labelLarge,
                          enableShadesSelection: false,
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

Future<void> _showJsonError(BuildContext context, Object e) {
  return showModalBottomSheet<void>(
    context: context,
    constraints: const BoxConstraints(maxWidth: 640.0),
    shape: const RoundedRectangleBorder(),
    builder: (context) {
      final theme = Theme.of(context);
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
                style: codeTextStyle.copyWith(color: theme.colorScheme.error),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _showSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(milliseconds: 1600),
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

enum EditorPanel {
  func,
  tpl,
  json,
  code,
  ;
}

class TempEditor extends StatefulWidget {
  const TempEditor({super.key, this.template});

  final Template? template;

  @override
  State<TempEditor> createState() => _TempEditorState();
}

class _TempEditorState extends State<TempEditor> {
  late final _templateController = CodeController(
    language: handlebars,
    text: widget.template?.template ?? defaultTemplate,
  );

  late final _jsonController = CodeController(
    language: json,
    text: testJson,
  );

  late final _nameEC = TextEditingController(text: widget.template?.name ?? '');

  static const _shortcuts = [
    MapEntry('Objs', '{{# objs }}{{/ objs }}'),
    MapEntry('ObjName', '{{ obj_name }}'),
    MapEntry('ObjNaming', '{{ obj_naming }}'),
    MapEntry('ObjCustomName', '{{ obj_custom_name }}'),
    MapEntry('ObjHasCustomName', '{{ obj_has_custom_name }}'),
    MapEntry('ObjIndex', '{{ obj_index }}'),
    MapEntry('ObjIsFirst', '{{# obj_is_first }}{{/ obj_is_first }}'),
    MapEntry('ObjIsLast', '{{# obj_is_last }}{{/ obj_is_last }}'),
    MapEntry('ObjFields', '{{# obj_fields }}{{/ obj_fields }}'),
    MapEntry(
      'PascalCaseObjName',
      '{{# @pascal_case }}{{ obj_name }}{{/ @pascal_case }}',
    ),
    MapEntry('ObjFieldsLength', '{{ obj_fields_length }}'),
    MapEntry('Field', '{{ field_key }}'),
    MapEntry('FieldIndex', '{{ field_index }}'),
    MapEntry('FieldIsFirst', '{{# field_is_first }}{{/ field_is_first }}'),
    MapEntry('FieldIsLast', '{{# field_is_last }}{{/ field_is_last }}'),
    MapEntry(
      'CamelCaseField',
      '{{# @camel_case }}{{ field_key }}{{/ @camel_case }}',
    ),
    MapEntry('FieldType', '{{ field_type }}'),
    MapEntry('FieldTypeName', '{{ field_type_name }}'),
    MapEntry('FieldTypeNaming', '{{ field_type_naming }}'),
    MapEntry('FieldDeser', '{{ field_deser }}'),
    MapEntry('FieldIsObject', '{{# field_is_object }}{{/ field_is_object }}'),
    MapEntry('FieldIsArray', '{{# field_is_array }}{{/ field_is_array }}'),
    MapEntry(
      'FieldIsPrimitive',
      '{{# field_is_primitive }}{{/ field_is_primitive }}',
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
  ];

  static const _helpers = [
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

  static final _objKeys = [
    'obj_path',
    'obj_name',
    'obj_naming',
    'obj_custom_name',
    'obj_fields_length',
    'obj_fields',
    'obj_index',
  ].map((e) => MapEntry(e, '{{ $e }}')).toList(growable: false);

  static final _fieldKeys = [
    'field_key',
    'field_type',
    'field_type_name',
    'field_type_naming',
    'field_type_custom_name',
    'field_index',
    'field_nullable',
    'field_deser',
  ].map((e) => MapEntry(e, '{{ $e }}')).toList(growable: false);

  late final _useDartFormat =
      ValueNotifier(widget.template?.dartFormat ?? false);
  late final _codes = ValueNotifier('');
  late final _options = NewValueNotifier(PanelOption());
  late final isNew = widget.template == null || !widget.template!.isInBox;
  final _tplFocusNode = FocusNode();
  final _jsonFocusNode = FocusNode();
  final _jsonContentWidth = ValueNotifier(() {
    final width = mediaQuery.size.width - 240.0 - 20.0;
    if (width > 800.0) {
      return width / 2.0;
    }
    return 400.0;
  }());

  @override
  void dispose() {
    _templateController.dispose();
    _jsonController.dispose();
    _nameEC.dispose();
    _tplFocusNode.dispose();
    _jsonFocusNode.dispose();
    super.dispose();
  }

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
        actions: [
          ValueListenableBuilder(
            valueListenable: _options,
            builder: (context, options, child) {
              return SegmentedButton<EditorPanel>(
                segments: const [
                  ButtonSegment<EditorPanel>(
                    value: EditorPanel.func,
                    icon: Icon(Icons.menu_rounded),
                  ),
                  ButtonSegment<EditorPanel>(
                    value: EditorPanel.tpl,
                    icon: Icon(Icons.code_rounded),
                  ),
                  ButtonSegment<EditorPanel>(
                    value: EditorPanel.json,
                    icon: Icon(Icons.flag_circle_outlined),
                  ),
                  ButtonSegment<EditorPanel>(
                    value: EditorPanel.code,
                    icon: Icon(Icons.subject_outlined),
                  ),
                ],
                selected: options.sets,
                onSelectionChanged: (newSets) {
                  _options.newValue(options..sets = newSets);
                },
                multiSelectionEnabled: true,
              );
            },
          ),
          const SizedBox(width: 24.0),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _options,
        builder: (context, options, child) {
          return Row(
            children: [
              if (options.func) _buildLeftPanel(context, theme),
              if (options.tpl)
                _buildCodePanel(theme, options.json || options.code),
              if (options.tpl && (options.json || options.code))
                _buildDragBar(),
              _buildRightPanel(theme, options),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final json = _jsonController.text.trim();
          if (json.isEmpty) {
            await _showEmptyInfo(context);
            return;
          }
          final formatted = _formatJsonContent(context, json);
          if (!formatted) {
            return;
          }
          final tpl = _templateController.text;
          final code = render(json, tpl, dartFormat: _useDartFormat.value);
          _codes.value = code;
        },
        label: const Text('Test'),
        icon: const Icon(
          Icons.flag_outlined,
          size: 16.0,
        ),
      ),
    );
  }

  Widget _buildRightPanel(ThemeData theme, PanelOption options) {
    return Expanded(
      child: Column(
        children: [
          if (options.json)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!_jsonFocusNode.hasFocus) {
                          _jsonFocusNode.requestFocus();
                        }
                      },
                      child: CodeTheme(
                        data: CodeThemeData(styles: getCodeTheme(theme)),
                        child: CodeField(
                          controller: _jsonController,
                          wrap: true,
                          focusNode: _jsonFocusNode,
                          textStyle: codeTextStyle,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _jsonController.text = testJson;
                          },
                          icon: const Icon(
                            Icons.refresh_rounded,
                            size: 16.0,
                          ),
                          label: const Text('Reset'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            final codes = _jsonController.text.trim();
                            _formatJsonContent(context, codes);
                          },
                          icon: const Icon(
                            Icons.format_indent_increase_rounded,
                            size: 16.0,
                          ),
                          label: const Text('Format'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            final codes = _jsonController.text.trim();
                            _jsonController.text = codes.unicodeToRawString();
                          },
                          icon: const Icon(
                            Icons.transform,
                            size: 16.0,
                          ),
                          label: const Text('Escape'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _jsonController.text = '';
                            _codes.value = '';
                          },
                          icon: const Icon(
                            Icons.clear_all_rounded,
                            size: 16.0,
                          ),
                          label: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (options.code)
            Expanded(
              child: Container(
                color: theme.colorScheme.onSecondary,
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: _codes,
                    builder: (context, codes, child) {
                      return HighlightView(
                        codes,
                        language: 'dart',
                        textStyle: codeTextStyle,
                        theme: getCodeTheme(theme),
                        padding: const EdgeInsets.all(24.0),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDragBar() {
    return Container(
      width: 20.0,
      height: double.infinity,
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          onHorizontalDragUpdate: (d) {
            final oldWidth = _jsonContentWidth.value;
            if (oldWidth <= 400.0 && d.delta.dx < 0) {
              _jsonContentWidth.value = 400.0;
              return;
            }
            final newValue = oldWidth + d.delta.dx;
            if (mediaQuery.size.width - newValue - 280.0 < 20.0) {
              return;
            }
            _jsonContentWidth.value = newValue;
          },
          child: const Icon(
            Icons.drag_indicator_rounded,
            size: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCodePanel(ThemeData theme, bool limit) {
    final body = GestureDetector(
      onTap: () {
        if (!_tplFocusNode.hasFocus) {
          _tplFocusNode.requestFocus();
        }
      },
      child: CodeTheme(
        data: CodeThemeData(styles: getCodeTheme(theme)),
        child: CodeField(
          controller: _templateController,
          wrap: true,
          focusNode: _tplFocusNode,
          textStyle: codeTextStyle,
        ),
      ),
    );
    if (limit) {
      return ValueListenableBuilder(
        valueListenable: _jsonContentWidth,
        builder: (context, width, child) {
          return SizedBox(
            width: width,
            height: double.infinity,
            child: body,
          );
        },
      );
    }
    return Expanded(child: SizedBox.expand(child: body));
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
                          template: _templateController.text,
                          dartFormat: _useDartFormat.value,
                        );
                        box.add(newTpl);
                      } else {
                        final template = widget.template!;
                        template.template = _templateController.text;
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
          _buildSection(context, 'Shortcuts', _shortcuts),
          _buildSection(context, 'Field Keys', _fieldKeys),
          _buildSection(context, 'Object Keys', _objKeys),
          _buildSection(context, 'Helpers', _helpers),
          const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<MapEntry<String, String>> entries,
  ) {
    final theme = Theme.of(context);
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(color: theme.cardColor),
            child: Text(
              title,
              style: theme.textTheme.titleSmall,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Wrap(
              runSpacing: 8.0,
              spacing: 8.0,
              children: List.generate(entries.length, (index) {
                final short = entries[index];
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
    );
  }

  bool _formatJsonContent(
    BuildContext context,
    String codes,
  ) {
    if (codes.isEmpty) {
      return false;
    }
    try {
      final def = JSONDef.fromString(codes);
      _jsonController.text = def.type.display;
      return true;
    } catch (e) {
      _showJsonError(context, e);
    }
    return false;
  }
}

class PanelOption {
  Set<EditorPanel> sets = EditorPanel.values.toSet();

  bool get func => sets.contains(EditorPanel.func);

  bool get tpl => sets.contains(EditorPanel.tpl);

  bool get json => sets.contains(EditorPanel.json);

  bool get code => sets.contains(EditorPanel.code);
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
      other is Template && runtimeType == other.runtimeType && id == other.id;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode;
}
