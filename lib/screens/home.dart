import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/bubbleovendb.dart';
import '../components/colors.dart';
import '../components/mydrawer.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  double topContainer = 0;


  List<Widget> itemsData = [];

  //This function creates a list of recipe cards,
  //each of which can be tapped to navigate to the recipe details page
  void getPostsData() {

    //Getting a list of data from food variable in the database
    List<dynamic> responseList = food;

    //Creates an empty list called itemsList to store a widget list of recipe details
    List<Widget> itemsList = [];
  
    //asMap converts the dynamic list to a map
    //The function loops over each item in the food list using the forEach method
    responseList.asMap().forEach((index, post) {
      //When tapped, add recipe details to the list
      itemsList.add(
        GestureDetector(
          //If tapped, navigates to the detail page and creates a new instance
          //of the "Details" widget, passing the post data as a parameter
          //Specifically, the post data is passed as the "recipe" parameter
          //to the Details widget

          //This allows the Details screen to access the data
          //for the selected item and display it on the screen
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Details(
                    recipe: post,
                  )
              ),
            );
          },

          //Recipe cards
          child: Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100), blurRadius: 10.0),
                ],
                color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          post["name"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          post["healthnote"].toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold,
                              color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Image.asset(
                      "lib/images/${post["image"]}",
                      height: double.infinity,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });

    //After the loop has completed, the function sets the state of
    //the "itemsData" variable to the list of listItems.
    //The setState method is used to update the UI with the new data.
    setState(() {
      itemsData = itemsList;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();

    //The controller is used to add a listener that gets called every time
    //the user scrolls the list. The listener function updates the value
    //of topContainer based on the current scroll position of the list.
    controller.addListener(() {

      //controller.offset represents the current scroll position of the list.
      //The value of topContainer is calculated by dividing controller.offset by 105,
      //which is the height of each list item plus or minus any spacing.
      //(height = 150 and shows only 70%; 0.7 of 150 is 105)
      double value = controller.offset / 105;

      //The topContainer value is calculated, and is updated every time
      //the user scrolls the list using a ScrollController.
      setState(() {
        topContainer = value;
      });

    });

  }

  @override
  Widget build(BuildContext context) {

    //Refers to the size of the screen
    Size size = MediaQuery.of(context).size;
    
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
          'H O M E',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
      
            //Good morning bro
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Good morning,',
                style: TextStyle(
                  color: Color.fromARGB(255, 94, 94, 94),
                ),
              ),
            ),
      
            const SizedBox(height: 4),
      
            //Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'It\'s all About Good Food & Taste',
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
      
            //For You
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'For You',
                style: GoogleFonts.notoSerif(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(height: 10),

            //Food cards
            SizedBox(
              height: size.height*0.5,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      itemCount: itemsData.length,

                      //To build the list items that will be displayed in the "ListView"
                      //based on the data that is passed to it.
                      itemBuilder: (context, index) {
                        //Scaling value set to 1.0 as default
                        double scale = 1.0;

                        /*
                        In this implementation, the function applies a scaling effect
                        to each list item based on its *position in the list*
                        and the **scroll position of the screen**.

                        Index is the *position of the current list item in the list*,
                        and topContainer is the **current scroll position of the screen**.

                        The 0.5 value is used to offset the scaling effect
                        so that the topmost list item is not affected.
                        (Because if we do it in the way that the topmost item
                        is affected by the scaling effect, it would appear smaller
                        and out of place when the list is first displayed,
                        before the user has a chance to scroll.
                        By starting the scaling effect at the second list item,
                        we can ensure that the topmost item is always displayed at
                        its normal size, regardless of the scroll position.)

                        (To achieve this, we use a value of 0.5 to offset the scaling effect.)
                        
                        When topContainer is equal to 0.5,
                        the scaling factor for the second list item will be:
                        scale = 1 + 0.5 - 0.5 = 1
                        This means that the second list item will be displayed
                        at its normal size, with no scaling applied.

                        As topContainer increases above 0.5, the scaling factor for
                        the second list item will decrease, causing it to shrink in size.
                        As topContainer decreases below 0.5, the scaling factor for
                        the second list item will increase, causing it to grow in size.

                        */

                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;

                          //If the calculated scaling factor is less than 0, it is set to 0.
                          //If it is greater than 1, it is set to 1.
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }

                        }
                        
                        /*
                        This code block is used to create a single recipe card in the list.
                        The recipe card is wrapped in an Opacity widget and a Transform widget
                        to apply a scaling effect to the card as the user scrolls down the list.
                        
                        The Transform widget scales the card based on its position in the list
                        and the current scroll position of the screen.
                        As the card gets further away from the top of the screen,
                        it becomes smaller, creating a visual effect of depth.

                        The Opacity widget is used to make the card fade out slightly
                        as it becomes smaller. This helps to create a smoother transition
                        between different sizes of cards.
                        */
                        return Opacity(
                          //The opacity property is set to scale
                          opacity: scale,
                          //Transform widget applies a geometric transformation
                          //to its child widget. In this case, we're applying a
                          //scaling transformation to the card, based on the value of scale
                          child: Transform(
                            /*
                            Matrix4 represents a 4x4 transformation matrix.
                            This matrix can be used to perform various transformations like scaling.
                            We created a Matrix4 instance which represents an identity matrix
                            (which is a matrix that has no transformation applied to it
                            this means that any point (x,y) multiplied by an identity matrix will result in the same point.)
                            
                            Matrix4.identity()..scale(scale, scale) creates a new Matrix4 instance
                            that applies a scaling transformation to the identity matrix.
                            The .. operator is called a cascade operator and allows multiple
                            method calls on the same object. So in this case,
                            the scale transformation is applied to the identity matrix
                            to create a new matrix that scales the recipe card.

                            This scaling transformation scales the matrix in
                            both the x and y directions by the same amount,
                            which causes the recipe card to become smaller as scale gets smaller.
                            */
                            transform: Matrix4.identity()..scale(scale, scale),
                            //This property specifies the alignment of the transformation.
                            //In this case, we're aligning the scaling transformation to the top center of the card.
                            alignment: Alignment.topCenter,

                            child: Align(
                                //Recipe card will occupy 70% of the available vertical space within its parent widget.
                                //This means that the card will have overlapped area of around 30%
                                heightFactor: 0.7,
                                //The recipe card will be horizontally centered within its parent widget.
                                alignment: Alignment.topCenter,
                                //This is the actual widget that represents the recipe card.
                                child: itemsData[index]),
                          ),
                        );
                      }
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
