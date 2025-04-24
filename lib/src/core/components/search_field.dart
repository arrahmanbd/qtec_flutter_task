import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:qtec_flutter_task/src/core/resources/assets_link.dart';

import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

import 'circle_icon.dart';

class CustomSearchField extends StatefulWidget {
  final bool disable;
  final Function()? onDisable;
  final String icon;
  final TextInputType type;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final Function()? onTrailing;
  final bool showTrailing;
  final Function()? onLeading;
  final double? bottomMargin;

  const CustomSearchField({
    super.key,
    this.disable = false,
    this.onDisable,
    required this.icon,
    required this.type,
    required this.hintText,
    this.onChanged,
    this.autofocus = false,
    this.onTrailing,
    this.showTrailing = false,
    this.onLeading,
    this.bottomMargin,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    if (widget.autofocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verticalOffset = MediaQuery.of(context).padding.top + 20.h;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(
        top: verticalOffset,
        bottom: widget.bottomMargin ?? 24.h,
      ),
      child:
          widget.disable
              ? GestureDetector(
                onTap: () {
                  widget.onDisable?.call();
                },
                child: _buildContent(),
              )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return AbsorbPointer(
      absorbing: widget.disable,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.h, maxHeight: 48.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.outline, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: CircularIconButton(
                        onPressed: widget.onLeading ?? () {},
                        iconPath: widget.icon,
                        //size: 24.sp,
                        padding: 12,
                        iconSize: 24,
                      ),
                    ),
                    // Padding applied to icon so no need to add spacing here , on left 12+2=14 as design
                    // SizedBox(width: 12.w),
                    Expanded(
                      child: TextFormField(
                        focusNode: _focusNode,
                        keyboardType: widget.type,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          letterSpacing: -0.3,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: -0.3,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: widget.onChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.showTrailing)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Center(
                  child: CircularIconButton(
                    onPressed: widget.onTrailing ?? () {},
                    iconPath: Assets.filter,
                    size: 48.sp,
                    padding: 0,
                    iconSize: 48,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
