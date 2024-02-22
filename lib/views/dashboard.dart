import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/add_post.dart';
import 'package:x_social/views/home.dart';
import 'package:x_social/views/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().setPageIndex = 0;
      pageController.jumpToPage(0);
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
          "X SOCIAL",
          style: context.textTheme.headlineLarge!.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.to(const AddPost());
            },
            icon: Icon(
              Icons.add,
              color: context.colorScheme.primary,
              size: 30.sp,
            ),
          ),
          10.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  read.setPageIndex = value;
                },
                children: [
                  const Home(),
                  const Profile(),
                  Container(),
                ],
              ),
            ),
            Container(
              height: 80.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 0.h),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 120.h,
                    width: double.infinity,
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    left: watch.pageIndex == 0
                        ? 33.w
                        : watch.pageIndex == 1
                            ? 174.w
                            : 316.w,
                    child: Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Feedback.forTap(context);
                            pageController.jumpToPage(0);
                          },
                          child: SizedBox(
                            width: 100.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.home_filled,
                                  color: watch.pageIndex == 0
                                      ? context.colorScheme.background
                                      : context.colorScheme.secondary,
                                  size: 35.sp,
                                ),
                                5.verticalSpace,
                                Text(
                                  "Home",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: watch.pageIndex == 0
                                        ? context.colorScheme.background
                                        : context.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Feedback.forTap(context);
                            pageController.jumpToPage(1);
                          },
                          child: SizedBox(
                            width: 100.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_rounded,
                                  color: watch.pageIndex == 1
                                      ? context.colorScheme.background
                                      : context.colorScheme.secondary,
                                  size: 35.sp,
                                ),
                                5.verticalSpace,
                                Text(
                                  "Profile",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: watch.pageIndex == 1
                                        ? context.colorScheme.background
                                        : context.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Feedback.forTap(context);
                            pageController.jumpToPage(2);
                          },
                          child: SizedBox(
                            width: 100.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.settings_rounded,
                                  color: watch.pageIndex == 2
                                      ? context.colorScheme.background
                                      : context.colorScheme.secondary,
                                  size: 35.sp,
                                ),
                                5.verticalSpace,
                                Text(
                                  "Settings",
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: watch.pageIndex == 2
                                        ? context.colorScheme.background
                                        : context.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
