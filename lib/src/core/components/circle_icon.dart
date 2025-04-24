import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularIconButton extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double elevation;
  final double padding;
  final double iconSize;
  final bool blur;

  const CircularIconButton({
    super.key,
    this.icon,
    this.iconPath,
    required this.onPressed,
    this.size = 48.0,
    this.backgroundColor,
    this.iconColor,
    this.elevation = 0.0,
    this.padding = 8.0,
    this.iconSize = 20.0,
    this.blur = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget =
        iconPath != null
            ? SvgPicture.asset(
              iconPath!,
              height: iconSize,
              width: iconSize,
              colorFilter:
                  iconColor != null
                      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                      : null,
            )
            : Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Theme.of(context).iconTheme.color,
            );

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? Colors.transparent,
          ),
          child:
              blur
                  ? ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            color: (backgroundColor ?? Colors.white).withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: iconWidget,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Center(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: iconWidget,
                    ),
                  ),
        ),
      ),
    );
  }
}
