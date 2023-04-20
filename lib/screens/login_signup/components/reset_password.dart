import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../login_signup_body.dart';
import 'custom_elevated_button.dart';
import 'header.dart';
import '../../../components/kin_form.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _codeFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool obscurePassword = false;

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
                        key: _codeFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: _buildKinForm(
                          context,
                          hint: 'Enter the reset code',
                          controller: code,
                          headerTitle: 'Reset Code',
                        )),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _passwordFormKey,
                        child: _buildKinForm(context,
                            hint: 'Enter password',
                            controller: password,
                            headerTitle: 'Password',
                            hasIcon: true, onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        })),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _confirmPasswordFormKey,
                        child: _buildKinForm(context,
                            hint: 'Confirm your password',
                            controller: confirmPassword,
                            headerTitle: 'Confirm Password',
                            hasIcon: true, onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        }))
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Consumer<LoginProvider>(builder: (context, emailProvider, _) {
                return emailProvider.isLoading
                    ? Center(
                        child: KinProgressIndicator(),
                      )
                    : CustomElevatedButton(
                        onTap: () async {
                          if (_codeFormKey.currentState!.validate() &&
                              _passwordFormKey.currentState!.validate() &&
                              _confirmPasswordFormKey.currentState!
                                  .validate()) {
                            var user = {
                              'code': code.text,
                              'password': password.text,

                            };
                            var result = await context
                                .read<LoginProvider>()
                                .resetPassword(user);
                            if (result) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Password Successfully reset!'",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kPrimaryColor,
                                  textColor: Colors.white70,
                                  fontSize: 16.0);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>const LoginSignupBody()));                            } else {
                              Fluttertoast.showToast(
                                  msg: "Invalid email address !",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kPrimaryColor,
                                  textColor: Colors.white70,
                                  fontSize: 16.0);
                            }
                          } else if (_codeFormKey.currentState!.validate() ||
                              _passwordFormKey.currentState!.validate() ||
                              _confirmPasswordFormKey.currentState!
                                  .validate()) {}
                        },
                        text: 'Submit');
              }),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    color: kGrey,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  _buildKinForm(context,
      {hasIcon = false,
      headerTitle,
      hint,
      controller,
      GestureTapCallback? onPressed}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
          horizontal: getProportionateScreenWidth(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            headerTitle!,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                decoration: TextDecoration.none),
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'This Field is required';
              }
              if (password.text.isEmpty && headerTitle == 'Confirm Password') {
                return 'This Field is required';
              }
              if (confirmPassword.text.isEmpty &&
                  headerTitle == 'Confirm Password') {
                return 'This Field is required';
              }
              if (password.text != confirmPassword.text &&
                  headerTitle == 'Confirm Password') {
                return 'The Password does not match';
              }

              if (headerTitle == 'Password' &&
                  !RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)")
                      .hasMatch(password.text)) {
                return "Password must contain at least one Capital Letter, Small Letters, Numbers & a special character";
              }
              if (headerTitle == 'Password' && password.text.length <= 8) {
                return "Password must be at least 8 characters";
              }
              if (headerTitle == 'Confirm Password' &&
                  confirmPassword.text.length < 6) {
                return "Password must be at least 6 characters";
              }
            },
            onFieldSubmitted: (va) {},
            controller: controller,
            style: const TextStyle(color: kGrey),
            cursorColor: kGrey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: hasIcon! ? !obscurePassword : false,
            decoration: InputDecoration(
                suffixIcon: hasIcon
                    ? obscurePassword
                        ? IconButton(
                            onPressed: onPressed,
                            icon: const Icon(
                              Icons.visibility,
                              color: kSecondaryColor,
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.visibility_off,
                              color: kGrey,
                            ),
                            onPressed: onPressed,
                          )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 14, color: kGrey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: kGrey,
                  ),
                ),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: kGrey,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: kGrey,
                  ),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: kGrey,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
