import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/screens/login_signup/login_signup_body.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final provider = Provider.of<LoginProvider>(context,listen: false);
        await FacebookAuth.i.logOut();
        var result = await provider.loginFacebook();
        if (result == LoginStatus.success) {
          Navigator.pushReplacementNamed(
              context, CustomBottomAppBar.routeName);
        } else {
          Navigator.pushReplacementNamed(
              context, LoginSignupBody.routeName);
        }
      },
      child: const FaIcon(
        FontAwesomeIcons.facebook,
        color: Colors.blue,
        size: 35,
      ),
    );
  }
}
