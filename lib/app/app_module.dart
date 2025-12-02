// ignore_for_file: depend_on_referenced_packages

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'app_module.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt', preferRelativeImports: true, asExtension: false)
Future<void> configureDependencies() async => getIt.init();
