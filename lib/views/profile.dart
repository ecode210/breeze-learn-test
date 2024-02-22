import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/widgets/app_button.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<DashboardProvider>();
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
            height: 150.h,
            width: 150.h,
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              read.user.name.toInitials,
              style: context.textTheme.displayLarge!.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 60.sp,
              ),
            ),
          ),
          10.verticalSpace,
          Text(
            read.user.name,
            style: context.textTheme.headlineMedium,
          ),
          Text(
            read.user.email,
            style: context.textTheme.headlineSmall!.copyWith(
              color: context.colorScheme.onBackground,
            ),
          ),
          const Spacer(),
          AppButton(
            onTap: () {
              read.logout(context);
            },
            title: "Logout",
          ),
        ],
      ),
    );
  }
}
