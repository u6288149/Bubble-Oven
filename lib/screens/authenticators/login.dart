import 'package:bubbleoven/components/customizedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/colors.dart';
import '../../components/customizedformfield.dart';
import 'forgotpassword.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //Text Editing Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Sign User In Method
  void signUserIn() async {
    //Show Loading Circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //Try Sign In to Catch the Error
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      //Pop the Loading Circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //Show Error Message
      showErrorMessage(e.code);
    }
  }

  //Error Message Popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyshade,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( //Use this to wrap the column to avoid UI overflow problem
            child: Column( //Wrap the column in a widget called SafeArea (to make the UI avoid the notch area)
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const SizedBox(height: 0), //Just empty spacing above the icon
                //Logo
                SizedBox(
                      height: 200,
                      // width: MediaQuery.of(context).size.width * 0.8,
                      // margin: EdgeInsets.only(
                      //     left: MediaQuery.of(context).size.width * 0.09),
                      child: Image.asset("lib/images/logo.png"),
                ),
                const SizedBox(height: 25), //Just empty spacing below the icon
                
                //Welcome back
                const Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: AppColors.blackshade,
                  ),
                ),
                const SizedBox(height: 25),
          
                //Textfield of email
                CustomizedFormField(
                  hintText: "Email",
                  obsecureText: false,
                  suffixIcon: const Icon(Icons.email),
                  controller: _emailController,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
          
                //Textfield of password
                CustomizedFormField(
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  hintText: "Password",
                  obsecureText: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility), onPressed: () {}
                  ),
                  controller: _passwordController,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
          
                //Forgot password?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        //InkWell class in Flutter is a rectangular area in Flutter of a material that responds to touch in an application.
                        //onTap
                        //Similar to gesture detector
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context){
                                return ForgotPasswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.rosevale.withOpacity(0.8),
                            fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
          
                //Sign in button
                AuthButton(
                  onTap: () {
                    signUserIn();
                  },
                  text: 'Sign In',
                ),
                const SizedBox(
                  height: 50,
                ),
          
                //Register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}