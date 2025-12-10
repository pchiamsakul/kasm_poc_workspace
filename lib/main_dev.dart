import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/core/base/init.dart';
import 'package:kasm_poc_workspace/generated/strings.g.dart';

import 'app.dart';
import 'environment_config.dart';

void main() async {
  await Init.instance.initialize(EnvironmentType.develop);
  runApp(TranslationProvider(child: const ThemeApp()));
}
