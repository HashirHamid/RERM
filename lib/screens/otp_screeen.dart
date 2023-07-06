import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/auth.dart';
import '../widgets/MyButton.dart';

class RegisterScreen extends StatefulWidget {
  String phone;
  String verId;
  Function submit;

  RegisterScreen(
      {required this.phone, required this.submit, required this.verId});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  String otpPin = " ";

  int screenState = 0;
  bool _isLoading = false;

  Color blue = const Color(0xff8cccff);

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('Account created!'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(c).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            ));
  }

  Future<bool> verifyOTP(arg) async {
    FirebaseAuth _auth = arg['auth'];
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: arg['VerId'], smsCode: otpPin));
    return credentials.user != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              stateOTP(widget.phone),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                    });
                    final p = Provider.of<Auth>(context, listen: false);
                    if (otpPin.length >= 6) {
                      p.verifyOtp(
                          context: context,
                          verificationId: widget.verId,
                          userOtp: otpPin,
                          onSuccess: widget.submit);
                    } else {
                      showSnackBarText("Enter OTP correctly!");
                    }
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

  Widget OTPEmail() {
    return Column();
  }

  Widget stateOTP(String number) {
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
              TextSpan(
                  text: "+92" + number, style: TextStyle(color: Colors.black)),
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
          pinTheme: PinTheme(
            activeColor: blue,
            selectedColor: blue,
            inactiveColor: Colors.black26,
          ),
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
                      screenState = 0;
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
