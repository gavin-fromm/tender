import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/user-interface/cards/recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecommendationPage extends StatefulWidget {
  @override
  RecommendationPageState createState() => RecommendationPageState();
}

class RecommendationPageState extends State<RecommendationPage> {
  late List<Recipe> recommendedRecipes = [];
  late List<Recipe> likedRecipes = [];
  late List<Recipe> shuffledRecipes = [];

  int index = 0;
  bool _isLoading = true;
  String uid = Supabase.instance.client.auth.currentUser!.id;
  int vegetarian = 0;
  int vegan = 0;
  int glutenFree = 0;
  int dairyFree = 0;
  int healthy = 0;

  Future<void> getRecipes() async {
    //get the users liked recipes
    likedRecipes = await DatabaseService.getRecipes(uid, 'saved recipes');

    for (int i = 0; i < likedRecipes.length - 1; i++) {
      if (likedRecipes[i].isDairyFree == true) {
        dairyFree++;
      }
      if (likedRecipes[i].isGlutenFree == true) {
        glutenFree++;
      }

      if (likedRecipes[i].isVegan == true) {
        vegan++;
      }
      if (likedRecipes[i].isVegetarian == true) {
        vegetarian++;
      }
      if (likedRecipes[i].isVeryHealthy == true) {
        healthy++;
      }
    }

    Map<String, int> filters = {
      'isVegan': vegan,
      'isVegetarian': vegetarian,
      'isGlutenFree': glutenFree,
      'isDairyFree': dairyFree,
      'isVeryHealthy': healthy,
    };

    var sortedByKeyMap = Map.fromEntries(filters.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value)));
    String filter = sortedByKeyMap.keys.toList().last;
    //finding most common tag
    recommendedRecipes = await DatabaseService.recommendRecipes(
        filter); //get recipes based on most common type
    shuffledRecipes = recommendedRecipes..shuffle();
    print(shuffledRecipes[0].name);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () => getRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      appBar: appBar(),
      body: _isLoading ? loadingIndicator() : body(),
    );
  }

  Container floatingActionButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 244, 4, 4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          getRecipes();
        },
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
          weight: 70,
          size: 25,
        ),
      ),
    );
  }

  Scrollbar body() {
    return Scrollbar(
      interactive: true,
      thumbVisibility: true,
      thickness: 8,
      radius: Radius.circular(12),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              child: Column(
                children: [
                  RecipeCard(
                    id: recommendedRecipes[index].id,
                    title: recommendedRecipes[index].name,
                    servings: recommendedRecipes[index].servings,
                    ingredients: recommendedRecipes[index].ingredients,
                    preparationSteps:
                        recommendedRecipes[index].preparationSteps,
                    cookTime: recommendedRecipes[index].totalTime,
                    thumbnailUrl: recommendedRecipes[index].images,
                    isVegetarian: recommendedRecipes[index].isVegetarian,
                    isDairyFree: recommendedRecipes[index].isDairyFree,
                    isPopular: recommendedRecipes[index].isPopular,
                    isGlutenFree: recommendedRecipes[index].isGlutenFree,
                    isVegan: recommendedRecipes[index].isVegan,
                    isVeryHealthy: recommendedRecipes[index].isVeryHealthy,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 145,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 244, 4, 4),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rate,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'Recommended',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
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
                ],
              ),
              onDoubleTap: () {
                print(recommendedRecipes[index].name);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirm'),
                      content: Text(
                          'Do you want to add ${recommendedRecipes[index].name} to your liked recipes?'),
                      actions: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            print(recommendedRecipes[index].name);
                            Navigator.pop(context);
                            await DatabaseService.saveRecipe(
                                uid, recommendedRecipes[index]);
                            getRecipes();
                            setState(() {});
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Center loadingIndicator() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 220,
          ),
          SizedBox(
            height: 70,
            width: 70,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              strokeWidth: 2,
              colors: [Color.fromARGB(255, 244, 4, 4)],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Loading Recommendations...',
            style: TextStyle(
                color: Color.fromARGB(
                  255,
                  244,
                  4,
                  4,
                ),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
      backgroundColor: Colors.grey,
      toolbarHeight: 30,
      centerTitle: true,
      title: Text(
        'Recommendations',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Container floatingIcon(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 244, 4, 4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Welcome to Recipeal!"),
                content: Text(
                    "This is the feed page. Here, you will find a wide variety of recipes, unless you would like to apply a filter! Simply choose the like or dislike button to begin!"),
                actions: [
                  Container(
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromARGB(255, 244, 4, 4),
                    ),
                    child: TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
        icon: Icon(
          Icons.info,
          color: Colors.white,
          weight: 70,
          size: 20,
        ),
      ),
    );
  }
}
