import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/screens/login_signup/components/reset_password.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import 'custom_elevated_button.dart';
import 'header.dart';
import '../../../components/kin_form.dart';

class EnterFullName extends StatefulWidget {

  final String phoneNumber;
  EnterFullName({required this.phoneNumber});

  @override
  State<EnterFullName> createState() => _EnterFullNameState();
}

class _EnterFullNameState extends State<EnterFullName> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController fullName = TextEditingController();
  final _fullNameFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: kPrimaryColor,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Header(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: getProportionateScreenHeight(50),
                    ),
                    Form(
                        key: _fullNameFormKey,
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        child: KinForm(
                          hint: 'Enter your Full Name',
                          controller: fullName,
                          headerTitle: 'Full Name',
                        )),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Consumer<LoginProvider>(
                builder: (context, loginProvider, _) {

                  return loginProvider.isLoading
                      ? Center(child: KinProgressIndicator())
                      : CustomElevatedButton(
                      onTap: () async {
                        if(_fullNameFormKey.currentState!.validate()){
                          await loginProvider.requestOTP(
                              widget.phoneNumber, context,fullName.text);
                        }else if( !_fullNameFormKey.currentState!.validate()){}

loginProvider.setLoader(false);
                      },
                      text: 'Request OTP');
                },
              ),
              const SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(color: kGrey,   fontSize: 16,),
                ),
              )

            ],
          ),
        ));
  }
}
