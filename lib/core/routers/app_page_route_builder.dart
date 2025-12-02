import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    required Widget Function(BuildContext) builder,
    String? name,
    Duration? transitionDuration,
    RouteTransition? transitionType,
  }) {
    final tType = transitionType ?? RouteTransition.defaultAnimation;

    if (tType == RouteTransition.defaultAnimation) {
      return MaterialPageRoute(builder: builder, settings: RouteSettings(name: name));
    }

    return PageRouteBuilder<T>(
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) => builder(context),
      settings: RouteSettings(name: name),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (tType) {
          case RouteTransition.fade:
            return FadeTransition(opacity: animation, child: child);

          case RouteTransition.fadeThrough:
            return FadeThroughTransition(
                animation: animation, secondaryAnimation: secondaryAnimation, child: child);
          case RouteTransition.fadeScale:
            return FadeScaleTransition(animation: animation, child: child);

          case RouteTransition.slideVertically:
            if (Platform.isIOS) {
              return CupertinoFullscreenDialogTransition(
                  primaryRouteAnimation: animation,
                  secondaryRouteAnimation: const AlwaysStoppedAnimation(0),
                  linearTransition: false,
                  child: child);
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

  static PageRoute route({
    required Widget Function(BuildContext) builder,
    String? name,
    Duration? transitionDuration,
    RouteTransition? transitionType,
  }) {
    return AppPageRouteBuilder._route(
        name: name,
        builder: (ctx) {
          return builder(ctx);
        },
        transitionDuration: transitionDuration,
        transitionType: transitionType);
  }
}
