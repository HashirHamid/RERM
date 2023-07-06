import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/MyButton.dart';

class EmailOtp extends StatefulWidget {
  EmailOtp(
      {required this.email,
      required this.phone,
      required this.myauth,
      required this.submit});

  String email;
  String phone;
  EmailOTP myauth;
  Function submit;

  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
  String otpPin = " ";
  String verID = " ";
  var verificationId = '';
  bool _isLoading = false;

  void verifyOTP(
    String phone,
    EmailOTP myauth,
    String otp,
  ) async {
    if (await myauth.verifyOTP(otp: otp) == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP is verified"),
      ));
      sendPhoneNumber(phone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
    }
  }

  void sendPhoneNumber(String phone) {
    final auth = Provider.of<Auth>(context, listen: false);

    auth.signInWithPhone(context, "+92" + phone, widget.submit);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            otp(widget.email),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _isLoading = true;
                  });
                  verifyOTP(widget.phone, widget.myauth, otpPin);
                },
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MyButton(Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      )))
          ],
        ),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget otp(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "We just sent a code to ",
                  style: TextStyle(color: Colors.black)),
              TextSpan(text: email, style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: "\nEnter the code here and we can continue!",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              otpPin = value;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Didn't receive the code? ",
                  style: TextStyle(color: Colors.black)),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      //
                    });
                  },
                  child: Text(
                    "Resend",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
