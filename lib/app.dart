import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kasm_poc_workspace/app/app_module.dart';
import 'package:kasm_poc_workspace/core/base/core_platform.dart';
import 'package:kasm_poc_workspace/core/routers/app_navigator.dart';
import 'package:kasm_poc_workspace/core/routers/navigation_router.dart';
import 'package:rxdart/rxdart.dart';

class ThemeApp extends StatefulWidget {
  const ThemeApp({super.key});

  @override
  State<ThemeApp> createState() => _ThemeAppState();
}

class _ThemeAppState extends State<ThemeApp> {
  final _appKey = GlobalKey();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final appNavigator = getIt<AppNavigator>();

  @override
  void initState() {
    super.initState();
    appNavigator.setNavigatorKey(_navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      key: _appKey,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      onGenerateRoute: NavigationRouter.router,
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        CorePlatform.refresh(context);
        return Wrapper(child: child ?? Container());
      },
    );
  }
}

class Wrapper extends StatefulWidget {
  final Widget child;

  const Wrapper({super.key, required this.child});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final appNavigator = getIt<AppNavigator>();
  final compositeSubscription = CompositeSubscription();

  // static final errorKey = const Key("AppHandleError");

  @override
  void initState() {
    appNavigator.globalError
        .listen((value) {
          // try {
          //   showDialog(
          //     context: appNavigator.navigatorKey!.currentState!.overlay!.context,
          //     barrierDismissible: value.isAllowDismiss,
          //     builder: (BuildContext context) {
          //       return CustomAlertDialog(
          //         key: errorKey,
          //         title: value.title ?? "เกิดข้อผิดพลาด",
          //         description: value.description,
          //         dialogButtons: DialogButtons(
          //           key: errorKey,
          //           defaultButtonText: value.primaryText ?? "ปิด",
          //           onDefaultButtonPressed: value.primaryPressed,
          //           secondaryButtonText: value.secondaryText,
          //           onSecondaryButtonPressed: value.secondaryPressed,
          //         ),
          //       );
          //     },
          //   );
          // } catch (e) {
          //   if (kDebugMode) {
          //     print(e);
          //   }
          // }
        })
        .addTo(compositeSubscription);
    super.initState();
  }

  @override
  void dispose() {
    compositeSubscription.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
