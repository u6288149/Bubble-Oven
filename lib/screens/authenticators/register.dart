import 'package:bubbleoven/components/customizedbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/colors.dart';
import '../../components/customizedformfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {

  //Text Editing Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}
void signUserUp() async {
  // Show Loading Circle
  showLoadingDialog(context);

  // Check if the confirm password and password are the same
  if (_passwordController.text == _confirmPasswordController.text) {
    // Try Creating the User
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the uid of the user that was just created
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Add user details with the uid
      addUserDetails(
        _nameController.text.trim(),
        _emailController.text.trim(),
        uid,
      );

      // Hide Loading Circle
      hideLoadingDialog(context);

    } on FirebaseAuthException catch (e) {
      // Hide Loading Circle
      hideLoadingDialog(context);

      // Show Error Message
      showErrorMessage(e.code);
    }
  } else {
    // Hide Loading Circle
    hideLoadingDialog(context);

    // Show the error message
    showErrorMessage('Passwords do not match. Try again.');
  }
}



  void addUserDetails(String username, String email, String uid) async{
    await FirebaseFirestore.instance.collection('users').add({
      'username': username,
      'email': email,
      'uid': uid,
    });
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
                  'Let\'s become one of the Bubble Oven cooks!',
                  style: TextStyle(
                    color: AppColors.blackshade,
                  ),
                ),
                const SizedBox(height: 25),

                //Textfield of name
                CustomizedFormField(
                  hintText: "Your Name",
                  obsecureText: false,
                  suffixIcon: const Icon(Icons.account_circle),
                  controller: _nameController,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                
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
                      icon: const Icon(Icons.visibility), onPressed: () {}),
                  controller: _passwordController,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),

                //Textfield of confirm password
                CustomizedFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  hintText: "Confirm Password",
                  obsecureText: true,
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility), onPressed: () {}),
                  controller: _confirmPasswordController,
                ),
                const SizedBox(
                  height: 50,
                ),

                //Sign up button
                AuthButton(
                  onTap: () {
                    signUserUp();
                  },
                  text: 'Sign Up',
                ),
                const SizedBox(
                  height: 50,
                ),
          
                //Register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
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