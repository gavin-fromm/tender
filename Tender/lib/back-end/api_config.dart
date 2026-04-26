import 'dart:convert';
import 'dart:math';
import 'package:food_for_thought/classes/nutrition_class.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static const _tagToCategory = {
    'breakfast': 'Breakfast',
    'lunch': 'Chicken',
    'dinner': 'Beef',
    'dessert': 'Dessert',
    'vegan': 'Vegan',
    'vegetarian': 'Vegetarian',
    'dairy free': 'Seafood',
  };

  static Recipe _recipeFromMealDb(Map<dynamic, dynamic> meal) {
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i']?.toString().trim() ?? '';
      final measure = meal['strMeasure$i']?.toString().trim() ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(measure.isNotEmpty ? '$measure $ingredient' : ingredient);
      }
    }

    final category = (meal['strCategory'] as String? ?? '').toLowerCase();
    final tags = (meal['strTags'] as String? ?? '').toLowerCase();

    return Recipe(
      id: int.tryParse(meal['idMeal']?.toString() ?? '0') ?? 0,
      name: meal['strMeal'] as String? ?? '',
      servings: 4,
      ingredients: ingredients,
      preparationSteps: meal['strInstructions'] as String? ?? '',
      images: meal['strMealThumb'] as String? ?? '',
      totalTime: 0,
      isVegetarian: category == 'vegetarian' || tags.contains('vegetarian'),
      isVegan: category == 'vegan' || tags.contains('vegan'),
      isGlutenFree: tags.contains('gluten free') || tags.contains('gluten-free'),
      isDairyFree: tags.contains('dairy free') || tags.contains('dairy-free'),
      isVeryHealthy: ['vegetarian', 'vegan', 'seafood'].contains(category) ||
          tags.contains('healthy'),
      isPopular: tags.contains('popular'),
    );
  }

  static Future<Recipe> _fetchRandom() async {
    final response = await http.get(Uri.parse('$_baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final meal = data['meals'][0];
      return _recipeFromMealDb(meal);
    }
    throw Exception('Failed to fetch recipe: ${response.statusCode}');
  }

  static Future<List<Recipe>> getRecipes() async {
    return Future.wait(List.generate(5, (_) => _fetchRandom()));
  }

  static Future<List<Recipe>> getRecipesByTag(String tag) async {
    final category = _tagToCategory[tag.toLowerCase()];
    if (category == null) return getRecipes();

    try {
      final filterResponse = await http.get(
        Uri.parse('$_baseUrl/filter.php?c=$category'),
      );
      if (filterResponse.statusCode != 200) return getRecipes();

      final meals =
          (jsonDecode(filterResponse.body)['meals'] as List?) ?? [];
      if (meals.isEmpty) return getRecipes();

      final shuffled = List.of(meals)..shuffle(Random());
      final selected = shuffled.take(5).toList();

      return Future.wait(selected.map((meal) async {
        final resp = await http.get(
          Uri.parse('$_baseUrl/lookup.php?i=${meal['idMeal']}'),
        );
        if (resp.statusCode == 200) {
          return _recipeFromMealDb(jsonDecode(resp.body)['meals'][0]);
        }
        return _fetchRandom();
      }));
    } catch (_) {
      return getRecipes();
    }
  }

  static Future<List<Recipe>> extractFromUrl(String url) async {
    throw Exception(
        'URL recipe extraction is not available with the current recipe provider.');
  }

  static Future<Nutrition> nutritionById(int id) async {
    return Nutrition(calories: '—', carbs: '—', fat: '—', protein: '—');
  }
}
