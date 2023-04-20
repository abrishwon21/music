import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/login_signup/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/screens/login_signup/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/social_login.dart';
import 'package:kin_music_player_app/services/network/model/user.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';
import '../../screens/login_signup/components/header.dart';

class RegPage extends StatefulWidget {
  static String routeName = 'regPage';

  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  static String routeName = 'signUp';

  @override
  void initState() {
    super.initState();
    prefix.text = '+251';
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController prefix = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  final _fullNameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();
  final _phoneNumberFormKey = GlobalKey<FormState>();
  bool obscurePassword = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: kPrimaryColor,
        key: _scaffoldKey,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Header(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: getProportionateScreenHeight(35)),
                          Form(
                            key: _fullNameFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: _buildKinForm(
                              context,
                              hint: 'Enter your full name',
                              controller: fullName,
                              headerTitle: 'Full Name',
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Form(
                              key: _emailFormKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: _buildKinForm(
                                context,
                                hint: 'Enter your email',
                                controller: email,
                                headerTitle: 'Email',
                              )),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Form(
                              key: _phoneNumberFormKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: _buildKinForm(
                                context,
                                hint: '911****89',
                                controller: phoneNumber,
                                headerTitle: 'Phone Number',
                              )),

                          Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                  ),
                  SizedBox(height: getProportionateScreenHeight(35)),
                  Consumer<LoginProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return Center(child: KinProgressIndicator());
                      }
                      return CustomElevatedButton(
                          onTap: () async {
                            if (_emailFormKey.currentState!.validate() &&
                                _fullNameFormKey.currentState!.validate() &&
                                _passwordFormKey.currentState!.validate() &&
                                _confirmPasswordFormKey.currentState!
                                    .validate() &&
                                _phoneNumberFormKey.currentState!.validate()) {
                              final provider = Provider.of<LoginProvider>(
                                  context,
                                  listen: false);
                              var result = await provider.register(User(
                                  name: fullName.text,
                                  id: 2,
                                  phoneNumber: '+251' + phoneNumber.text,
                                  email: email.text,
                                  password: password.text,
                                  passwordConfirmation: confirmPassword.text));
                              if (result == 'Successfully Registered') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomBottomAppBar()));
                              } else if (_emailFormKey.currentState!
                                      .validate() ||
                                  _fullNameFormKey.currentState!.validate() ||
                                  _passwordFormKey.currentState!.validate() ||
                                  _confirmPasswordFormKey.currentState!
                                      .validate() ||
                                  _phoneNumberFormKey.currentState!
                                      .validate()) {}
                            }
                          },
                          text: 'Signup');
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  const ReusableDivider(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  const SocialLogin(),
                  AccAltOption(
                      buttonText: 'Login',
                      leadingText: 'Do you have account ?',
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                ],
              ),
            ),

            // Align(
            //   alignment: Alignment.topLeft,
            //   child: BackButton(
            //     color: Colors.white,
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            // )
          ],
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
          vertical: headerTitle == 'Password' ? getProportionateScreenHeight(5) :getProportionateScreenHeight(10),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerTitle == 'Phone Number'
                  ? SizedBox(
                      width: 50,
                      child: TextFormField(
                        enabled: false,
                        controller: prefix,
                        style: const TextStyle(color: kGrey),
                        cursorColor: kGrey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 14, color: kGrey),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kGrey,
                              ),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kGrey,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kGrey,
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kGrey,
                              ),
                            )),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              Expanded(
                child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This Field is required';
                      }
                      if (headerTitle == 'Email' &&
                          !EmailValidator.validate(value)) {
                        return 'Valid email address required';
                      }
                      if (password.text.isEmpty &&
                          headerTitle == 'Confirm Password') {
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

                      // if (headerTitle == 'Password' &&
                      //     !RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)")
                      //         .hasMatch(password.text)) {
                      //   return "Password must contain at least one Capital Letter, Small Letters, Numbers & a special character";
                      // }
                      if (headerTitle == 'Password' &&
                          password.text.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      if (headerTitle == 'Confirm Password' &&
                          confirmPassword.text.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      if (headerTitle == 'Full Name' &&
                          fullName.text.length <= 3) {
                        return "Name must be at least 3 characters";
                      }
                      if (headerTitle == 'Phone Number' &&
                          !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                              .hasMatch(phoneNumber.text)) {
                        return "Phone number must be a number";
                      }
                      if (headerTitle == 'Phone Number' &&
                          !phoneNumber.text.startsWith('9', 0)) {
                        return "Start with 9";
                      }
                      if (headerTitle == 'Phone Number' &&
                          phoneNumber.text.length < 9) {
                        return "Phone Number  digit should be 9";
                      }

                      if (headerTitle == 'Full Name' &&
                          RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                              .hasMatch(fullName.text)) {
                        return "Full name can not be a number";
                      }
                    },
                    onFieldSubmitted: (va) {},
                    controller: controller,
                    style: const TextStyle(color: kGrey),
                    cursorColor: kGrey,
                    maxLines: 1,
                    maxLength: headerTitle == 'Phone Number' ? 9 : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: hasIcon! ? !obscurePassword : false,
                    keyboardType: headerTitle == 'Email'? TextInputType.emailAddress : headerTitle == 'Phone Number' ? TextInputType.phone : TextInputType.text,
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
                            : null,
                        hintText: hint,
                        hintStyle: const TextStyle(fontSize: 14, color: kGrey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
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
                        ))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
