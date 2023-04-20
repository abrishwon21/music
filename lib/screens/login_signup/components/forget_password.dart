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

class ForgetPassword extends StatefulWidget {
  static String routeName = 'forgetPassword';

  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController email = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

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
                        key: _emailFormKey,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        child: KinForm(
                          hint: 'Enter your email',
                          controller: email,
                          headerTitle: 'Email',
                        )),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Consumer<LoginProvider>(
                builder :  (context,emailProvider,_){
                  return emailProvider.isLoading ? Center(child: KinProgressIndicator(),):CustomElevatedButton(
                      onTap: ()  async {
                        if (_emailFormKey.currentState!.validate()) {
                          var resetInfo = {'email': email.text};
                          var result =  await emailProvider
                              .requestForgetPassword(resetInfo);

                          if(result){
                            Fluttertoast.showToast(
                                msg: "'A reset link sent to your email address. Please check your email !'",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white70
                                ,
                                fontSize: 16.0
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPassword()));
                          }else{
                            Fluttertoast.showToast(
                                msg: "Invalid email address !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white70
                                ,
                                fontSize: 16.0
                            );

                          }
                        } else if (_emailFormKey.currentState!
                            .validate()) {}
                      },
                      text: 'Submit');
                }

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
