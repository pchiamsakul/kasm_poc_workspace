import 'package:flutter_fimber/flutter_fimber.dart';

mixin BuiltInLogger {
  late final logger = FimberLog(runtimeType.toString());
}
