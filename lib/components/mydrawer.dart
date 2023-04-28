import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/aboutpage.dart';

/*

D R A W E R

The drawer contains two of simple list tiles which is an about section and a logout button
(It wouldn't fit in the bottom navigation bar).

We decided to add only two important list tiles to be simple and concise
in what this app does, in which it can facilitates users.

*/

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  //Method for signing out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: Column(
        children: [

          //Drawer header
          DrawerHeader(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 115,
                    child: Image.asset("lib/images/mcfurnace.png"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          //About section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () {
                //Pop the old context (drawer)
                Navigator.pop(context);
                //Navigate to the AboutPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              //A ListTile of about contents
              child: ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  "A B O U T",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),
          ),

          //Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              //Calls the function to sign the user out
              onTap: () => signUserOut(),
              title: Text(
                "L O G O U T",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
