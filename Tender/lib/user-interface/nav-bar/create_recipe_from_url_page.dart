import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../back-end/database.dart';
import 'package:food_for_thought/back-end/api_config.dart';
import 'package:food_for_thought/user-interface/cards/recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../classes/recipe_class.dart';

class CreateRecipeFromURLPage extends StatefulWidget {
  @override
  CreateRecipeFromURLPageState createState() => CreateRecipeFromURLPageState();
}

class CreateRecipeFromURLPageState extends State<CreateRecipeFromURLPage> {
  TextEditingController urlController = TextEditingController();

  final emptyInput = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please enter a recipe url!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  List<Recipe> extractedRecipe = [];
  bool url = true;
  bool loading = true;
  bool error = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: floatingIcon(context),
        appBar: appBar(),
        body: body(context));
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: urlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.upload),
                  labelText: 'Recipe URL',
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 244, 4, 4)),
                  child: TextButton(
                    onPressed: () {
                      urlController.clear();
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 244, 4, 4)),
                  child: TextButton(
                    onPressed: () async {
                      if (urlController.value.text.isNotEmpty) {
                        setState(() {
                          url = false;
                          loading = true;
                        });
                        try {
                          extractedRecipe = await RecipeApi.extractFromUrl(
                              urlController.value.text);
                        } on Exception {
                          setState(() {
                            loading = false;
                            urlController.clear();
                          });
                        }
                        if (extractedRecipe.isNotEmpty) {
                          Timer(
                            Duration(seconds: 2),
                            () => setState(
                              () {
                                loading = false;
                                error = false;
                              },
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentMaterialBanner()
                          ..showMaterialBanner(emptyInput);
                        Timer(
                            Duration(seconds: 2),
                            () => ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner());
                      }
                    },
                    child: Text(
                      'Extract Recipe',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            url
                ? Text('')
                : loading
                    ? Column(
                        children: [
                          SizedBox(
                            height: 150,
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
                            'Extracting...',
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
                      )
                    : error
                        ? Column(
                            children: [
                              SizedBox(
                                height: 150,
                              ),
                              Center(
                                child: Container(
                                  width: 250,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey),
                                  child: Center(
                                    child: Text(
                                      'Error extracting, try a differnt URL.',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              RecipeCard(
                                id: extractedRecipe[0].id,
                                title: extractedRecipe[0].name,
                                servings: extractedRecipe[0].servings,
                                ingredients: extractedRecipe[0].ingredients,
                                preparationSteps:
                                    extractedRecipe[0].preparationSteps,
                                cookTime: extractedRecipe[0].totalTime,
                                thumbnailUrl: extractedRecipe[0].images,
                                isVegetarian: extractedRecipe[0].isVegetarian,
                                isDairyFree: extractedRecipe[0].isDairyFree,
                                isPopular: extractedRecipe[0].isPopular,
                                isGlutenFree: extractedRecipe[0].isGlutenFree,
                                isVegan: extractedRecipe[0].isVegan,
                                isVeryHealthy: extractedRecipe[0].isVeryHealthy,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color.fromARGB(255, 244, 4, 4)),
                                    child: TextButton(
                                      onPressed: () {
                                        extractedRecipe.clear();
                                        urlController.clear();
                                        setState(() {
                                          url = true;
                                        });
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color.fromARGB(255, 244, 4, 4)),
                                    child: TextButton(
                                      onPressed: () async {
                                        final uid = Supabase.instance.client
                                            .auth.currentUser?.id;
                                        if (uid != null) {
                                          await DatabaseService.saveRecipe(
                                              uid, extractedRecipe[0]);
                                        }

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Recipe Added"),
                                              content: Text(
                                                  "Your recipe has been added successfully!"),
                                              actions: [
                                                Container(
                                                  width: 70,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Color.fromARGB(
                                                        255, 244, 4, 4),
                                                  ),
                                                  child: TextButton(
                                                    child: Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                        setState(() {
                                          url = true;
                                        });
                                      },
                                      child: Text(
                                        'Add to Liked Recipes',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(80),
        ),
      ),
      backgroundColor: Colors.grey,
      toolbarHeight: 30,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'URL Upload',
        style: TextStyle(fontSize: 20),
      ),
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
                title: Text("Information"),
                content: Text(
                    "Find any recipe, from any website URL, and we will try our best to extract, and create a recipe in our beloved format!"),
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
          Icons.info_sharp,
          color: Colors.white,
          weight: 70,
          size: 20,
        ),
      ),
    );
  }
}
