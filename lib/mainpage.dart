import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../components/colors.dart';
import '../screens/home.dart';
import '../screens/fav.dart';
import '../screens/setting.dart';
import '../screens/search.dart';

/*

M A I N P A G E

MainPage is used as the holder of all other pages.
It contains a bottom navigation bar which the user can tap.
This will navigate the app screen to the any of the ones in the 'screens' folder:

- Home Page
- Search Page
- Favorite Page
- Setting Page

*/

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //This selected index is to control the bottom nav bar
  int _selectedIndex = 0;

  //This method will update the selected index
  //when the user taps on the bottom nav bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //List of screens to display
  final List<Widget> _pages = [
    //Home page (index 0)
    const HomePage(),
    //Search page (index 1)
    const SearchPage(),
    //Favorite page (index 2)
    const FavPage(),
    //Setting page (index 3)
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyshade,

      //Body is defined to be the data of the selected page
      body: _pages[_selectedIndex],

      //Buttom navigation bar
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.earthygreen,
        animationDuration: const Duration(milliseconds: 300),
        //When the user taps on any index, calls the method to update the index
        onTap: (index) => navigateBottomBar(index),
        items: const [
          Icon( //0
            Icons.home,
            color: Colors.white,
          ),
          Icon( //1
            Icons.search,
            color: Colors.white,
          ),
          Icon( //2
            Icons.favorite,
            color: Colors.white,
          ),
          Icon( //3
            Icons.settings,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
