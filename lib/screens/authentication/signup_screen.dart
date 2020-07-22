import 'package:flutter/material.dart';
import 'package:notify/firebase/auth_exception_handler.dart';
import 'package:notify/firebase/auth_helper.dart';
import 'package:notify/widgets/already_have_an_account.dart';
import 'package:notify/widgets/rounded_button.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../constant.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signup-screen';

  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isLoading = false;
  bool _isPasswordHidden = true;
  var _email;
  var _password;
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

  void _signup() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

//    try{
//      await Provider.of<Auth>(context, listen: false)
//          .signUp(_email, _password);
//      Navigator.of(context).pushNamed(LoginScreen.routeName);
//
//    } on HttpException catch(error){
//      var errorMessage  ='Failed to sign up';
//      if(error.toString().contains('EMAIL_EXISTS')){
//        errorMessage = 'Email already exists';
//      }else if(error.toString().contains('OPERATION_NOT_ALLOWED')){
//        errorMessage = 'Sign Up disabled';
//      }else if(error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')){
//        errorMessage = 'Too many attempts, try later';
//      }
//      _showSnackBar(errorMessage);
//    }
//    catch(error){
//      var errorMessage = 'An error occurred';
//      _showSnackBar(errorMessage);
//    }

    final status = await FirebaseAuthHelper().
        createAccount(email: _email, pass: _password);
    if (status == AuthResultStatus.successful) {
      // Navigate to success page

      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      try {
        await user.sendEmailVerification();
        FirebaseAuthHelper().logout();
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text('Verification Email'),
                  content: Text(
                      'Verification email sent to $_email, please verify your email to login.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ],
                ));
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } catch (e) {
        _showSnackBar('Error sending Verification mail');
      }
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
              ? CircularProgressIndicator()
              : RoundedButton(
                  text: 'SIGN UP',
                  press: () {
                    _signup();
                  },
                ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHaveAnAccount(
            login: false,
            press: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
