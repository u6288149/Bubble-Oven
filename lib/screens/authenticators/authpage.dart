import 'package:bubbleoven/mainpage.dart';
import 'package:bubbleoven/screens/authenticators/authstate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        //This stream is going to constantly be listening to the auth state changes
        //(If the user is logged in or not)
        builder: (context, snapshot) {
          //If the user is logged in
          if(snapshot.hasData){
            return const MainPage();
          }

          //If the user is NOT logged in
          else{
            return const AuthStatePage();
          }
        },
      ),
    );
  }
}