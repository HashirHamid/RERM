import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:rsms/screens/email-otp.dart';
import 'package:rsms/widgets/MyButton.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static bool v = false;

  @override
  void initState() {
    v = false;
    super.initState();
  }

  bool rentee = false;

  Widget loginAs() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/Home.png', height: 100),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    v = true;
                    rentee = true;
                    print(rentee);
                  });
                },
                child: Text('Login as Rentee'),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    v = true;
                    rentee = false;
                    print(rentee);
                  });
                },
                child: Text('Login as Renter'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget auth(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width,
      height: deviceSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/Home.png'),
            height: 100,
          ),
          Text(
            "RERM",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Flexible(
            flex: deviceSize.width > 600 ? 2 : 1,
            child: AuthCard(rentee),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: v ? auth(context) : loginAs());
  }
}

class AuthCard extends StatefulWidget {
  bool rentee;
  AuthCard(this.rentee);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'cnic': '',
    'number': ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _CNICController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String countryDial = "+92";
  EmailOTP myauth = EmailOTP();

  Future<void> sendOTP(String email) async {
    myauth.setConfig(
        appEmail: "Mahin@RERM.com",
        appName: "RERM",
        userEmail: email,
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP send failed"),
      ));
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('An Error Occurred!'),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!, widget.rentee);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData, widget.rentee);
      }
    } on HttpException catch (e) {
      var errorMessage = 'Authentication failed.';
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address exists.';
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMessage = 'This is not a valid email address.';
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMessage = 'This password is too weak.';
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = 'Could not find a user with that email.';
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMessage = 'Incorrect password.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width * 0.8,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  _authMode == AuthMode.Signup
                      ? "Sign up for free"
                      : "Log in to your account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, bottom: 5),
                  child: Text(
                    "Email",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700),
                  )),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20),
                  hintText: "Email",
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, bottom: 5),
                  child: Text(
                    "Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700),
                  )),
              TextFormField(
                style: TextStyle(color: Colors.grey.shade600),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20),
                  hintText: "Password",
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  // label: Text('Password'),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                obscureText: true,
                controller: _passwordController,
                // ignore: missing_return
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_authMode == AuthMode.Signup)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20, bottom: 5),
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700),
                        )),
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: "Confirm password",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        // label: Text('Password'),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          // ignore: missing_return
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20, bottom: 5),
                        child: Text(
                          "CNIC",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700),
                        )),
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: "CNIC",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        // label: Text('Password'),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      // obscureText: true,
                      onChanged: (value) {
                        _authData['cnic'] = value;
                        _formKey.currentState!.validate();
                      },
                      validator: _authMode == AuthMode.Signup
                          // ignore: missing_return
                          ? (value) {
                              if (value!.isEmpty || value.length < 14) {
                                return 'CNIC is too short!';
                              }
                            }
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20, bottom: 5),
                        child: Text(
                          "Phone number",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700),
                        )),
                    // TextFormField(
                    //     enabled: _authMode == AuthMode.Signup,
                    //     keyboardType: TextInputType.number,
                    // decoration: InputDecoration(
                    //   contentPadding: EdgeInsets.only(left: 20),
                    //   hintText: "Phone number",
                    //   hintStyle: TextStyle(
                    //       color: Colors.grey.shade400, fontSize: 14),
                    //   // label: Text('Password'),
                    //   errorBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(30),
                    //     borderSide: BorderSide(color: Colors.red),
                    //   ),
                    //   focusedErrorBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(30),
                    //     borderSide: BorderSide(color: Colors.red),
                    //   ),
                    //   focusedBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(30),
                    //     borderSide: BorderSide(color: Colors.blue),
                    //   ),
                    //   enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(30),
                    //     borderSide: BorderSide(color: Colors.grey.shade400),
                    //   ),
                    //     ),
                    //     // obscureText: true,
                    //     onSaved: (value) => {_authData['number'] = value!},
                    //     onChanged: (value) => _formKey.currentState!.validate(),
                    //     validator: _authMode == AuthMode.Signup
                    //         // ignore: missing_return
                    //         ? (value) {
                    //             if (value!.isEmpty || value.length < 11) {
                    //               return 'Number is too short!';
                    //             }
                    //           }
                    //         : null),
                    IntlPhoneField(
                        controller: phoneController,
                        showCountryFlag: false,
                        showDropdownIcon: false,
                        initialValue: countryDial,
                        onCountryChanged: (country) {
                          setState(() {
                            countryDial = "+" + country.dialCode;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Phone number",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400, fontSize: 14),
                          // label: Text('Password'),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                        onSaved: (value) {
                          _authData['number'] = phoneController.text;
                        }),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                GestureDetector(
                  onTap: _authMode == AuthMode.Signup
                      ? () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          sendOTP(_emailController.text)
                              .then((_) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmailOtp(
                                              email: _emailController.text,
                                              myauth: myauth,
                                              phone: phoneController.text,
                                              submit: _submit,
                                            )),
                                  ));
                        }
                      : _submit,
                  child: MyButton(
                    Text(
                      _authMode == AuthMode.Login ? 'Login' : 'Sign up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_authMode == AuthMode.Login
                      ? "Not a user?"
                      : "Already a user?"),
                  TextButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'Sign up' : 'Login'}'),
                    onPressed: _switchAuthMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
