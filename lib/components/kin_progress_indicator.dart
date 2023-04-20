import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/constants.dart';

class KinProgressIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: SpinKitFadingCircle(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? kSecondaryColor : Colors.white,
            ),
          );
        },
        size: 35,
      ),
    );
  }
}