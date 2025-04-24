import 'package:flutter/material.dart';

class SlideRightToLeftRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideRightToLeftRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // from right
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}
