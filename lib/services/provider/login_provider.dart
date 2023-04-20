import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/user.dart'
    as kin_user;
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/custom_bottom_app_bar.dart';
import '../../screens/login_signup/components/otp_verification.dart';
import '../network/api_service.dart';

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  late String _phoneNumber;
  late String _fullName;

  String message = '';

  String get phoneNumberNumber => _phoneNumber;
  Map user = {"userName": '', "email": ''};

  Future register(kin_user.User user) async {
    const String apiEndPoint = '/register';
    isLoading = true;
    notifyListeners();
    var result = await createAccount(apiEndPoint, user.toJson());
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future login(user) async {
    const String apiEndPoint = '/login';
    isLoading = true;
    notifyListeners();
    var result = await logIn(apiEndPoint, user);
    isLoading = false;
    notifyListeners();
    return result;
  }
  void setLoader(bool loader){
    isLoading = loader;
    notifyListeners();
  }
  Future requestOTP(phoneNumber, context,fullName) async {
    isLoading = true;
    notifyListeners();

    try {

      _phoneNumber = '+251' + phoneNumber;
      _fullName = fullName;
      await _auth.verifyPhoneNumber(
          phoneNumber: '+251' + phoneNumber,
          verificationCompleted: (phoneAuthCredential) async {

            PhoneAuthCredential local = PhoneAuthProvider.credential(
                verificationId: _verificationId,
                smsCode: phoneAuthCredential.smsCode!);
            signInWithPhoneAuthCredential(local, context);

          },
          verificationFailed: (verificationFailed) async {

            Fluttertoast.showToast(
                msg: verificationFailed.message!,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: kPrimaryColor,
                textColor: Colors.white70,
                fontSize: 16.0);

          },
          codeSent: (verificationId, resendingToken) async {

            Navigator.pushNamed(context, OTPVerification.routeName);
            _verificationId = verificationId;
            _phoneNumber = '+251' + phoneNumber;

          },
          codeAutoRetrievalTimeout: (verificationId) async {

          });
    } catch (e) {
     rethrow;
    }

  }

  Future verifyOTP(code, context) async {
    try {
      isLoading = true;
      notifyListeners();
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);

      signInWithPhoneAuthCredential(
        phoneAuthCredential,
        context,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, context) async {

    try {

      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        var result = await register(kin_user.User(
            name: _fullName,
            id: 2,
            loginMode: 'phone_number',
            phoneNumber: _phoneNumber,
            email: _phoneNumber ,
            password: _phoneNumber + '@email.com@password',
            passwordConfirmation: _phoneNumber + '@email.com@password'));
        if (result == 'Successfully Registered') {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> CustomBottomAppBar()), (route) => false);

          notifyListeners();
        }

      } else {

        Fluttertoast.showToast(
            msg: 'Invalid Code',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: kSecondaryColor,
            textColor: Colors.white70,
            fontSize: 16.0);

      }
    } on FirebaseException catch (e) {}

  }

  Future loginFacebook() async {
    const String apiEndPoint = '/redirect';
    isLoading = true;
    notifyListeners();
    var result = await loginWithFacebook(apiEndPoint);
    isLoading = false;
    return result;
  }

  Future<bool> requestForgetPassword(resetInfo) async {
    isLoading = true;
    notifyListeners();

    bool result =
        await requestForgetPasswordService(resetInfo, '/forgotPassword');
    isLoading = false;

    notifyListeners();
    return result;
  }

  Future<bool> resetPassword(newPassword) async {
    isLoading = true;
    notifyListeners();

    bool result =
        await resetPasswordService(newPassword, '/validate/resetCode');
    isLoading = false;

    notifyListeners();
    return result;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('token') != null) {
      return true;
    }
    return false;
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    user["userName"] = prefs.getString('name$id');
    user["email"] = prefs.getString('email$id');
    return user;
  }

  logOut() async {
    await FacebookAuth.i.logOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getInt('id');
    pref.remove('token');
    pref.remove('name$id');
    pref.remove('email$id');
  }
}
