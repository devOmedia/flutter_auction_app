import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/constants.dart';

final isDiviblePassword = StateProvider<bool>((ref) => true);
final isDiviblePasForConfirm = StateProvider<bool>((ref) => true);

class CustomTextInputfield extends ConsumerWidget {
  const CustomTextInputfield({
    Key? key,
    this.keyBoardType,
    this.prefixIcon,
    this.isPassword = false,
    required this.hintText,
    required this.textController,
    this.validator,
    this.isConfirmPass = false,
    this.screenName,
    this.textInputAction,
    this.isEnabled = true,
    this.isPrefixIcon = false,
  }) : super(key: key);

  final TextInputType? keyBoardType;
  final IconData? prefixIcon;
  final bool isPassword;
  final String hintText;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final bool isConfirmPass;
  final String? screenName;
  final TextInputAction? textInputAction;
  final bool isEnabled;
  final bool isPrefixIcon;

  OutlineInputBorder inputFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(
          color: KConstColors.inputFieldBorderColor, width: 2.0),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(isDiviblePassword);
    final isConfVisible = ref.watch(isDiviblePasForConfirm);
    return TextFormField(
      controller: textController,
      keyboardType: keyBoardType,
      enabled: isEnabled,
      textInputAction: textInputAction,
      obscureText: isPassword
          ? isVisible
          : isConfirmPass
              ? isConfVisible
              : false,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: isPrefixIcon
            ? Icon(
                prefixIcon,
                color: KConstColors.iconColor,
              )
            : const SizedBox(),
        suffixIcon: isPassword || isConfirmPass
            ? IconButton(
                onPressed: () {
                  if (isConfirmPass) {
                    ref.read(isDiviblePasForConfirm.notifier).state =
                        !ref.watch(isDiviblePasForConfirm.notifier).state;
                  } else if (isPassword) {
                    ref.read(isDiviblePassword.notifier).state =
                        !ref.watch(isDiviblePassword.notifier).state;
                  }
                },

                ///
                icon: isConfirmPass
                    ? Icon(
                        isConfVisible ? Icons.visibility_off : Icons.visibility,
                        color: KConstColors.iconColor,
                      )
                    : Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        color: KConstColors.iconColor,
                      ))
            : const SizedBox(),
        hintText: hintText,
        // hintStyle: const TextStyle(color: Colors.black),
        focusedBorder: inputFieldBorder(),
        enabledBorder: inputFieldBorder(),
        disabledBorder: inputFieldBorder(),
        errorBorder: inputFieldBorder(),
        focusedErrorBorder: inputFieldBorder(),
      ),
      validator: validator,
    );
  }
}
