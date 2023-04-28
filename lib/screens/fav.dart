import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/colors.dart';
import '../components/favoritecard.dart';
import '../components/mydrawer.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final auth = FirebaseAuth.instance.currentUser!;

  String? docID;

  Future<String> getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: auth.uid)
        .limit(1)
        .get()
        .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            docID = snapshot.docs[0].id;
          }
        });
    return docID!;
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.earthyred,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'F A V O R I T E S',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 48),
            //Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Saved Recipes',
                style: GoogleFonts.notoSerif(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
      
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Divider(thickness: 2,),
            ),
      
            const SizedBox(height: 30),

            FutureBuilder<String?>(
                future: getDocId(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data != null) {
                    return FavoriteRecipeCard(uid: snapshot.data!);
                  } else {
                    return const Text('No data found for current user.');
                  }
                }),
            ),
          ],
        ),
      ),
    );
  }
}
