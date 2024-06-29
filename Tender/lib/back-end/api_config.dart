import 'dart:convert';
import 'package:food_for_thought/classes/nutrition_class.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  // Use a single API key for consistency
  static const String _apiKey =
      "1e2f9da0ebmsh88019d09475fbafp1f5fb5jsn9fb0d28f588a";
  static const String _apiHost =
      "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com";

  //get random recipes
  static Future<List<Recipe>> getRecipes() async {
    try {
      //connect to api
      var uri = Uri.https(_apiHost, '/recipes/random', {
        "number": "5",
        "limitLicense": "false",
      });

      //get response with headers
      final response = await http.get(uri, headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _apiHost,
        "useQueryString": "true"
      });

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body); //decode json response
        List temp = [];

        for (var i in data['recipes']) {
          //add each json object to array
          temp.add(i);
        }

        return Recipe.recipesFromSnapshot(temp); //return list of recipe objects
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }

  static Future<List<Recipe>> extractFromUrl(String url) async {
    try {
      //connect to api
      var uri = Uri.https(_apiHost, '/recipes/extract', {
        "url": url,
      });

      //get response with headers
      final response = await http.get(uri, headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _apiHost,
        "useQueryString": "true"
      });

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body); //decode json response
        List temp = [];
        temp.add(data);

        return Recipe.recipesFromSnapshot(temp); //return extracted recipe
      } else {
        throw Exception('Failed to extract recipe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error extracting recipe: $e');
    }
  }

  static Future<Nutrition> nutritionById(int id) async {
    try {
      //connect to api
      var uri = Uri.https(_apiHost, '/recipes/$id/nutritionWidget.json');

      //get response with headers
      final response = await http.get(uri, headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _apiHost,
        "useQueryString": "true"
      });

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body); //decode json response
        return Nutrition.fromJson(data); //return nutrition object
      } else {
        throw Exception('Failed to load nutrition: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nutrition: $e');
    }
  }

  //get recipes based on tag
  static Future<List<Recipe>> getRecipesByTag(String tag) async {
    try {
      //connect to api
      var uri = Uri.https(_apiHost, '/recipes/random', {
        "tags": tag,
        "number": "5",
        "limitLicense": "true",
      });

      //get response with headers
      final response = await http.get(uri, headers: {
        "x-rapidapi-key": _apiKey,
        "x-rapidapi-host": _apiHost,
        "useQueryString": "true"
      });

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body); //decode json response
        List temp = [];

        for (var i in data['recipes']) {
          //add each json object to array
          temp.add(i);
        }

        return Recipe.recipesFromSnapshot(temp); //return list of recipe objects
      } else {
        throw Exception(
            'Failed to load recipes by tag: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recipes by tag: $e');
    }
  }
}
