import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class KinForm extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  bool? hasIcon;
  bool? obscureText;
  final String? headerTitle;

  KinForm(
      {required this.hint,
      required this.controller,
      this.hasIcon = false,
      this.obscureText = true,
      this.headerTitle = ''});

  @override
  State<KinForm> createState() => _KinFormState();
}

class _KinFormState extends State<KinForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
          horizontal: getProportionateScreenWidth(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.headerTitle!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          TextFormField(
              validator: (value) {


                  if (value!.isEmpty) {
                    return 'This Field is required';
                  }
                  if (widget.headerTitle == 'Email' && !EmailValidator.validate(value)) {
                    return 'Valid email address required';
                  } if (widget.headerTitle == 'Full Name' &&
                      RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$')
                          .hasMatch(value)) {
                    return "Full name can not be a number";
                  }

              },
              cursorColor: kGrey,
              style: const TextStyle(color: kGrey),
              controller: widget.controller,
              obscureText: widget.hasIcon! ? widget.obscureText! : false,
              autocorrect: false,
              enableSuggestions: false,
             keyboardType: widget.headerTitle == 'Email'? TextInputType.emailAddress : TextInputType.text,
              decoration: InputDecoration(


                  suffixIcon: widget.hasIcon!
                      ? !widget.obscureText!
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.obscureText = true;
                                });
                              },
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
                              onPressed: () {
                                setState(() {
                                  widget.obscureText = false;
                                });
                              },
                            )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),

                  hintStyle: const TextStyle(color: kGrey),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10),
                      vertical: getProportionateScreenHeight(10)),
                  hintText: widget.hint,
                  border:  const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrey,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrey,
                    ),
                  ),
                  disabledBorder:const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:kGrey,
                    ),
                  ),
                  enabledBorder:const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: kGrey,
                    ),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),

                  fillColor: Colors.transparent,
                  filled: true))
        ],
      ),
    );
  }
}
