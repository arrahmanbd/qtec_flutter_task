import 'package:flutter/material.dart';
import 'package:flutter_addons/flutter_addons.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:qtec_flutter_task/src/shared/theme/app_colors.dart';

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class CustomSearchField extends StatelessWidget {
  final bool disable;
  final Function()? onDisable;
  final String icon;
  final TextInputType type;
  final String hintText;
  final ValueChanged<String>? onChanged;
  const CustomSearchField({
    super.key,
    this.disable = false,
    this.onDisable,
    required this.icon,
    required this.type,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (disable) {
          onDisable!();
        } else {
          // If enabled, request focus to show the keyboard
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: AbsorbPointer(
        // Disables interaction when 'disabled' is true
        absorbing: disable,
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
                keyboardType: type,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: AppColors.greyColor, // Adjust to fit your theme
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    letterSpacing: 0.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 48),
                ),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
