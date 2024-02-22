import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x_social/providers/auth_provider.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/views/splash.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF222222),
    systemNavigationBarContrastEnforced: true,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.test = false});
  final bool test;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return LayoutBuilder(builder: (context, constraints) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => AuthProvider(test: test)),
              ChangeNotifierProvider(create: (context) => DashboardProvider(test: test)),
            ],
            child: MaterialApp(
              title: "X Social",
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFFEBA02),
                  primary: const Color(0xFFFEBA02),
                  background: const Color(0xFF222222),
                  surface: const Color(0xFF333333),
                  onBackground: const Color(0xFFCCCCCC),
                  onSurface: const Color(0xFFFFFFFF),
                ),
                textTheme: TextTheme(
                  displayLarge: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 45.sp : 35.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  displayMedium: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 40.sp : 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  displaySmall: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 32.sp : 26.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  headlineLarge: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 24.sp : 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  headlineMedium: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 20.sp : 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  headlineSmall: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 18.sp : 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  bodyLarge: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 18.sp : 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  bodyMedium: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 16.sp : 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  bodySmall: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 14.sp : 8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  titleLarge: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 16.sp : 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  titleMedium: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 12.sp : 6.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  titleSmall: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth < 600 ? 10.sp : 4.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              home: const Splash(),
            ),
          );
        });
      },
    );
  }
}
