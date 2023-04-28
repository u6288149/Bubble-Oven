import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../components/colors.dart';


class Details extends StatefulWidget {
  final dynamic recipe;
  const Details({Key? key, this.recipe}) : super(key: key);

  @override
  State<Details> createState() => _DetailState();
}

Future<bool?> toggleFavorite(String recipeName, bool isFavorite, String recipeImage, String recipeHealthNote) async {
  // Get the current user's ID
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Check if the user is authenticated
  if (userId != null) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  QuerySnapshot querySnapshot =
      await users.where('uid', isEqualTo: userId).get();
  if (querySnapshot.docs.length == 1) {
    // Get a reference to the user's document
    DocumentReference userDoc = querySnapshot.docs[0].reference;
    // Get a reference to the user's favorites collection
    CollectionReference favorites = userDoc.collection('favorites');
    // Rest of the code to toggle the favorite status
    // ...
    // Check if the recipe is already in the user's favorites collection
    DocumentSnapshot snapshot = await favorites.doc(recipeName).get();
    if (snapshot.exists) {
      // Remove the recipe from the user's favorites collection
      await favorites.doc(recipeName).delete();
      return false;
    } else {
      // Add the recipe to the user's favorites collection
      await favorites.doc(recipeName).set({
          'isFavorite': true,
          'name': recipeName,
          'image': recipeImage,
          'healthnote': recipeHealthNote,
      });
      return true;
    }
  }
  } else {
    // If the user is not authenticated, return null
    return null;
  }
}

//Fetch fav status in real time
Future<bool> isRecipeFavorite(String recipeName) async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await users.where('uid', isEqualTo: userId).get();
    if (querySnapshot.docs.length == 1) {
      DocumentReference userDoc = querySnapshot.docs[0].reference;
      CollectionReference favorites = userDoc.collection('favorites');
      DocumentSnapshot snapshot = await favorites.doc(recipeName).get();
      return snapshot.exists;
    }
  }
  return false;
}

class _DetailState extends State<Details> {
  bool isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    fetchInitialFavoriteStatus();
  }

  Future<void> fetchInitialFavoriteStatus() async {
    bool favoriteStatus = await isRecipeFavorite(widget.recipe["name"]);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic recipe = widget.recipe;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.whiteshade,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions:[
            //We use Transform.translate widget, which allows us to move
            //the button by a specified offset *without messing up with
            //the visual effect position*
            Transform.translate(
              offset: const Offset(-10, 0),
              child: LikeButton(
                isLiked: isFavorite ? true:false,
                onTap: (isLiked) => toggleFavorite(
                  recipe["name"],
                  isLiked,
                  "lib/images/${recipe["image"]}",
                  recipe["healthnote"],
                ),
                size: 40,
                  
                likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                      size: 40,
                    );
                },
              ),
            ),
          ],
        ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height *.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter:
                  ColorFilter.mode(Colors.black.withOpacity(0.4),
                      BlendMode.srcOver),
                  image: AssetImage("lib/images/${recipe["image"]}"),
                fit: BoxFit.cover
              )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, -4),
                    blurRadius: 20
                  )
                ]
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 30,
                        right: 30
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(recipe["name"],
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ]
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30
                      ),
                      child: Row(
                        children: [
                          Text(recipe["description"].toString(),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(color: Colors.grey)
                          ),
                        ]
                      )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20,
                            left: 30,
                            right: 30
                        ),
                        child: Row(
                            children: const [
                              Text("Ingredients",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ]
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 10,
                            left: 30,
                            right: 30
                        ),
                        child: Row(
                            children: [
                              Text(recipe["ingredients"].toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            ]
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 10,
                            left: 30,
                            right: 30
                        ),
                        child: Row(
                            children: const [
                              Text("Steps",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ]
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 10,
                            left: 30,
                            right: 30
                        ),
                        child: Row(
                            children: [
                              Text(recipe["steps"].toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            ]
                        )
                    ),

                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.access_time, color: AppColors.earthygreen),
                              Text('Cook Time',
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])
                              ),
                              Text(recipe["cooktime"].toString(),
                                style: const TextStyle(color: Colors.grey)
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.local_dining, color: AppColors.rosevale),
                              Text('Calories',
                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])
                              ),
                              Text(recipe["calories"].toString(),
                                style: const TextStyle(color: Colors.grey)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}