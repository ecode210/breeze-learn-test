import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/app_bottom_sheets.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/widgets/app_button.dart';
import 'package:x_social/views/widgets/app_text_field.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>()
        ..clearPostImage()
        ..thoughtsController.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<DashboardProvider>();
    final watch = context.watch<DashboardProvider>();
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        backgroundColor: context.colorScheme.background,
        centerTitle: true,
        title: Text(
          "Add Post",
          style: context.textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  20.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: AppTextField(
                      controller: read.thoughtsController,
                      label: "Thoughts",
                      hint: "What's on your mind?",
                      lines: 5,
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      20.horizontalSpace,
                      Text(
                        "Images (optional)",
                        style: context.textTheme.bodyMedium,
                      ),
                      5.horizontalSpace,
                      Tooltip(
                        message:
                            "Maximum of 3 images and you can rearrange the order by holding and dragging on an image.",
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        enableFeedback: true,
                        triggerMode: TooltipTriggerMode.tap,
                        showDuration: const Duration(seconds: 10),
                        preferBelow: false,
                        child: Icon(
                          Icons.info_rounded,
                          color: context.colorScheme.primary,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  SizedBox(
                    height: 150.h,
                    child: ReorderableListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      scrollDirection: Axis.horizontal,
                      header: TextButton(
                        onPressed: watch.postImages.length >= 3
                            ? null
                            : () async {
                                final image = await AppBottomSheets.pickImage(context);
                                if (image != null && read.postImages.length < 10) {
                                  read.addPostImage(image.path);
                                }
                              },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          height: 150.h,
                          width: 150.w,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          margin: EdgeInsets.only(right: 5.w),
                          decoration: BoxDecoration(
                            color: watch.postImages.length < 3
                                ? context.colorScheme.primaryContainer
                                : context.colorScheme.onBackground.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera_back_rounded,
                                color: watch.postImages.length < 3
                                    ? context.colorScheme.onPrimaryContainer
                                    : context.colorScheme.onBackground,
                                size: 40.sp,
                              ),
                              Text(
                                "Upload Images",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: watch.postImages.length < 3
                                      ? context.colorScheme.onPrimaryContainer
                                      : context.colorScheme.onBackground,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      onReorder: (oldIndex, newIndex) {
                        final image = read.postImages[oldIndex];
                        read.removePostImage(oldIndex);
                        read.insertPostImage(newIndex, image);
                      },
                      children: List.generate(watch.postImages.length, (index) {
                        final image = read.postImages[index];
                        return Stack(
                          key: ValueKey("$image-${DateTime.now().millisecondsSinceEpoch}"),
                          alignment: Alignment.center,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Container(
                              height: 150.h,
                              width: 150.w,
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                image: DecorationImage(
                                  image: FileImage(File(image)),
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0.h,
                              right: 5.w,
                              child: GestureDetector(
                                onTap: () {
                                  Feedback.forTap(context);
                                  HapticFeedback.selectionClick();
                                  read.removePostImage(index);
                                },
                                child: Container(
                                  height: 25.h,
                                  width: 25.h,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.error,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.r),
                                      bottomLeft: Radius.circular(5.r),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: context.colorScheme.background,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.h,
                              left: 5.w,
                              child: Container(
                                height: 25.h,
                                width: 25.h,
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.r),
                                    topRight: Radius.circular(5.r),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  (index + 1).toString(),
                                  style: context.textTheme.titleMedium!.copyWith(
                                    color: context.colorScheme.background,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppButton(
                onTap: () {
                  read.addPost(context);
                },
                title: "Post",
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
