import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';

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
    Key? key,
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
  }) : super(key: key);

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Auto-focus the field when autofocus is true
    if (widget.autofocus) {
      Future.delayed(Duration(milliseconds: 100), () {
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
                  if (widget.disable) {
                    widget.onDisable
                        ?.call(); // Trigger onDisable callback if the field is disabled
                  } else {
                    FocusScope.of(
                      context,
                    ).requestFocus(_focusNode); // Request focus on tap
                  }
                },
                child: _buildContent(),
              )
              : _buildContent(),
    );
  }

  AbsorbPointer _buildContent() {
    return AbsorbPointer(
      absorbing: widget.disable, // Disable interactions if 'disable' is true
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.h, maxHeight: 48.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: double.infinity, // match the ConstrainedBox height
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.greyColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: CircularIconButton(
                        onPressed: () {
                          widget.onLeading?.call();
                        },
                        iconPath: widget.icon,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        focusNode: _focusNode,
                        keyboardType: widget.type,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: 0.5,
                          ),
                          border: InputBorder.none,
                          fillColor: const Color.fromARGB(255, 22, 116, 211),
                          contentPadding: 0.p,
                        ),
                        onChanged: widget.onChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.showTrailing)
              Container(
                padding: 8.pl,
                child: Center(
                  child: CircularIconButton(
                    onPressed: () {
                      widget.onTrailing?.call();
                    },
                    iconPath: 'assets/svgs/sort.svg',
                    size: 48.sp,
                    padding: 0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
