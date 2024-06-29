import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/nav-bar/create_recipe_from_url_page.dart';
import 'package:food_for_thought/user-interface/nav-bar/feed_page.dart';
import 'package:food_for_thought/user-interface/side-menu/side_menu.dart';
import 'package:food_for_thought/user-interface/nav-bar/recommendations_page.dart';
import 'package:food_for_thought/user-interface/nav-bar/create_recipe_page.dart';
import 'package:food_for_thought/user-interface/nav-bar/verified_created_recipes_page.dart';

const _red = Color(0xFFE8120C);

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 2;

  final screens = [
    CreateRecipeFromURLPage(),
    RecipeCreation(),
    FeedPage(),
    RecommendationPage(),
    CommunityFeedPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: _buildAppBar(),
      body: screens[selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 54,
      backgroundColor: _red,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'RECIPEAL',
        style: TextStyle(
          fontFamily: 'Oswald',
          fontWeight: FontWeight.w700,
          fontSize: 22,
          letterSpacing: 4,
          color: Colors.white,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Image.asset('assets/logo/lovefood.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _red,
        unselectedItemColor: const Color(0xFFB8B0B0),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_link_rounded),
            activeIcon: Icon(Icons.add_link_rounded, size: 28),
            label: 'Import',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            activeIcon: Icon(Icons.edit_note_rounded, size: 28),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_outlined),
            activeIcon: Icon(Icons.local_fire_department_rounded, size: 28),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome_rounded, size: 28),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_outlined),
            activeIcon: Icon(Icons.verified_rounded, size: 28),
            label: 'Community',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
