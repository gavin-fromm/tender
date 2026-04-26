import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

//class to define how the recipes are presented to the user -- Implemented by : Gavin Fromm

class PublicCreatedRecipeCard extends StatelessWidget {
  final String title;
  final String servings;
  final List<dynamic> ingredients;
  final String cookInstructions;
  final String cookTime;
  final String thumbnailUrl;
  final String userId;
  PublicCreatedRecipeCard(
      {required this.title,
      required this.servings,
      required this.ingredients,
      required this.cookInstructions,
      required this.cookTime,
      required this.thumbnailUrl,
      required this.userId});
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: buildFront(context, thumbnailUrl),
      back: buildBack(context, thumbnailUrl),
    );
  }

  Widget buildFront(BuildContext context, String thumbnailUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      width: MediaQuery.of(context).size.width,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 190, 189, 189)),
        color: Colors.grey,
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
          image: NetworkImage(thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 25,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(width: 7),
                      Text(
                        'Serves $servings',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
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
                      SizedBox(width: 7),
                      Text('$cookTime minutes',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBack(BuildContext context, String thumbnailUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      width: MediaQuery.of(context).size.width,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 190, 189, 189)),
        color: Colors.white,
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
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      title,
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
                      image: NetworkImage(thumbnailUrl),
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
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    for (int i = 0; i <= ingredients.length - 1; i++) ...[
                      SizedBox(
                        width: 200,
                        child: Text(("${i + 1}. ${ingredients[i]}\n"),
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
                      height: 15,
                    ),
                    SizedBox(
                      width: 350,
                      child: HtmlWidget(cookInstructions),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
