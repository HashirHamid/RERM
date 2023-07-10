import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rsms/screens/otp_screeen.dart';
import 'package:rsms/widgets/snackbar.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _userEmail;
  bool? _rentee;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  bool? get rentee {
    return _rentee;
  }

  String? get userEmail {
    return _userEmail;
  }

  Future<void> _authenticate(
      String email, String password, String url1, bool flag) async {
    final url = url1;
    _rentee = flag;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      print(flag);
      if (flag) {
        const uri =
            'https://rsms-3e512-default-rtdb.firebaseio.com/rentee.json';
        final url = Uri.parse(uri);
        try {
          final response = await http.get(url);
          var extractedData = json.decode(response.body);
          if (extractedData == null) {
            return;
          }
          extractedData = extractedData as Map<String, dynamic>;
          List list = [];
          extractedData.forEach((key, doc) {
            list.add({
              'id': doc['id'],
              'cnic': doc['cnic'],
              'number': doc['number'],
              'owned': doc['owned'],
              'password': doc['password'],
              'email': doc['email']
            });
          });
          list = list
              .where((element) => element['id'] == responseData['localId'])
              .toList();
          if (list == []) {
            throw HttpException('Not a rentee');
          }
        } catch (e) {
          throw e;
        }
      } else {
        const uri =
            'https://rsms-3e512-default-rtdb.firebaseio.com/renter.json';
        final url = Uri.parse(uri);
        try {
          final response = await http.get(url);
          var extractedData = json.decode(response.body);
          if (extractedData == null) {
            return;
          }
          extractedData = extractedData as Map<String, dynamic>;
          List list = [];
          extractedData.forEach((key, doc) {
            list.add({
              'id': doc['id'],
              'cnic': doc['cnic'],
              'number': doc['number'],
              'password': doc['password'],
              'email': doc['email']
            });
          });
          list = list
              .where((element) => element['id'] == responseData['localId'])
              .toList();
          if (list == []) {
            throw HttpException('Not a renter');
          }
        } catch (e) {
          throw e;
        }
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addRentee(email, password, cnic, number, id) async {
    final url = 'https://rsms-3e512-default-rtdb.firebaseio.com/rentee.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'cnic': cnic,
          'id': id,
          'number': number,
          'owned': false
        }),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addRenter(email, password, cnic, number, id) async {
    final url = 'https://rsms-3e512-default-rtdb.firebaseio.com/renter.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'cnic': cnic,
          'number': number,
          'id': id,
        }),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signup(Map<String, String> authData, bool r) async {
    _rentee = r;
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD8oOkQxggXGAu3ECh5TfCd8hRXmlQ8NEE';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "email": authData['email'],
            "password": authData['password'],
            "returnSecureToken": true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      if (r) {
        await addRentee(authData['email'], authData['password'],
            authData['cnic'], authData['number'], responseData['localId']);
      } else {
        await addRenter(authData['email'], authData['password'],
            authData['cnic'], authData['number'], responseData['localId']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String email, String password, bool r) async {
    _rentee = r;
    return _authenticate(
        email,
        password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD8oOkQxggXGAu3ECh5TfCd8hRXmlQ8NEE',
        r);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  void signInWithPhone(
      BuildContext context, String phoneNumber, Function submit) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            // await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterScreen(
                        phone: phoneNumber,
                        submit: submit,
                        verId: verificationId,
                      )),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      if (user != null) {
        print("Verified!");
        onSuccess();
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {}
  }
}
