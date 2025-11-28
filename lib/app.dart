import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kasm_poc_workspace/bases/core_platform.dart';
import 'package:kasm_poc_workspace/di/configure_dependencies.dart';
import 'package:kasm_poc_workspace/i18n/strings.g.dart';
import 'package:kasm_poc_workspace/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/routers/custom_route_observer.dart';
import 'package:kasm_poc_workspace/routers/navigation_router.dart';

class KasmPocWorkspaceApp extends StatefulWidget {
  final String? initialRoute;

  const KasmPocWorkspaceApp({super.key, this.initialRoute});

  @override
  State<KasmPocWorkspaceApp> createState() => _KasmPocWorkspaceAppState();
}

class _KasmPocWorkspaceAppState extends State<KasmPocWorkspaceApp> {
  final _appKey = GlobalKey();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _routeObserver = CustomRouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();

    getIt<AppNavigator>().setNavigatorKey(_navigatorKey);
    getIt<AppNavigator>().setRouteObserver(_routeObserver);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _appKey,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: NavigationRouter.router,
      navigatorKey: _navigatorKey,
      initialRoute: widget.initialRoute ?? (CorePlatform.isWeb ? '/' : null),
      navigatorObservers: [_routeObserver],
      builder: (BuildContext context, Widget? child) {
        CorePlatform.refresh(context);
        final rootMediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: rootMediaQuery.copyWith(textScaler: TextScaler.linear(1.0)),
          child: child ?? Container(),
        );
      },
    );
  }
}
