import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/bezierContainer.dart';
import 'components/header.dart';
import 'components/login_signup_tab_bar.dart';

class LoginSignupBody extends StatelessWidget {
  const LoginSignupBody({Key? key}) : super(key: key);
  static String routeName = 'loginSignup';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
          bottom: -110,
          left: -25,

          child: Transform.rotate(
            angle: 160 ,
            child: const SizedBox(
                height: 300,
                width: 200,
                child:  BezierContainer()),
          )),
          Column(
            children: [
              const Header(),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              const Expanded(child: LoginSignupTabBar())
            ],
          ),

        ],
      ),
    );

  }
}
