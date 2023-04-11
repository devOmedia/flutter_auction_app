import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/model/constants.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({
    Key? key,
    required this.size,
    this.isBackButton = false,
  }) : super(key: key);

  final Size size;
  final bool isBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: size.width * 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isBackButton
              ? Container(
                  margin: EdgeInsets.only(
                    bottom: size.height * 26 / 580,
                  ),
                  height: 41,
                  width: 41,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xffe8ecf4),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(FeatherIcons.chevronLeft),
                  ),
                )
              : const SizedBox(),
          SizedBox(
              //width: size.width * 0.25,
              child: Text(
            "Let's get you started",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: KConstColors.secondaryColor),
          )
              // Image.network(
              //     "https://cdn-icons-png.flaticon.com/512/5977/5977581.png"),
              )
        ],
      ),
    );
  }
}
