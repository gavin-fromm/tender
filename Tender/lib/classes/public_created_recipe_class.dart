class PublicCreatedRecipe {
  final String? id;
  final String name;
  final String servings;
  final List<dynamic> ingredients;
  final String cookInstructions;
  final String image;
  final String totalTime;
  final String userId;

  PublicCreatedRecipe({
    this.id,
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.cookInstructions,
    required this.image,
    required this.totalTime,
    required this.userId,
  });

  factory PublicCreatedRecipe.fromMap(Map<String, dynamic> data) {
    return PublicCreatedRecipe(
      id: data['id'] as String?,
      name: data['title'] as String? ?? '',
      servings: data['servings'] as String? ?? '',
      ingredients: data['ingredients'] as List<dynamic>? ?? [],
      cookInstructions: data['cook_instructions'] as String? ?? '',
      image: data['thumbnail_url'] as String? ?? '',
      totalTime: data['cook_time'] as String? ?? '',
      userId: data['user_id'] as String? ?? '',
    );
  }
}
