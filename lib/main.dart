import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notify/providers/notebooks.dart';
import 'package:notify/providers/notes.dart';
import 'package:notify/screens/authentication/login_screen.dart';
import 'package:notify/screens/authentication/signup_screen.dart';
import 'package:notify/screens/authentication/splash_screen.dart';
import 'package:notify/screens/authentication/welcome_screen.dart';
import 'package:notify/screens/dashboard.dart';
import 'package:notify/screens/edit_note_screen.dart';
import 'package:notify/screens/new_note_detail.dart';
import 'package:notify/screens/note_detail_screen.dart';
import 'package:notify/screens/notebook_screen.dart';
import 'package:notify/screens/notebooks_list_screen.dart';
import 'package:notify/screens/notes_list_screen.dart';
import 'package:provider/provider.dart';

import 'constant.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
//    _checkScreenshots();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Notebooks(),
        ),
        ChangeNotifierProvider(
          create: (context) => Notes(),
        ),
      ],
      child: MaterialApp(
        title: 'Notify',
        debugShowCheckedModeBanner: false,
        home:  StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, userSnapshot) {
              if(userSnapshot.connectionState == ConnectionState.waiting)
                return SplashScreen();
              if (userSnapshot.hasData) {
                return Dashboard();
              } else
                return WelcomeScreen();
            }),
        routes: {
          NotesListScreen.routeName: (context) => NotesListScreen(),
          NotebookScreen.routeName: (context) => NotebookScreen(),
          NotebooksListScreen.routeName: (context) => NotebooksListScreen(),
          NoteDetailScreen.routeName: (context) => NoteDetailScreen(),
          EditNoteScreen.routeName: (context) => EditNoteScreen(),
          SignupScreen.routeName: (context) => SignupScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          SplashScreen.routeName: (context) => SplashScreen(),

        },
      ),
    );
  }


}
