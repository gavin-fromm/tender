import 'dart:async';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/user-interface/cards/recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../back-end/database.dart';

//class to define how pinned recipes are presented to the user -- Implemented by : Gavin Fromm

class ViewPinnedRecipesPage extends StatefulWidget {
  @override
  ViewPinnedRecipesPageState createState() => ViewPinnedRecipesPageState();
}

class ViewPinnedRecipesPageState extends State<ViewPinnedRecipesPage> {
  String pinnedRecipes = 'pinned recipes';
  bool loaded = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => getRecipes());
  }

  Future<void> getRecipes() async {
    recipes = await DatabaseService.getRecipes(uid, pinnedRecipes);
    setState(() {
      recipes;
      loaded = false;
    });
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget confirmButton = TextButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
      child: Text(
        "Confirm",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {},
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to remove this recipe?"),
      actions: [cancelButton, confirmButton],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  late List<Recipe> recipes = [];
  String uid = Supabase.instance.client.auth.currentUser!.id;
  String searchValue = '';

  Future<void> searchByTitle(String query) async {
    recipes = await DatabaseService.searchRecipes(uid, query, pinnedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByAlpha() async {
    recipes = await DatabaseService.sortByAlpha(uid, pinnedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByServings() async {
    recipes = await DatabaseService.sortByServings(uid, pinnedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByTime() async {
    recipes = await DatabaseService.sortByTime(uid, pinnedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> filterByVegan() async {
    recipes = await DatabaseService.filterBy(uid, pinnedRecipes, 'isVegan');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByVegetarian() async {
    recipes =
        await DatabaseService.filterBy(uid, pinnedRecipes, 'isVegetarian');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByDairyFree() async {
    recipes = await DatabaseService.filterBy(uid, pinnedRecipes, 'isDairyFree');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByPopular() async {
    recipes = await DatabaseService.filterBy(uid, pinnedRecipes, 'isPopular');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByHealthy() async {
    recipes =
        await DatabaseService.filterBy(uid, pinnedRecipes, 'isVeryHealty');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByGlutenFree() async {
    recipes =
        await DatabaseService.filterBy(uid, pinnedRecipes, 'isGlutenFree');
    setState(() {
      recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: RefreshIndicator(
        onRefresh: () => getRecipes(),
        child: loaded
            ? loadingIndicator()
            : recipes.isEmpty
                ? Center(
                    child: Text(
                      'No Pinned Recipes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : displayPinnedRecipes(),
      ),
    );
  }

  Scrollbar displayPinnedRecipes() {
    return Scrollbar(
      interactive: true,
      thumbVisibility: true,
      thickness: 12,
      radius: Radius.circular(12),
      child: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: RecipeCard(
              id: recipes[index].id,
              title: recipes[index].name,
              servings: recipes[index].servings,
              ingredients: recipes[index].ingredients,
              preparationSteps: recipes[index].preparationSteps,
              cookTime: recipes[index].totalTime,
              thumbnailUrl: recipes[index].images,
              isVegetarian: recipes[index].isVegetarian,
              isDairyFree: recipes[index].isDairyFree,
              isPopular: recipes[index].isPopular,
              isGlutenFree: recipes[index].isGlutenFree,
              isVegan: recipes[index].isVegan,
              isVeryHealthy: recipes[index].isVeryHealthy,
            ),
            onLongPress: () {
              print(recipes[index].name);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Confirm"),
                    content: Text(
                        "Are you sure you want to remove ${recipes[index].name} from your pinned recipes?"),
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
                          Navigator.pop(context);
                          await DatabaseService.unpinRecipe(
                              uid, recipes[index].id);
                          getRecipes();
                          setState(() {});
                        },
                      )
                    ],
                  );
                },
              ); // show the dialog
            },
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
            'Loading Pinned Recipes...',
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

  EasySearchBar appBar(BuildContext context) {
    return EasySearchBar(
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Sorting/Filtering'),
                    content: Text('Sort data:'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
                            child: Text(
                              "Alphabetically",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              sortByAlpha();
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
                            child: Text(
                              "Cook Time",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              sortByTime();
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
                            child: Text(
                              "Servings",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              sortByServings();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment(-.85, 0),
                        child: Text(
                          'Filter by:',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Vegan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByVegan();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Gluten Free",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByGlutenFree();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Popular",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByPopular();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Vegetarian",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByVegetarian();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Healthy",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByHealthy();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Dairy Free",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByDairyFree();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
        child: Text('Pinned Recipes',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 247, 247), fontSize: 20)),
      ),
      onSearch: (value) {
        setState(() => searchValue = value);
        searchByTitle(value);
      },
    );
  }
}
