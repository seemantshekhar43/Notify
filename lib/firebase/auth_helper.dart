import 'package:flutter/foundation.dart';
import 'auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper  {
  ///
  /// Helper Functions
  ///
  Future<AuthResultStatus> createAccount({email, pass}) async {
    final _auth = FirebaseAuth.instance;
    AuthResultStatus _status;
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

    return _status;
  }

  Future<AuthResultStatus> login({email, pass}) async {
    final _auth = FirebaseAuth.instance;
    AuthResultStatus _status;
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  logout() async {
    final _auth = FirebaseAuth.instance;

    // notifyListeners();
  }
}
