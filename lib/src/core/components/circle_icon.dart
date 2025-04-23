// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class CircularIconButton extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double elevation;
  final int padding;

  const CircularIconButton({
    Key? key,
    this.icon,
    this.iconPath,
    required this.onPressed,
    this.size = 24.0,
    this.backgroundColor,
    this.iconColor,
    this.elevation = 0.0,
    this.padding = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: padding.p,
          child: SizedBox(
            width: size.w,
            height: size.h,
            child:
                iconPath != null
                    ? Image(
                      image: Svg(iconPath!),
                      // color: iconColor ?? AppColors.textSecondary,
                      height: size.h,
                      width: size.w,
                    )
                    : Icon(
                      icon,
                      color: iconColor ?? Colors.white,
                      size: size * 0.5,
                    ),
          ),
        ),
      ),
    );
  }
}
