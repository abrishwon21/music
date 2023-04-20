import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';

import 'size_config.dart';

const kPrimaryColor = Color(0xff333333);//Color(0xFF464646);
const kSecondaryColor = Color(0xFFf36218);
const kLightSecondaryColor = Color(0xFFf89e16);
const kTertiaryColor = Color(0xFF7e9632);
const kGrey = Color(0xFFBBBBBB);
const kTextColor = Color(0xFF757575);
const String apiUrl = 'https://kinmusic.gamdsolutions.com';
const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

kShowToast() {
  return Fluttertoast.showToast(
      msg: "Please Check Your Connection",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: kPrimaryColor,
      textColor: Colors.white70
      ,
      fontSize: 16.0
  );
}

checkConnection(status) {
  if (status == ConnectivityStatus.wifi ||
      status == ConnectivityStatus.cellular) {
    return true;
  }
  return false;
}
  const List<PopupMenuItem> kMusicPopupMenuItem = [
    PopupMenuItem(child: Text('Add to playlist'), value: 1),
    PopupMenuItem(child: Text('Detail'), value: 2),
  ];
  const List<PopupMenuItem> kPlaylistPopupMenuItem = [
    PopupMenuItem(child: Text('Remove from playlist'), value: 1),
    PopupMenuItem(child: Text('Detail'), value: 2),
  ];
  const List<PopupMenuItem> kPodcastPopupMenuItem = [
    PopupMenuItem(child: Text('Detail'), value: 1),

  ];
  const List<PopupMenuItem> kDeletePlaylistTitle = [
    PopupMenuItem(child: Text('Remove playlist'), value: 1),
  ];
  const defaultDuration = Duration(milliseconds: 250);

// Form Error
  final RegExp emailValidatorRegExp =
  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  const String kEmailNullError = "Please Enter your email";
  const String kInvalidEmailError = "Please Enter Valid Email";
  const String kPassNullError = "Please Enter your password";
  const String kShortPassError = "Password is too short";
  const String kMatchPassError = "Passwords don't match";
  const String kNameNullError = "Please Enter your name";
  const String kPhoneNumberNullError = "Please Enter your phone number";
  const String kAddressNullError = "Please Enter your address";

  final otpInputDecoration = InputDecoration(
    contentPadding:
    EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
    border: outlineInputBorder(),
    focusedBorder: outlineInputBorder(),
    enabledBorder: outlineInputBorder(),
  );

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
      borderSide: const BorderSide(color: kTextColor),
    );
  }
