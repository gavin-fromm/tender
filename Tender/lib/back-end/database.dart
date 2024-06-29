import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/classes/user_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../classes/created_recipe_class.dart';
import '../classes/public_created_recipe_class.dart';

class DatabaseService {
  static SupabaseClient get _db => Supabase.instance.client;

  static String _recipeTable(String path) {
    if (path == 'saved recipes') return 'user_saved_recipes';
    if (path == 'pinned recipes') return 'user_pinned_recipes';
    throw Exception('Unknown recipe path: $path');
  }

  static String _toSnakeCase(String camel) {
    switch (camel) {
      case 'isVegan':
        return 'is_vegan';
      case 'isVegetarian':
        return 'is_vegetarian';
      case 'isGlutenFree':
        return 'is_gluten_free';
      case 'isDairyFree':
        return 'is_dairy_free';
      case 'isVeryHealthy':
      case 'isVeryHealty':
        return 'is_very_healthy';
      case 'isPopular':
        return 'is_popular';
      default:
        return camel;
    }
  }

  static Future<List<Recipe>> getRecipes(String uid, String path) async {
    final table = _recipeTable(path);
    final data = await _db
        .from(table)
        .select('recipes(*)')
        .eq('user_id', uid);
    return data
        .map((row) => Recipe.fromMap(row['recipes'] as Map<String, dynamic>))
        .toList();
  }

  static Future<List<PublicCreatedRecipe>> getPublicCreatedRecipes(
      String uid, String path) async {
    final data = await _db
        .from('user_liked_created_recipes')
        .select('verified_recipes(*)')
        .eq('user_id', uid);
    return data
        .map((row) =>
            PublicCreatedRecipe.fromMap(row['verified_recipes'] as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Recipe>> getStoredRecipes() async {
    final data = await _db.from('recipes').select();
    return data.map((row) => Recipe.fromMap(row)).toList();
  }

  static Future<List<Recipe>> recommendRecipes(String filter) async {
    final col = _toSnakeCase(filter);
    final data = await _db
        .from('recipes')
        .select()
        .eq(col, true)
        .eq('is_popular', true);
    return data.map((row) => Recipe.fromMap(row)).toList();
  }

  static Future<List<CreatedRecipe>> getCreatedRecipes(String uid) async {
    final data = await _db
        .from('created_recipes')
        .select()
        .eq('user_id', uid);
    return data.map((row) => CreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<PublicCreatedRecipe>>
      getCreatedRecipesForVerification() async {
    final data = await _db.from('public_pending_recipes').select();
    return data.map((row) => PublicCreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<PublicCreatedRecipe>> getVerifiedCreatedRecipes() async {
    final data = await _db.from('verified_recipes').select();
    return data.map((row) => PublicCreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<PublicCreatedRecipe>> getMyVerifiedCreatedRecipes(
      String userId) async {
    final data = await _db
        .from('verified_recipes')
        .select()
        .eq('user_id', userId);
    return data.map((row) => PublicCreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<PublicCreatedRecipe>> getMyCreatedRecipesForVerification(
      String userId) async {
    final data = await _db
        .from('public_pending_recipes')
        .select()
        .eq('user_id', userId);
    return data.map((row) => PublicCreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<Recipe>> sortByAlpha(String uid, String path) async {
    final recipes = await getRecipes(uid, path);
    recipes.sort((a, b) => a.name.compareTo(b.name));
    return recipes;
  }

  static Future<List<Recipe>> sortByAlphaDescending(
      String uid, String path) async {
    final recipes = await getRecipes(uid, path);
    recipes.sort((a, b) => b.name.compareTo(a.name));
    return recipes;
  }

  static Future<List<Recipe>> sortByTime(String uid, String path) async {
    final recipes = await getRecipes(uid, path);
    recipes.sort((a, b) => a.totalTime.compareTo(b.totalTime));
    return recipes;
  }

  static Future<List<Recipe>> sortByTimeDescending(
      String uid, String path) async {
    final recipes = await getRecipes(uid, path);
    recipes.sort((a, b) => b.totalTime.compareTo(a.totalTime));
    return recipes;
  }

  static Future<List<Recipe>> sortByServings(String uid, String path) async {
    final recipes = await getRecipes(uid, path);
    recipes.sort((a, b) => a.servings.compareTo(b.servings));
    return recipes;
  }

  static Future<List<Recipe>> filterBy(
      String uid, String path, String filter) async {
    final recipes = await getRecipes(uid, path);
    return recipes.where((r) {
      switch (filter) {
        case 'isVegan':
          return r.isVegan;
        case 'isVegetarian':
          return r.isVegetarian;
        case 'isGlutenFree':
          return r.isGlutenFree;
        case 'isDairyFree':
          return r.isDairyFree;
        case 'isPopular':
          return r.isPopular;
        case 'isVeryHealty':
        case 'isVeryHealthy':
          return r.isVeryHealthy;
        default:
          return false;
      }
    }).toList();
  }

  static Future<List<Recipe>> searchRecipes(
      String uid, String search, String path) async {
    final recipes = await getRecipes(uid, path);
    final q = search.toLowerCase();
    return recipes.where((r) => r.name.toLowerCase().contains(q)).toList();
  }

  static Future<UserInformation> getUser(String uid) async {
    final data = await _db
        .from('profiles')
        .select()
        .eq('id', uid)
        .single();
    return UserInformation.fromMap(data);
  }

  static Future<String> getUsersName(String uid) async {
    final data = await _db
        .from('profiles')
        .select('user_name')
        .eq('id', uid)
        .single();
    return data['user_name'] as String? ?? '';
  }

  static Future<List<UserInformation>> getAllUsers() async {
    final data = await _db.from('profiles').select();
    return data.map((row) => UserInformation.fromMap(row)).toList();
  }

  static Future<int> countUsers() async {
    final data = await _db.from('profiles').select('id');
    return data.length;
  }

  static Future<int> countRecipes() async {
    final data = await _db.from('recipes').select('id');
    return data.length;
  }

  static Future<List<CreatedRecipe>> sortByAlphaCreatedRecipe(
      String uid, String path) async {
    final data = await _db
        .from('created_recipes')
        .select()
        .eq('user_id', uid)
        .order('title', ascending: true);
    return data.map((row) => CreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<CreatedRecipe>> sortByTimeCreatedRecipe(
      String uid, String path) async {
    final data = await _db
        .from('created_recipes')
        .select()
        .eq('user_id', uid)
        .order('cook_time', ascending: false);
    return data.map((row) => CreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<CreatedRecipe>> sortByServingsCreatedRecipe(
      String uid, String path) async {
    final data = await _db
        .from('created_recipes')
        .select()
        .eq('user_id', uid)
        .order('servings', ascending: true);
    return data.map((row) => CreatedRecipe.fromMap(row)).toList();
  }

  static Future<List<CreatedRecipe>> searchRecipesCreatedRecipe(
      String uid, String search, String path) async {
    final all = await getCreatedRecipes(uid);
    final q = search.toLowerCase();
    return all.where((r) => r.name.toLowerCase().contains(q)).toList();
  }

  static Future<void> upsertRecipe(Recipe recipe) async {
    await _db.from('recipes').upsert({
      'id': recipe.id,
      'title': recipe.name,
      'servings': recipe.servings,
      'ingredients': recipe.ingredients,
      'preparation_steps': recipe.preparationSteps,
      'thumbnail_url': recipe.images,
      'cook_time': recipe.totalTime,
      'is_vegetarian': recipe.isVegetarian,
      'is_vegan': recipe.isVegan,
      'is_gluten_free': recipe.isGlutenFree,
      'is_dairy_free': recipe.isDairyFree,
      'is_very_healthy': recipe.isVeryHealthy,
      'is_popular': recipe.isPopular,
    });
  }

  static Future<void> saveRecipe(String uid, Recipe recipe) async {
    await upsertRecipe(recipe);
    await _db.from('user_saved_recipes').upsert({
      'user_id': uid,
      'recipe_id': recipe.id,
    });
  }

  static Future<void> pinRecipe(String uid, Recipe recipe) async {
    await upsertRecipe(recipe);
    await _db.from('user_pinned_recipes').upsert({
      'user_id': uid,
      'recipe_id': recipe.id,
    });
  }

  static Future<void> unsaveRecipe(String uid, int recipeId) async {
    await _db
        .from('user_saved_recipes')
        .delete()
        .eq('user_id', uid)
        .eq('recipe_id', recipeId);
  }

  static Future<void> unpinRecipe(String uid, int recipeId) async {
    await _db
        .from('user_pinned_recipes')
        .delete()
        .eq('user_id', uid)
        .eq('recipe_id', recipeId);
  }

  static Future<void> likePublicRecipe(String uid, String recipeId) async {
    await _db.from('user_liked_created_recipes').upsert({
      'user_id': uid,
      'recipe_id': recipeId,
    });
  }

  static Future<void> approveRecipe(PublicCreatedRecipe recipe) async {
    await _db.from('verified_recipes').insert({
      'title': recipe.name,
      'servings': recipe.servings,
      'ingredients': recipe.ingredients,
      'cook_instructions': recipe.cookInstructions,
      'thumbnail_url': recipe.image,
      'cook_time': recipe.totalTime,
      'user_id': recipe.userId,
    });
    if (recipe.id != null) {
      await _db.from('public_pending_recipes').delete().eq('id', recipe.id!);
    }
  }

  static Future<void> denyRecipe(String id) async {
    await _db.from('public_pending_recipes').delete().eq('id', id);
  }
}
