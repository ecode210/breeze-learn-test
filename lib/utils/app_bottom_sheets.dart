import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/extensions.dart';

class AppBottomSheets {
  static Future<XFile?> pickImage(BuildContext context) async {
    XFile? image;
    final read = context.read<DashboardProvider>();
    await showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      barrierColor: context.colorScheme.primary.withOpacity(0.15),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      useSafeArea: false,
      builder: (context) {
        return Container(
          width: 428.w,
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            children: [
              Center(
                child: Container(
                  height: 5.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: context.colorScheme.onBackground.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
              20.verticalSpace,
              Center(
                child: Text(
                  "Upload Image",
                  style: context.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              5.verticalSpace,
              Divider(
                color: context.colorScheme.onBackground.withOpacity(0.5),
                indent: 20.w,
                endIndent: 20.w,
              ),
              15.verticalSpace,
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20.w,
                mainAxisSpacing: 20.h,
                crossAxisCount: 2,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Feedback.forTap(context);
                      image = await read.pickImage(context, source: ImageSource.camera);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 40.sp,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                          5.verticalSpace,
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Feedback.forTap(context);
                      image = await read.pickImage(context, source: ImageSource.gallery);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_rounded,
                            size: 40.sp,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                          5.verticalSpace,
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    return image;
  }
}
