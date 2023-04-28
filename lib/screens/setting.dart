import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/mydrawer.dart';
import '../components/userprofile.dart';

/*

S E T T I N G P A G E

This is the SettingPage.
Currently it is just showing a vertical list of boxes.

This is where you should have a list of options for the user to control
depending on what your app does.

*/

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final auth = FirebaseAuth.instance.currentUser!;

  //Document ID
  String? docID;

  //Get docID
  Future<String> getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: auth.uid)
        .limit(1)
        .get()
        .then((snapshot){
          if(snapshot.docs.isNotEmpty){
            docID = snapshot.docs[0].id;
          }
        });
    return docID!;
  }

  @override
  void initState() {
    //Initially execute getDocID
    getDocId();
    super.initState();
  }

  final double coverHeight = 280;
  //BuildCoverImage Widget
  Widget buildCoverImage() => Container(
    color: Colors.grey,
    child: Stack(
      children: [
        Image.asset(
          "lib/images/cover.png",
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
        Container(
          width: double.infinity,
          height: coverHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    ),
  );

  final double profileHeight = 144;
  //BuildProfileImage
  Widget buildProfileImage() => Container(
    decoration: BoxDecoration(
      border: Border.all(width: 8, color: AppColors.greyshade),
      shape: BoxShape.circle,
    ),
    child: CircleAvatar(
      radius: profileHeight/2,
      backgroundColor: Colors.transparent,
      backgroundImage: const NetworkImage(
        'https://e1.pxfuel.com/desktop-wallpaper/981/638/desktop-wallpaper-ghim-của-emo-tren-cute-avatar-trong-2020-kawaii-cute-avatars.jpg',
      ),
      
    ),
  );

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: bottom),
                child: buildCoverImage(),
              ),
              Positioned(
                top: top,
                child: buildProfileImage(),
              ),
            ],
    );
  }

  //Method for signing out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
          'S E T T I N G S',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          buildTop(),

          //FutureBuilder for printing userprofile
          FutureBuilder<String?>(
              future: getDocId(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data != null) {
                  return UserProfile(uid: snapshot.data!);
                } else {
                  return const Text('No data found for current user.');
                }
              }),
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Divider(thickness: 1,),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.06,
            child: ElevatedButton.icon(
            onPressed: () => signUserOut(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rosevale,
            ),
            icon: const Icon(Icons.logout),
            label: const Text(
              'L O G O U T',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),

          
        ],
      ),
    );
  }
}
