import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Themeing on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension Navigation on BuildContext {
  Future<void> to(Widget route) async {
    await Navigator.of(this).push(
      Platform.isIOS ? CupertinoPageRoute(builder: (context) => route) : MaterialPageRoute(builder: (context) => route),
    );
  }

  Future<void> off(Widget route) async {
    await Navigator.of(this).pushReplacement(
      Platform.isIOS ? CupertinoPageRoute(builder: (context) => route) : MaterialPageRoute(builder: (context) => route),
    );
  }

  void back() async {
    Navigator.of(this).pop();
  }

  void showSnackBar({required String title, bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: isError ? Theme.of(this).colorScheme.error : Theme.of(this).colorScheme.primary,
              size: 25.sp,
            ),
            5.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: Theme.of(this).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(this).colorScheme.surface,
        elevation: 0,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

extension Validation on String {
  String get toInitials {
    final value = trim().split(" ");
    if (trim().isEmpty) {
      return this;
    } else if (value.length >= 2) {
      return "${value[0][0]}${value[1][0]}".toUpperCase();
    } else if (value.length == 1) {
      return value[0][0].toUpperCase();
    } else {
      return this;
    }
  }
}

extension Formatter on num {
  String get formatTimeDifference {
    num currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    num differenceMillis = this - currentTimeMillis;

    if (differenceMillis.abs() < 60 * 60 * 1000) {
      int minutesDifference = (differenceMillis / (60 * 1000)).round().abs();
      if (minutesDifference == 0) return "now";
      return '$minutesDifference minute${minutesDifference != 1 ? 's' : ''} ago';
    } else if (differenceMillis.abs() < 24 * 60 * 60 * 1000) {
      int hoursDifference = (differenceMillis / (60 * 60 * 1000)).round().abs();
      return '$hoursDifference hour${hoursDifference != 1 ? 's' : ''} ago';
    } else if (differenceMillis.abs() < 30 * 24 * 60 * 60 * 1000) {
      int daysDifference = (differenceMillis / (24 * 60 * 60 * 1000)).round().abs();
      return '$daysDifference day${daysDifference != 1 ? 's' : ''} ago';
    } else {
      int monthsDifference = (differenceMillis / (30 * 24 * 60 * 60 * 1000)).round().abs();
      return '$monthsDifference month${monthsDifference != 1 ? 's' : ''} ago';
    }
  }
}
