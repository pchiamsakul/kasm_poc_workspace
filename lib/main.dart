import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/app.dart';
import 'package:kasm_poc_workspace/bases/init.dart';
import 'package:kasm_poc_workspace/i18n/strings.g.dart';

void main() async {
  await Init.instance.initialize();

  runApp(TranslationProvider(child: const KasmPocWorkspaceApp()));
}
