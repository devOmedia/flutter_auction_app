import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/constants.dart';



class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.buttonText,
    required this.onTriger,
  }) : super(key: key);

  final String buttonText;
  final Function onTriger;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () {
          onTriger();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(18),
          backgroundColor: KConstColors.buttonColor,
        ),
        child: Center(
            child: Text(
          buttonText,
          style: KConstTextStyle.buttonText,
        )),
      );
    });
  }
}
