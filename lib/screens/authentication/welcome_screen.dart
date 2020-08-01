import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:notify/screens/authentication/signup_screen.dart';
import 'package:notify/widgets/rounded_button.dart';

import '../../constant.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {

  static const routeName = '/welcome-screen';


  @override
  Widget build(BuildContext context) {
    final size = DeviceSize(context: context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(

              children: <Widget>[
                SizedBox(width: size.width*0.1,),
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('assets/images/icon_blue.png'),
                    height: 40.0,
                  ),
                ),
                SizedBox(width: size.width*0.04,),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 500),
                  pause: Duration(milliseconds:  500),
                  text: ['Notify'],
                  totalRepeatCount: 4,
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height *0.05,),
            RoundedButton(
              text: 'LOG IN',
              color: kPrimaryColor,
              press: (){
                Navigator.pushNamed(context,LoginScreen.routeName);
              },
            ),
            RoundedButton(
              text: 'SIGN UP',
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: (){
                Navigator.pushNamed(context,SignupScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
