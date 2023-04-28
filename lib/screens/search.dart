import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/colors.dart';
import '../components/mydrawer.dart';
import '../database/bubbleovendb.dart';

/*

S E A R C H

This page gives a simple algorithm of searching items in the database.

The cards are not clickable since it is implemented in the home page.

*/

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  //Fetch data from the database
  final List<Map<String, dynamic>> recipeList = food;

  //A list to store food information
  List<Map<String, dynamic>> output = [];

  //Show all the recipes in the initial state
  @override
  void initState() {
    output = recipeList;
    super.initState();
  }

  //Function for searching
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if(enteredKeyword.isEmpty) {
      results = recipeList;
    } else {
      results = recipeList
          .where((recipe) =>
          recipe["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    //Set a state after filtering
    setState(() {
      output = results;
    });
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
          'S E A R C H',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),

      //Body of search page
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),

          //Search header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Discover',
              style: GoogleFonts.notoSerif(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Your daily inspirations of recipe',
              style: TextStyle(
                color: Color.fromARGB(255, 94, 94, 94),
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 35),

          //Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    //Separate TextForm from the customizedformfield (since it is simpler)
                    child: TextFormField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Your Recipes',
                        suffixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 201, 201, 201)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.rosetaupe),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          //Search result
          Expanded(
            //If the output is not empty, build a listview
            child: output.isNotEmpty
                ? ListView.builder(
              itemCount: output.length,
              //ListView returns filtered results of recipe cards
              itemBuilder: (context, index) => Card(
                color: Colors.grey[100],
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                child: ListTile(
                  leading: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 84,
                      minHeight: 84,
                      maxWidth: 104,
                      maxHeight: 104,
                    ),
                    child: Image.asset("lib/images/${output[index]["image"]}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    output[index]['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                      'View recipe and instruction →'),
                ),
              ),
            )
            //If the case was false (which means the output list is empty),
            //no results will be returned by the query
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'We couldn\'t find what you searched for.'
                        '\nPlease try again with other keywords or use generic term.',
                      ),
                    ],
                  ),
                ),
            //End of cases
          ),
        ],
      ),
    );
  }
}