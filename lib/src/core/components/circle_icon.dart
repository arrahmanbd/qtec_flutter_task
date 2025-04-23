// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

class CircularIconButton extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double elevation;
  final int padding;
  final int iconSize;
  final bool blur;

  const CircularIconButton({
    super.key,
    this.icon,
    this.iconPath,
    required this.onPressed,
    this.size = 24.0,
    this.backgroundColor,
    this.iconColor,
    this.elevation = 0.0,
    this.padding = 4,
    this.iconSize = 16,
    this.blur = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget =
        iconPath != null
            ? Image(
              image: Svg(iconPath!),
              height: iconSize.sp,
              width: iconSize.sp,
              color: iconColor ?? AppColors.iconColor,
            )
            : Icon(
              icon,
              color: iconColor ?? AppColors.iconColor,
              size: iconSize.sp,
            );

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: size.w,
          height: size.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                backgroundColor?.withValues(alpha: blur ? 0.60 : 1.0) ??
                Colors.transparent,
          ),
          child:
              blur
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                          child: const SizedBox(),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(padding.toDouble()),
                            child: iconWidget,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Center(
                    child: Padding(
                      padding: EdgeInsets.all(padding.toDouble()),
                      child: iconWidget,
                    ),
                  ),
        ),
      ),
    );
  }
}
