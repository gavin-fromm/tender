import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatedRecipe {
  final String name;
  final String servings;
  final List<dynamic> ingredients;
  final String cookInstructions;
  final String image;
  final String totalTime;

  CreatedRecipe({
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.cookInstructions,
    required this.image,
    required this.totalTime,
  });

  factory CreatedRecipe.fromMap(Map<String, dynamic> data) {
    return CreatedRecipe(
      name: data['title'] as String? ?? '',
      servings: data['servings'] as String? ?? '',
      ingredients: data['ingredients'] as List<dynamic>? ?? [],
      cookInstructions: data['cook_instructions'] as String? ?? '',
      image: data['thumbnail_url'] as String? ?? '',
      totalTime: data['cook_time'] as String? ?? '',
    );
  }
}

mixin CreatedRecipeMixin {
  User? get _currentUser => Supabase.instance.client.auth.currentUser;

  Future<bool> publicVerifiedRecipeExists(
      String recipeName, String userId) async {
    final data = await Supabase.instance.client
        .from('verified_recipes')
        .select('id')
        .eq('user_id', userId)
        .eq('title', recipeName);
    return data.isNotEmpty;
  }

  Future<String> getImageUrl(String recipeName) async {
    if (_currentUser == null) throw Exception("User not logged in");
    final data = await Supabase.instance.client
        .from('created_recipes')
        .select('thumbnail_url')
        .eq('user_id', _currentUser!.id)
        .eq('title', recipeName)
        .single();
    return data['thumbnail_url'] as String;
  }

  Future<String> uploadImage({
    required XFile? image,
    required String recipeName,
  }) async {
    if (_currentUser == null) throw Exception("User not logged in");
    if (image == null) throw Exception("Image file is null");

    final bytes = await File(image.path).readAsBytes();
    final path = '${_currentUser!.id}/$recipeName';

    await Supabase.instance.client.storage.from('recipe-images').uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return Supabase.instance.client.storage
        .from('recipe-images')
        .getPublicUrl(path);
  }

  Future<void> uploadRecipe({
    required Map<String, dynamic> recipeData,
    required String name,
  }) async {
    if (_currentUser == null) throw Exception("User not logged in");

    await Supabase.instance.client.from('created_recipes').upsert({
      'user_id': _currentUser!.id,
      'title': recipeData['title'] ?? name,
      'servings': recipeData['servings'],
      'ingredients': recipeData['ingredients'],
      'cook_instructions': recipeData['cookInstructions'],
      'thumbnail_url': recipeData['thumbnailUrl'],
      'cook_time': recipeData['cookTime'],
    });
  }

  Future<void> uploadPublicRecipe({
    required Map<String, dynamic> recipeData,
    required String name,
  }) async {
    if (_currentUser == null) throw Exception("User not logged in");

    await Supabase.instance.client.from('public_pending_recipes').upsert({
      'user_id': _currentUser!.id,
      'title': recipeData['title'] ?? name,
      'servings': recipeData['servings'],
      'ingredients': recipeData['ingredients'],
      'cook_instructions': recipeData['cookInstructions'],
      'thumbnail_url': recipeData['thumbnailUrl'],
      'cook_time': recipeData['cookTime'],
    });
  }

  Future<void> deleteImageByUrl(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final parts = uri.path.split('/recipe-images/');
      if (parts.length < 2) return;
      final storagePath = parts[1];
      await Supabase.instance.client.storage
          .from('recipe-images')
          .remove([storagePath]);
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  Future<void> deletePrivateRecipe(
      {required String recipeName}) async {
    if (_currentUser == null) return;
    await Supabase.instance.client
        .from('created_recipes')
        .delete()
        .eq('user_id', _currentUser!.id)
        .eq('title', recipeName);
  }

  Future<void> deletePublicUnverifiedRecipe(
      String recipeName, String userId) async {
    await Supabase.instance.client
        .from('public_pending_recipes')
        .delete()
        .eq('user_id', userId)
        .eq('title', recipeName);
  }

  Future<void> deletePublicVerifiedRecipe(
      String recipeName, String userId) async {
    await Supabase.instance.client
        .from('verified_recipes')
        .delete()
        .eq('user_id', userId)
        .eq('title', recipeName);
  }
}
