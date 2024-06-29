import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/nav-bar/create_recipe_from_url_page.dart';
import 'package:food_for_thought/user-interface/nav-bar/feed_page.dart';
import 'package:food_for_thought/user-interface/side-menu/side_menu.dart';
import 'package:food_for_thought/user-interface/nav-bar/recommendations_page.dart';
import 'package:food_for_thought/user-interface/nav-bar/create_recipe_page.dart';
import 'package:food_for_thought/user-interface/nav-bar/verified_created_recipes_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final screens = [
    CreateRecipeFromURLPage(),
    RecipeCreation(),
    FeedPage(),
    RecommendationPage(),
    CommunityFeedPage(),
  ];

  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: appBar(),
      body: body(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromARGB(255, 151, 151, 151),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      selectedIconTheme: IconThemeData(size: 30),
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.link),
          label: 'NA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.create),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.recommend),
          label: 'Recommendations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.verified_rounded),
          label: 'Community Recipes ',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Center body() {
    return Center(
      child: screens[selectedIndex],
    );
  }

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 45,
      backgroundColor: Color.fromARGB(255, 244, 4, 4),
      centerTitle: true,
      title: const Text(
        'Recipeal',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        SizedBox(
          width: 30,
          height: 30,
          child: Image.asset('assets/logo/lovefood.png' //to display the image
              ),
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}
