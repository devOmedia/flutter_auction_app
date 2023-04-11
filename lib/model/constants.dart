import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KConstColors {
  static const Color primaryColor = Color(0xFFf5f5f5);
  static const Color secondaryColor = Color(0xff418887);
  static const Color otpBorderColor = Color(0xff4271CF);
  static const Color whiteColor = Color(0xFFE8ECF4);
  static const Color hintColor = Color(0xFF8391A1);
  static const Color orangeColor = Color(0xFFF76654);
  static const Color textColor = Color(0xFF000000);
  static Color dropDownColor = Colors.white;

  ///new color
  static const Color iconColor = Color(0xff3700b3);
  static const Color inputFieldBorderColor = Color(0xff3700b3);
  static const buttonColor = Color(0xff418887);
  static const auThtextButton = Color(0xff4271CF);
  static const Color greyColor = Color(0xff8E8E93);
}

class Helper {
  static Widget spacer(Size size, double space) {
    return SizedBox(
      height: size.height * space,
    );
  }

  static const athTopPadding =
      EdgeInsets.symmetric(horizontal: 22, vertical: 125);

  static const athTopPaddingWithButton =
      EdgeInsets.symmetric(horizontal: 22, vertical: 40);

  static OutlineInputBorder inputFieldBorder({color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color ?? KConstColors.inputFieldBorderColor,
        width: 1,
      ),
    );
  }
}

class KConstTextStyle {
  static TextStyle Header = GoogleFonts.urbanist(
      textStyle: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30,
    color: KConstColors.secondaryColor,
  ));

  static const TextStyle SubHeader = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
    //color: MYEColors.secondaryColor,
  );

  static const TextStyle akBodyText = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    //color: MYEColors.textColor,
  );

  static const TextStyle akHintText = TextStyle(
    fontSize: 16,
    //color: MYEColors.hintColor,
  );
  static const TextStyle testFormLettering = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: Colors.black,
  );
  static const TextStyle levelFormLettering = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    // color: MYEColors.secondaryColor,
  );

  static TextStyle buttonText = GoogleFonts.urbanist(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
  );

  static TextStyle textButton = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      color: Color(0xff4271CF),
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  static TextStyle textButton1 = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      color: Color(0xff1E232C),
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  static TextStyle birthFieldText = const TextStyle(
    fontFamily: "GT Walsheim Pro",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xff777E91),
  );

  static TextStyle forgetScreenMsg = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      color: Color(0xff8391A1),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
}

const Icon backButton = Icon(
  Icons.arrow_back_ios,
  color: Colors.black,
  size: 20,
);
const Icon menuButton = Icon(
  Icons.menu_outlined,
  color: Colors.black,
  size: 20,
);

const double kCardHeight = 225;
const double kCardWidth = 356;

const double kSpaceBetweenCard = 24;
const double kSpaceBetweenUnselectCard = 32;
const double kSpaceUnselectedCardToTop = 320;

const Duration kAnimationDuration = Duration(milliseconds: 245);
