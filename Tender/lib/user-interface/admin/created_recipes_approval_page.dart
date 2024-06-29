import 'package:flutter/material.dart';
import 'package:food_for_thought/classes/public_created_recipe_class.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../back-end/database.dart';
import '../cards/public_created_recipe_card.dart';

//class to allow admin to apprive user created recipes -- Implemented by : Gavin Fromm

class ApproveCreatedRecipesPage extends StatefulWidget {
  @override
  ApproveCreatedRecipesPageState createState() =>
      ApproveCreatedRecipesPageState();
}

class ApproveCreatedRecipesPageState extends State<ApproveCreatedRecipesPage> {
  List<PublicCreatedRecipe> createdRecipes = [];
  bool loading = true;

  Future<void> getRecipes() async {
    createdRecipes = await DatabaseService.getCreatedRecipesForVerification();
    setState(() {
      createdRecipes;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    //build app
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  RefreshIndicator body() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          loading = true;
        });
        getRecipes();
      },
      child: loading
          ? Center(
              child: SizedBox(
                height: 70,
                width: 70,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  strokeWidth: 2,
                  colors: [Color.fromARGB(255, 244, 4, 4)],
                ),
              ),
            )
          : createdRecipes.isEmpty
              ? Center(
                  child: Text('No Recipes Waiting For Approval',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )))
              : Scrollbar(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: createdRecipes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          PublicCreatedRecipeCard(
                            title: createdRecipes[index].name,
                            servings: createdRecipes[index].servings,
                            ingredients: createdRecipes[index].ingredients,
                            cookInstructions:
                                createdRecipes[index].cookInstructions,
                            cookTime: createdRecipes[index].totalTime,
                            thumbnailUrl: createdRecipes[index].image,
                            userId: createdRecipes[index].userId,
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
                                    deny(context, index);
                                  },
                                  child: Text(
                                    'Deny',
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
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(255, 244, 4, 4)),
                                child: TextButton(
                                  onPressed: () {
                                    approve(context, index);
                                  },
                                  child: Text(
                                    'Approve',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.grey,
      title: Text('Approve Recipes'),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }

  Future<dynamic> deny(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm"),
          content:
              Text("Deny ${createdRecipes[index].name} for public viewing?"),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 244, 4, 4)),
              child: Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.pop(context);
                if (createdRecipes[index].id != null) {
                  await DatabaseService.denyRecipe(createdRecipes[index].id!);
                }
                getRecipes();
                setState(() {});
              },
            )
          ],
        );
      },
    );
  }

  Future<dynamic> approve(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm"),
          content:
              Text("Approve ${createdRecipes[index].name} for public viewing?"),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 244, 4, 4)),
              child: Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await DatabaseService.approveRecipe(createdRecipes[index]);
                getRecipes();
                setState(() {});
              },
            )
          ],
        );
      },
    );
  }
}
