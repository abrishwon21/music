import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

import '../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kSecondaryColor,
            ),
          ),
          GestureDetector(
            onTap: press,
            child:  Text(
              "See All",
              style: TextStyle(color: kSecondaryColor.withOpacity(0.75)),
            ),
          ),
        ],
      ),
    );
  }
}
