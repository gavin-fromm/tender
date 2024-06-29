import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:food_for_thought/classes/nutrition_class.dart';
import 'package:fraction/fraction.dart';
import '../../back-end/api_config.dart';

//class to define how the recipes are presented to the user -- Implemented by : Gavin Fromm

class RecipeCard extends StatefulWidget {
  final int id;
  final String title;
  final int servings;
  final List<dynamic> ingredients;
  final String preparationSteps;
  final int cookTime;
  final String thumbnailUrl;
  final bool isVegetarian;
  final bool isDairyFree;
  final bool isPopular;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isVeryHealthy;

  RecipeCard({
    required this.id,
    required this.title,
    required this.servings,
    required this.ingredients,
    required this.preparationSteps,
    required this.cookTime,
    required this.thumbnailUrl,
    required this.isVegetarian,
    required this.isDairyFree,
    required this.isPopular,
    required this.isGlutenFree,
    required this.isVegan,
    required this.isVeryHealthy,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  late double recipeYieldModifier;
  TextEditingController servingsController = TextEditingController();

  @override
  void initState() {
    recipeYieldModifier = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: Container(
        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 1),
        width: MediaQuery.of(context).size.width,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 190, 189, 189)),
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(widget.thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        widget.isVegetarian
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Vegetarian',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        widget.isVeryHealthy
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Healthy',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        widget.isPopular
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Popular',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Serves ${widget.servings}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 105, 105, 105),
                      // Color.fromARGB(255, 244, 4, 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {
                        showNutrition(context, widget.id);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            'Nutrition',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 3),
                        Text('${widget.cookTime} min',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      back: Container(
        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 1),
        width: MediaQuery.of(context).size.width,
        height: 340,
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 190, 189, 189)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                height: 200,
                width: 325,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: Offset(
                        0.0,
                        10.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: -6.0,
                    ),
                  ],
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.35),
                      BlendMode.multiply,
                    ),
                    image: NetworkImage(widget.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '\nIngredients',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 140,
                        child: TextField(
                          // maxLength: 3,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          controller: servingsController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.people),
                            labelText: 'Servings',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        height: 40,
                        width: 40,
                        child: TextButton(
                          child: Icon(
                            Icons.check_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            int desiredServings =
                                int.parse(servingsController.text);
                            servingsController.text;
                            int servings = widget.servings;

                            setState(() {
                              recipeYieldModifier =
                                  (desiredServings / servings);
                            });
                            print(recipeYieldModifier);
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 4, 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          child: Text(
                            'Default',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              recipeYieldModifier = 1;
                            });
                            print(recipeYieldModifier);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 4, 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          splashColor: Colors.white,
                          radius: 20,
                          child: TextButton(
                            child: Text(
                              'Double it!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              setState(() {
                                recipeYieldModifier = 2;
                              });
                              print(recipeYieldModifier);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 4, 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          child: Text(
                            'Triple it!',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              recipeYieldModifier = 3;
                            });
                            print(recipeYieldModifier);
                          },
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  for (int i = 1; i <= widget.ingredients.length - 1; i++) ...[
                    SizedBox(
                      width: 200,
                      child: Text(
                          ("$i.)  ${recipeYieldModifier * widget.ingredients[i]['amount'] >= 1 ? recipeYieldModifier * widget.ingredients[i]['amount'] : MixedFraction.fromDouble(recipeYieldModifier * widget.ingredients[i]['amount'])} ${widget.ingredients[i]['unit']} ${widget.ingredients[i]['originalName']}\n"),
                          style: TextStyle()),
                    )
                  ],
                  Text(
                    '\nPreparation Steps',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    child: HtmlWidget(widget.preparationSteps),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Additional Information',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /////////////////////////top row//////////////////////////////////////////////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            widget.isVegetarian
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Vegetarian',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            widget.isDairyFree
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Dairy Free',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            widget.isPopular
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Popular',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  ////////////bottom row////////////////////////////////////////////////////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            widget.isVegan
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Vegan',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            widget.isGlutenFree
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Gluten Free',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            widget.isVeryHealthy
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Healthy',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showNutrition(BuildContext context, int id) async {
    Nutrition nutrition = await RecipeApi.nutritionById(id);

    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Nutrition Facts')),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        'Calories: ${nutrition.calories}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        'Carbs: ${nutrition.carbs}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        'Fat: ${nutrition.fat}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          'Protein: ${nutrition.protein}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
