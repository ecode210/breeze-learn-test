import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/auth_provider.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/login.dart';
import 'package:x_social/views/widgets/app_button.dart';
import 'package:x_social/views/widgets/app_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>()
        ..nameController.clear()
        ..emailController.clear()
        ..passwordController.clear();
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
                      "Register",
                      style: context.textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    150.verticalSpace,
                    AppTextField(
                      key: const ValueKey("name"),
                      controller: read.nameController,
                      label: "Full Name",
                      hint: "Enter full name",
                    ),
                    20.verticalSpace,
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
                        key: const ValueKey("login"),
                        onTap: () {
                          Feedback.forTap(context);
                          context.off(const Login());
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: context.textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: "Login",
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Feedback.forTap(context);
                                    context.off(const Login());
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
                  read.register(context);
                },
                title: "Register",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
