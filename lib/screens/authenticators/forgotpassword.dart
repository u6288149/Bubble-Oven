import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/colors.dart';
import '../../components/customizedformfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try {
      await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text.trim());
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context){
            return const AlertDialog(
              content: Text('Password reset link has been sent to your email.'),
            );
          },
        );
    } on Exception catch (e) {
      String errormsg = e.toString();
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text('An error has occurred: $errormsg'),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyshade,
      appBar: AppBar(
        backgroundColor: AppColors.rosevale,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //Heading
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Forgotten your password?\nWe can send you a link to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackshade,
              ),
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
          const SizedBox(height: 25),

          //Reset password button
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.06,
            child: ElevatedButton.icon(
              onPressed: () {
                passwordReset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rosevale,
              ),
              icon: const Icon(Icons.key), label: const Text('Reset Password'),
             ),
          ),

        ],
      ),
    );
  }
}