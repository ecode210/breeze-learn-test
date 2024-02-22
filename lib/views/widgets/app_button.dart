import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:x_social/utils/extensions.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onTap, required this.title});
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        height: 60.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.background,
          ),
        ),
      ),
    );
  }
}
