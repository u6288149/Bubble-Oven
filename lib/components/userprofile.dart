import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatelessWidget {
  final String uid;
  
  const UserProfile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    
    //Get the document for the current user
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder: ((context, snapshot) {
        //Determine if it's loaded or not
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              const SizedBox(height: 15),
              Text(
                '${data['username']}',
                style: GoogleFonts.notoSerif(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Logged in as\n${data['email']}',
                style: GoogleFonts.notoSerif(
                  fontSize: 14,
                ),
                textAlign:TextAlign.center,
              ),
            ],
          );
        }
        return const Text('Loading...');
      }),
    );
  }
}