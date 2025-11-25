import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/constants/app_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class CoreModule {
  @preResolve
  Future<AppConstants> get appConstants async =>
      AppConstants.initialized(await PackageInfo.fromPlatform());
}
