import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double elevation;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48.0,
    this.backgroundColor,
    this.iconColor,
    this.elevation = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      elevation: elevation,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor ?? Colors.white, size: size * 0.5),
        ),
      ),
    );
  }
}
