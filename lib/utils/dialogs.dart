import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:x_social/utils/extensions.dart';

class AppDialogs {
  static void loadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: AspectRatio(
            aspectRatio: 1,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: context.colorScheme.background,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: context.colorScheme.primary,
                  size: 50.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
