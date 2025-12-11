import 'package:injectable/injectable.dart';

import 'cache_manager.dart';

@module
abstract class CacheManagerModule {
  @preResolve
  @singleton
  Future<CacheManager> get cacheManager => CacheManager.init();
}
