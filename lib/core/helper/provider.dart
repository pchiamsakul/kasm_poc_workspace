import 'package:flutter/cupertino.dart';

abstract class Disposable {
  void dispose();
}

class Provider<T> extends StatefulWidget {
  final Widget child;
  final T _value;

  const Provider({super.key, required T value, required this.child}) : _value = value;

  static T of<T>(BuildContext context) {
    final provider = context.findAncestorWidgetOfExactType<Provider<T>>();
    return provider!._value;
  }

  @override
  State<StatefulWidget> createState() => _ProviderState();
}

extension ProviderExtension on BuildContext {
  T of<T>() => Provider.of<T>(this);

  T? ofSafe<T>() {
    try {
      return Provider.of<T>(this);
    } catch (e) {
      return null;
    }
  }
}

class _ProviderState extends State<Provider> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    (widget._value as Disposable?)?.dispose();
    super.dispose();
  }
}
