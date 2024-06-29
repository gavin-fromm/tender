import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/user_class.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../classes/public_created_recipe_class.dart';
import '../cards/public_created_recipe_card.dart';

class CommunityFeedPage extends StatefulWidget {
  @override
  CommunityFeedPageState createState() => CommunityFeedPageState();
}

// Creates the community feed page
class CommunityFeedPageState extends State<CommunityFeedPage> {
  String uid = Supabase.instance.client.auth.currentUser!.id;
  late UserInformation user;
  late List<PublicCreatedRecipe> recipes = [];
  late List<String> names = [];
  bool _isLoading = true;

//Getting recipes from the database
  Future<void> getRecipes() async {
    recipes = await DatabaseService.getVerifiedCreatedRecipes();
    names.clear();
    for (int i = 0; i < recipes.length; i++) {
      String name = await DatabaseService.getUsersName(recipes[i].userId);
      names.add(name);
    }
    setState(() {
      _isLoading = false;
    });
  }

// gets recipes based on UID
  Future<void> getUser(String uid) async {
    user = await DatabaseService.getUser(uid);
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () => getRecipes());
  }

// If there are no community recipes this is the pop up
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      appBar: appBar(),
      body: _isLoading
          ? loadingIndicator()
          : recipes.isEmpty
              ? Center(
                  child: Text('No Community Recipes Available',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )))
              : body(),
    );
  }

// Recipe card is formated and is displayed with the option to like the recipe
  Scrollbar body() {
    return Scrollbar(
      interactive: true,
      thumbVisibility: true,
      thickness: 8,
      radius: Radius.circular(12),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onDoubleTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm'),
                    content: Text(
                        'Do you want to add ${recipes[index].name} to your liked recipes?'),
                    actions: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          print(recipes[index].name);
                          Navigator.pop(context);
                          if (recipes[index].id != null) {
                            await DatabaseService.likePublicRecipe(
                                uid, recipes[index].id!);
                          }
                          _isLoading = true;
                          recipes.clear();
                          getRecipes();
                          setState(() {});
                        },
                      )
                    ],
                  );
                },
              );
            },
            child: Column(children: [
              PublicCreatedRecipeCard(
                title: recipes[index].name,
                servings: recipes[index].servings,
                ingredients: recipes[index].ingredients,
                cookInstructions: recipes[index].cookInstructions,
                cookTime: recipes[index].totalTime,
                thumbnailUrl: recipes[index].image,
                userId: recipes[index].userId,
              ),
              Container(
                height: 50,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 244, 4, 4),
                ),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                        child: Text(
                          'Created By: @${names[index]}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 375,
                child: Divider(
                  thickness: 2,
                ),
              )
            ]),
          );
        },
      ),
    );
  }

// Loading indicator will pop up in the wait time from users interaction with the page
  Column loadingIndicator() {
    return Column(
      children: [
        SizedBox(
          height: 220,
        ),
        Center(
          child: SizedBox(
            height: 70,
            width: 70,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              strokeWidth: 2,
              colors: [Color.fromARGB(255, 244, 4, 4)],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Loading Community Recipes...',
          style: TextStyle(
              color: Color.fromARGB(
                255,
                244,
                4,
                4,
              ),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

//App bar at the top of the application
  AppBar appBar() {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
      backgroundColor: Colors.grey,
      toolbarHeight: 30,
      centerTitle: true,
      title: Text(
        'Community Recipes',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: false,
    );
  }

//Refresh button updates the recipes on the page with the latest verifed recipes
  Container floatingActionButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 244, 4, 4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        onPressed: () {
          recipes.clear();
          getRecipes();
        },
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
          weight: 70,
          size: 35,
        ),
      ),
    );
  }
}
