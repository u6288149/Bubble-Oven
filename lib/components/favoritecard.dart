import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteRecipeCard extends StatelessWidget {
  final String uid;

  const FavoriteRecipeCard({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    // Get the document for the current user
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder: ((context, snapshot) {
        // Determine if it's loaded or not
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              const SizedBox(height: 15),
              // Get the favorites collection
              StreamBuilder<QuerySnapshot>(
                stream: users
                    .doc(uid)
                    .collection('favorites')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: GridView.builder(
                        shrinkWrap: true, // Set shrinkWrap to true
                        physics: const NeverScrollableScrollPhysics(), // Prevent scrolling within the GridView
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 3.2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final recipe = snapshot.data!.docs[index];
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  recipe["image"],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe["name"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(recipe["healthnote"]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Text(
                            'No favorite recipes found.\nTime to find an enjoyable favorites!',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
      
        }
        return const Text(
          'Loading...',
          style: TextStyle(
            fontSize: 16,
          ),
        );
      }),
    );
  }
}
