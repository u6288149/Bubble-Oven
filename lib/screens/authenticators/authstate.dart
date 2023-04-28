import 'package:bubbleoven/screens/authenticators/login.dart';
import 'package:bubbleoven/screens/authenticators/register.dart';
import 'package:flutter/material.dart';

class AuthStatePage extends StatefulWidget {
  const AuthStatePage({super.key});

  @override
  State<AuthStatePage> createState() => _AuthStatePageState();
}

class _AuthStatePageState extends State<AuthStatePage> {
  //Show Login Page by Default
  bool showLoginPage = true;

  //Toggle Between Login and Register Page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage; //Show the opposite of what the page was when changing state
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        onTap: togglePages,
      );
    }
    else{
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}