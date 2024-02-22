import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.label,
    this.lines = 1,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatter,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.obscure = false,
    this.onTap,
    this.onSubmitted,
    this.onChanged,
  });

  final String hint;
  final String? label;
  final int? lines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;
  final bool obscure;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: TextField(
        focusNode: focusNode,
        controller: widget.controller,
        cursorColor: Theme.of(context).colorScheme.primary,
        cursorRadius: Radius.circular(100.r),
        cursorHeight: 25.h,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatter,
        maxLines: widget.lines,
        minLines: widget.lines,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        obscureText: widget.obscure,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
              width: 1.w,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1.w,
            ),
          ),
          filled: true,
          fillColor: widget.enabled
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.primaryContainer,
          contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
          isDense: true,
          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
          labelText: widget.label,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
