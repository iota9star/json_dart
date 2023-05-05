import 'package:flutter/foundation.dart';

class NewValueNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  NewValueNotifier(this._value);

  @override
  T get value => _value;
  T _value;

  set value(T value) {
    newValue(value, false);
  }

  void newValue(T newValue, [bool forceUpdate = true]) {
    if (_value == newValue && !forceUpdate) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class CombineNotifier<T> extends ChangeNotifier
    implements ValueListenable<List<T>> {
  CombineNotifier(this.listenables) {
    // ignore: prefer_asserts_in_initializer_lists
    assert(listenables.isNotEmpty);
    for (final value in listenables) {
      value.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final value in listenables) {
      value.removeListener(notifyListeners);
    }
  }

  final Iterable<ValueListenable<T>> listenables;

  @override
  late final List<T> value =
      listenables.map((e) => e.value).toList(growable: false);

  @override
  String toString() {
    return listenables.toString();
  }
}
