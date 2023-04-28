import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/colors.dart';

/*

A B O U T P A G E

This is the AboutPage. This is usually a static page that displays lots of text
describing what your app/business does.

This is also a great place to give the user a link or email that they can use 
to give any feedback about the app.

*/

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyshade,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.earthyred,
        title: const Text(
          'A B O U T  U S',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo
            SizedBox(
                  height: 200,
                  // width: MediaQuery.of(context).size.width * 0.8,
                  // margin: EdgeInsets.only(
                  //     left: MediaQuery.of(context).size.width * 0.09),
                  child: Image.asset("lib/images/logo.png"),
            ),
            const SizedBox(height: 50),  

            //Text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'A tired-and-true cookbook application that will channel your inner chef'
                          ' and make everyday cooking pleasurable. We think cooking is the key to'
                          ' a better and healthier life for people that it could be worth considering adding'
                          ' a little tech to recipe repertoire for more sophisticated culinary experience.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Bubble Groupie',
                            style: GoogleFonts.sacramento(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.rosevale,
                            ),
                            child: const Text(
                              'L E A R N  M O R E',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}
