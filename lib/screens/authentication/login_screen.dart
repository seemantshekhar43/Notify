import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify/firebase/auth_exception_handler.dart';
import 'package:notify/firebase/auth_helper.dart';
import 'package:notify/screens/authentication/signup_screen.dart';
import 'package:notify/widgets/already_have_an_account.dart';
import 'package:notify/widgets/rounded_button.dart';

import 'package:provider/provider.dart';

import '../../constant.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;
  bool _isPasswordHidden = true;
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();

  void _showSnackBar(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

  void _login() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

//    try {
//      await Provider.of<Auth>(context, listen: false).logIn(_email, _password);
//      Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
//    } on HttpException catch (error) {
//      var errorMessage = 'Failed to sign up';
//      if (error.toString().contains('EMAIL_NOT_FOUND')) {
//        errorMessage = 'Email doesn\'t exist';
//      } else if (error.toString().contains('INVALID_PASSWORD')) {
//        errorMessage = 'Wrong Password';
//      } else if (error.toString().contains('USER_DISABLED')) {
//        errorMessage = 'User disabled, try later';
//      }
//      _showSnackBar(errorMessage);
//    } catch (error) {
//      var errorMessage = 'An error occurred';
//      _showSnackBar(errorMessage);
//    }

    final status = await FirebaseAuthHelper()
        .login(email: _email.trim(), pass: _password.trim());
    if (status == AuthResultStatus.successful) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (!user.isEmailVerified) {
        FirebaseAuthHelper().logout();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Verify your email',
            textScaleFactor: 1.0,
          ),
          action: SnackBarAction(
            label: 'Resend mail',
            onPressed: () async {
              try {
                await user.sendEmailVerification();
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          title: Text(
                            'Verification Email',
                            textScaleFactor: 1.0,
                          ),
                          content: Text(
                            'Verification email sent to $_email, please verify your email to login.',
                            textScaleFactor: 1.0,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'Ok',
                                textScaleFactor: 1.0,
                              ),
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                          ],
                        ));
              } catch (e) {
                _showSnackBar('Error sending Verification mail');
              }
            },
          ),
        ));
      } else {
        Navigator.pop(context);
      }
      // Navigate to success page
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      _showSnackBar(errorMsg);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: Container(
              height: 100.0,
              child: Image.asset('assets/images/icon_blue.png'),
            ),
          ),
          SizedBox(
            height: size.height*0.08,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                  //borderSide: const BorderSide(),
                ),
                filled: true,
                fillColor: kPrimaryLightColor,
                hintText: 'Enter email'),
            onChanged: (val) {
              _email = val;
            },
            validator: (value) {
              if (value.isEmpty)
                return 'Enter your email';
              else if (!value.contains('@')) {
                return 'Enter valid email';
              }
              return null;
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: _isPasswordHidden,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordHidden
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: kPrimaryColor,
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                  //borderSide: const BorderSide(),
                ),
                filled: true,
                fillColor: kPrimaryLightColor,
                hintText: 'Enter password'),
            onChanged: (val) {
              _password = val;
            },
            validator: (value) {
              if (value.isEmpty) return 'Enter password';
              return null;
            },
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          (_isLoading)
              ? SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                )
              : RoundedButton(
                  text: 'LOG IN',
                  press: () {
                    _login();
                  },
                ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHaveAnAccount(
            login: true,
            press: () {
              Navigator.pushNamed(context, SignupScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
