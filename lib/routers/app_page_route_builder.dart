import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/bases/core_platform.dart';
import 'package:kasm_poc_workspace/constants/default_values.dart';

enum RouteTransition {
  defaultAnimation,
  fade,
  fadeThrough,
  fadeScale,
  none,
  slideVertically,
  slideHorizontal,
}

class AppPageRouteBuilder {
  AppPageRouteBuilder._();

  static PageRoute<T> _route<T>({
    required Widget Function(BuildContext context) builder,
    String? name,
    Duration? transitionDuration,
    RouteTransition? transitionType,
  }) {
    final routeTransition = transitionType ?? RouteTransition.defaultAnimation;
    final routeSettings = RouteSettings(name: name);

    if (routeTransition == RouteTransition.defaultAnimation) {
      return MaterialPageRoute(builder: builder, settings: routeSettings);
    }

    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionDuration:
          transitionDuration ??
          const Duration(milliseconds: DefaultValues.defaultTransitionDuration),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        switch (routeTransition) {
          case RouteTransition.fade:
            return FadeTransition(opacity: animation, child: child);
          case RouteTransition.fadeThrough:
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          case RouteTransition.fadeScale:
            return FadeScaleTransition(animation: animation, child: child);
          case RouteTransition.slideVertically:
            if (CorePlatform.isIos) {
              return CupertinoFullscreenDialogTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: const AlwaysStoppedAnimation(0),
                linearTransition: false,
                child: child,
              );
            }
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              child: child,
            );
          case RouteTransition.slideHorizontal:
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          default:
            return child;
        }
      },
    );
  }

  static PageRoute<T> route<T>({
    required Widget Function(BuildContext context) builder,
    String? name,
    Duration? transitionDuration,
    RouteTransition? transitionType,
  }) {
    return AppPageRouteBuilder._route<T>(
      name: name,
      builder: (context) {
        return builder(context);
      },
      transitionDuration: transitionDuration,
      transitionType: transitionType,
    );
  }
}
