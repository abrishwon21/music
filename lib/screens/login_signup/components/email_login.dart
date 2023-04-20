import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/login_signup/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/components/kin_form.dart';
import 'package:kin_music_player_app/services/network/regi_page.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/social_login.dart';
import 'package:kin_music_player_app/size_config.dart';

import 'forget_password.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: getProportionateScreenHeight(35)),
              Form(
                key: _emailFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: KinForm(
                  hint: 'Enter your email',
                  headerTitle: 'Email',
                  controller: email,
                ),
              ),
              Form(
                key: _passwordFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: KinForm(
                  hint: 'Enter your password',
                  headerTitle: 'Password',
                  controller: password,
                  obscureText: true,
                  hasIcon: true,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ForgetPassword.routeName);
                    },
                    child: const Text(
                      'Forget Password ?',
                      style: TextStyle(color: kGrey,   fontSize: 16,),
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),

              Consumer<LoginProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return Center(
                      child: KinProgressIndicator(),
                    );
                  }
                  return CustomElevatedButton(
                      onTap: () async {
                        if (_emailFormKey.currentState!.validate() &&
                            _passwordFormKey.currentState!.validate()) {
                          var user = {
                            'email': email.text,
                            'password': password.text
                          };
                          var result = await provider.login(json.encode(user));
                          if (result == 'Successfully Logged In') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomBottomAppBar()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result),
                            ));
                          }
                        } else if (_emailFormKey.currentState!.validate() ||
                            _passwordFormKey.currentState!.validate()) {}
                      },
                      text: 'Login');
                },
              ),
              const ReusableDivider(),
              SizedBox(height: getProportionateScreenHeight(10)),
              const SocialLogin(),
              AccAltOption(
                  buttonText: 'Register',
                  leadingText: 'Don\'t have an account ?',
                  onTap: () {
                    Navigator.pushNamed(context, RegPage.routeName);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
