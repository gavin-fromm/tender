import 'dart:async';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/created_recipe_class.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../classes/public_created_recipe_class.dart';
import '../cards/public_created_recipe_card.dart';

//Page for viewing your created recipes

class PublicCreatedRecipesPage extends StatefulWidget {
  @override
  PublicCreatedRecipesPageState createState() =>
      PublicCreatedRecipesPageState();
}

//Class with mixin CreatedRecipe because it can edit and delete created recipes
class PublicCreatedRecipesPageState extends State<PublicCreatedRecipesPage>
    with CreatedRecipeMixin {
  List<PublicCreatedRecipe> verifiedRecipes = [];
  List<PublicCreatedRecipe> pendingRecipes = [];
  String uid = Supabase.instance.client.auth.currentUser!.id;
  bool loaded = true;
  bool _showingMyVerifiedRecipes = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),
        () {getVerifiedRecipes(); getPendingRecipes();});
  }

  Future<void> getVerifiedRecipes() async {
    verifiedRecipes = await DatabaseService.getMyVerifiedCreatedRecipes(uid);
    for (int i = 0; i < verifiedRecipes.length - 1; i++) {
      print("Verified Recipe: ${verifiedRecipes[i]}");
    }
    setState(() {
      verifiedRecipes;
      _showingMyVerifiedRecipes = false;
      loaded = false;
    });
  }

  Future<void> getPendingRecipes() async {
    pendingRecipes =
        await DatabaseService.getMyCreatedRecipesForVerification(uid);
    for (int i = 0; i < pendingRecipes.length - 1; i++) {
      print("Verified Recipe: ${pendingRecipes[i]}");
    }
    setState(() {
      pendingRecipes;
      _showingMyVerifiedRecipes = true;
      loaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(context), body: scaffoldBody());
  }

  EasySearchBar appBar(BuildContext context) {
    return EasySearchBar(
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Sort Options'),
                    content: Text('Sort data:'),
                    actions: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                        child: Text(
                          "Alphabetically",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // sortByAlpha();
                        },
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                        child: Text(
                          "Cook Time",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // sortByTime();
                        },
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                        child: Text(
                          "Servings",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // sortByServings();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.sort))
      ],
      backgroundColor: Color.fromARGB(255, 244, 4, 4),
      foregroundColor: Colors.white,
      title: Center(
        child: Text('My Public Recipes',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 247, 247), fontSize: 20)),
      ),
      onSearch: (value) {
        // setState(() => searchValue = value);
        // searchByTitle(value);
      },
    );
  }

//changes body depending on the toggle button
  Widget scaffoldBody() {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(80),
            ),
          ),
          backgroundColor: Colors.grey,
          toolbarHeight: 30,
          centerTitle: true,
          title: _showingMyVerifiedRecipes
              ? Text(
                  'Verified Recipes',
                  style: TextStyle(
                      color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
                )
              : Text(
                  'Recipes Pending Verification',
                  style: TextStyle(
                      color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
                ),
          automaticallyImplyLeading: false,
        ),
        body: _showingMyVerifiedRecipes
            ? verifiedRecipesBody()
            : pendingRecipesBody(),
        floatingActionButton: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 4, 4),
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            onPressed: _showingMyVerifiedRecipes
                ? getVerifiedRecipes
                : getPendingRecipes,
            icon: _showingMyVerifiedRecipes
                ? Icon(
                    Icons.pending_actions,
                    color: Colors.white,
                    weight: 70,
                    size: 35,
                  )
                : Icon(
                    Icons.verified,
                    color: Colors.white,
                    weight: 70,
                    size: 35,
                  ),
          ),
        ));
  }

  RefreshIndicator verifiedRecipesBody() {
    return RefreshIndicator(
        onRefresh: () async {
          await getPendingRecipes();
          await getVerifiedRecipes();
        },
        child: loaded
            ? Center(
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
                      'Loading Your Public Recipes...',
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
              )
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // First child widget - Verified recipes ListView
                    verifiedRecipes.isEmpty
                        ? Center(
                            child: Text('You Have No Verified Recipes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )))
                        : Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: verifiedRecipes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: PublicCreatedRecipeCard(
                                    title: verifiedRecipes[index].name,
                                    servings: verifiedRecipes[index].servings,
                                    ingredients:
                                        verifiedRecipes[index].ingredients,
                                    cookInstructions:
                                        verifiedRecipes[index].cookInstructions,
                                    cookTime: verifiedRecipes[index].totalTime,
                                    thumbnailUrl: verifiedRecipes[index].image,
                                    userId: verifiedRecipes[index].userId,
                                  ),
                                  onLongPress: () {
                                    print(verifiedRecipes[index].name);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                                "Do you want to delete your ${verifiedRecipes[index].name} recipe from the public verified feed? This will not delete the recipe in your personal created recipes collection."),
                                            actions: [
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 244, 4, 4)),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 244, 4, 4)),
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  //todo: delete the recipe from verified collection
                                                  //todo: if the recipe does not exist in the personal collection, delete the image
                                                  //refresh the array after deleting the recipe
                                                  getPendingRecipes();
                                                  getVerifiedRecipes();
                                                  setState(() {});
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                );
                              },
                            ),
                          ),
                  ])));
  }

  RefreshIndicator pendingRecipesBody() {
    return RefreshIndicator(
      onRefresh: () async {
        await getPendingRecipes();
        await getVerifiedRecipes();
      },
      child: loaded
          ? Center(
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
                    'Loading Your Public Recipes...',
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
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Second child widget - Pending recipes ListView
                  pendingRecipes.isEmpty
                      ? Center(
                          child: Text('You Have No Pending Recipes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )))
                      : Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: pendingRecipes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: PublicCreatedRecipeCard(
                                    title: pendingRecipes[index].name,
                                    servings: pendingRecipes[index].servings,
                                    ingredients:
                                        pendingRecipes[index].ingredients,
                                    cookInstructions:
                                        pendingRecipes[index].cookInstructions,
                                    cookTime: pendingRecipes[index].totalTime,
                                    thumbnailUrl: pendingRecipes[index].image,
                                    userId: pendingRecipes[index].userId,
                                  ),
                                  onLongPress: () {
                                    print(pendingRecipes[index].name);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                                "Do you want to remove your ${pendingRecipes[index].name} recipe from the verification process? You will still have this recipe in your personal created recipes collection."),
                                            actions: [
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 244, 4, 4)),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 244, 4, 4)),
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  //todo: delete the recipe from pending collection only
                                                  //refresh the array after deleting the recipe
                                                  getPendingRecipes();
                                                  // getVerifiedRecipes();
                                                  setState(() {});
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                );
                              })),
                ],
              ),
            ),
    );
  }
}
