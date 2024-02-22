import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:x_social/models/user_model.dart';
import 'package:x_social/providers/auth_provider.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/register.dart';
import 'package:x_social/views/widgets/app_button.dart';
import 'package:x_social/views/widgets/app_text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>()
        ..emailController.clear()
        ..passwordController.clear();
      context.read<DashboardProvider>().user = UserModel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<AuthProvider>();
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    50.verticalSpace,
                    Text(
                      "Login",
                      style: context.textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    200.verticalSpace,
                    AppTextField(
                      key: const ValueKey("email"),
                      controller: read.emailController,
                      label: "Email",
                      hint: "Enter email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    20.verticalSpace,
                    AppTextField(
                      key: const ValueKey("password"),
                      controller: read.passwordController,
                      label: "Password",
                      hint: "Enter password",
                      obscure: true,
                    ),
                    10.verticalSpace,
                    Center(
                      child: GestureDetector(
                        key: const ValueKey("register"),
                        onTap: () {
                          Feedback.forTap(context);
                          context.off(const Register());
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: context.textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: "Register",
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Feedback.forTap(context);
                                    context.off(const Register());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              AppButton(
                onTap: () {
                  read.login(context);
                },
                title: "Login",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
