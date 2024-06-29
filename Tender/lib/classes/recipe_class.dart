class Recipe {
  final int id;
  final String name;
  final int servings;
  final List<dynamic> ingredients;
  final String preparationSteps;
  final String images;
  final int totalTime;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isDairyFree;
  final bool isVeryHealthy;
  final bool isPopular;

  Recipe({
    required this.id,
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.preparationSteps,
    required this.images,
    required this.totalTime,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    required this.isDairyFree,
    required this.isVeryHealthy,
    required this.isPopular,
  });

  factory Recipe.fromJson(dynamic json) {
    if (json['id'] != null &&
        json['title'] != null &&
        json['servings'] != null &&
        json['instructions'] != null &&
        json['image'] != null &&
        json['readyInMinutes'] != null &&
        json['vegetarian'] != null &&
        json['glutenFree'] != null &&
        json['dairyFree'] != null &&
        json['veryHealthy'] != null &&
        json['veryPopular'] != null) {
      return Recipe(
        id: json['id'],
        name: json['title'] as String,
        servings: json['servings'],
        ingredients: json['extendedIngredients'],
        preparationSteps: json['instructions'] as String,
        images: json['image'] as String,
        totalTime: json['readyInMinutes'],
        isVegetarian: json['vegetarian'],
        isVegan: json['vegan'],
        isGlutenFree: json['glutenFree'],
        isDairyFree: json['dairyFree'],
        isVeryHealthy: json['veryHealthy'],
        isPopular: json['veryPopular'],
      );
    } else {
      throw Exception('Error creating recipe from JSON');
    }
  }

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      id: (data['id'] as num).toInt(),
      name: data['title'] as String? ?? '',
      servings: (data['servings'] as num?)?.toInt() ?? 0,
      ingredients: data['ingredients'] as List<dynamic>? ?? [],
      preparationSteps: data['preparation_steps'] as String? ?? '',
      images: data['thumbnail_url'] as String? ?? '',
      totalTime: (data['cook_time'] as num?)?.toInt() ?? 0,
      isVegetarian: data['is_vegetarian'] as bool? ?? false,
      isVegan: data['is_vegan'] as bool? ?? false,
      isGlutenFree: data['is_gluten_free'] as bool? ?? false,
      isDairyFree: data['is_dairy_free'] as bool? ?? false,
      isVeryHealthy: data['is_very_healthy'] as bool? ?? false,
      isPopular: data['is_popular'] as bool? ?? false,
    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }
}
