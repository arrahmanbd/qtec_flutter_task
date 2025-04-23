import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';
class CustomSearchField extends StatefulWidget {
  final bool disable;
  final Function()? onDisable;
  final String icon;
  final TextInputType type;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool autofocus; // New property for autofocus

  const CustomSearchField({
    super.key,
    this.disable = false,
    this.onDisable,
    required this.icon,
    required this.type,
    required this.hintText,
    this.onChanged,
    this.autofocus = false, // Default is false, can be set to true for autofocus
  });

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
        FocusScope.of(context).requestFocus(_focusNode);
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
    return GestureDetector(
      onTap: () {
        if (widget.disable) {
          widget.onDisable?.call();  // Trigger onDisable callback if the field is disabled
        } else {
          FocusScope.of(context).requestFocus(_focusNode); // Request focus on tap
        }
      },
      child: AbsorbPointer(
        absorbing: widget.disable, // Disable interactions if 'disable' is true
        child: Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            bottom: 24.h,
          ),
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.greyColor, width: 1),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: Image(image: Svg('assets/svgs/search-normal.svg')),
                ),
              ),
              TextFormField(
                focusNode: _focusNode, // Attach the FocusNode here
                keyboardType: widget.type,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: AppColors.greyColor, // Adjust to fit your theme
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    letterSpacing: 0.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 48),
                ),
                onChanged: widget.onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
