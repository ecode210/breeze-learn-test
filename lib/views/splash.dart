import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/auth_provider.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/dashboard.dart';
import 'package:x_social/views/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isLoggedIn = await context.read<AuthProvider>().checkIfLoggedIn(context);
      if (isLoggedIn) {
        if (context.mounted) context.off(const Dashboard());
      } else {
        if (context.mounted) context.off(const Login());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: context.colorScheme.primary,
            size: 50.sp,
          ),
        ),
      ),
    );
  }
}
