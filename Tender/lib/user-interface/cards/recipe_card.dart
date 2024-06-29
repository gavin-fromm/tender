import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:food_for_thought/classes/nutrition_class.dart';
import '../../back-end/api_config.dart';

const _red = Color(0xFFE8120C);
const _textPrimary = Color(0xFF1C1917);
const _bg = Color(0xFFFAF9F6);
const _border = Color(0xFFE7E5E4);

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
      front: _buildFront(context),
      back: _buildBack(context),
    );
  }

  Widget _buildFront(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 1),
      width: MediaQuery.of(context).size.width,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            offset: const Offset(0, 14),
            blurRadius: 28,
            spreadRadius: -6,
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(widget.thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.38, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.30),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.88),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Diet pills at top
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (widget.isVegetarian)
                      _dietPill(Icons.eco_rounded, 'Vegetarian', const Color(0xFF16A34A)),
                    if (widget.isVegan)
                      _dietPill(Icons.spa_rounded, 'Vegan', const Color(0xFF16A34A)),
                    if (widget.isVeryHealthy)
                      _dietPill(Icons.favorite_rounded, 'Healthy', _red),
                    if (widget.isPopular)
                      _dietPill(Icons.star_rounded, 'Popular', const Color(0xFFF59E0B)),
                    if (widget.isDairyFree)
                      _dietPill(Icons.no_drinks_rounded, 'Dairy Free', const Color(0xFF3B82F6)),
                    if (widget.isGlutenFree)
                      _dietPill(Icons.grass_rounded, 'Gluten Free', const Color(0xFFF97316)),
                  ],
                ),
              ),
              // Bottom section: title + info bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 12),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _infoChip(Icons.person_outline_rounded, 'Serves ${widget.servings}'),
                          const SizedBox(width: 8),
                          _nutritionChip(context),
                          const SizedBox(width: 8),
                          _infoChip(Icons.schedule_rounded, '${widget.cookTime} min'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 1),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            offset: const Offset(0, 10),
            blurRadius: 24,
            spreadRadius: -6,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image + title
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.thumbnailUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.45),
                          BlendMode.multiply,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 18,
                  right: 18,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Servings control
                  _sectionHeader('Servings'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          controller: servingsController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.people_outline_rounded),
                            hintText: 'Servings',
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          final desired = int.tryParse(servingsController.text);
                          if (desired != null && desired > 0) {
                            setState(() => recipeYieldModifier = desired / widget.servings);
                          }
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quick-scale buttons
                  Row(
                    children: [
                      _scaleButton('Default', () => setState(() => recipeYieldModifier = 1)),
                      const SizedBox(width: 8),
                      _scaleButton('Double ×2', () => setState(() => recipeYieldModifier = 2)),
                      const SizedBox(width: 8),
                      _scaleButton('Triple ×3', () => setState(() => recipeYieldModifier = 3)),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _sectionHeader('Ingredients'),
                  const SizedBox(height: 12),
                  ...List.generate(widget.ingredients.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 10, top: 1),
                            decoration: BoxDecoration(
                              color: _red.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  fontFamily: 'Oswald',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: _red,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.ingredients[i]}',
                              style: const TextStyle(
                                fontFamily: 'Oswald',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: _textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),
                  _sectionHeader('Preparation'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: HtmlWidget(widget.preparationSteps),
                  ),

                  const SizedBox(height: 24),
                  _sectionHeader('Dietary Info'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (widget.isVegetarian)
                        _dietPill(Icons.eco_rounded, 'Vegetarian', const Color(0xFF16A34A)),
                      if (widget.isVegan)
                        _dietPill(Icons.spa_rounded, 'Vegan', const Color(0xFF16A34A)),
                      if (widget.isDairyFree)
                        _dietPill(Icons.no_drinks_rounded, 'Dairy Free', const Color(0xFF3B82F6)),
                      if (widget.isGlutenFree)
                        _dietPill(Icons.grass_rounded, 'Gluten Free', const Color(0xFFF97316)),
                      if (widget.isVeryHealthy)
                        _dietPill(Icons.favorite_rounded, 'Healthy', _red),
                      if (widget.isPopular)
                        _dietPill(Icons.star_rounded, 'Popular', const Color(0xFFF59E0B)),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: _red, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Oswald',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _scaleButton(String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _border),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Oswald',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dietPill(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Oswald',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Oswald',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutritionChip(BuildContext context) {
    return GestureDetector(
      onTap: () => showNutrition(context, widget.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _red.withValues(alpha: 0.90),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _red.withValues(alpha: 0.40),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(
              'Nutrition',
              style: TextStyle(
                fontFamily: 'Oswald',
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showNutrition(BuildContext context, int id) async {
    final Nutrition nutrition = await RecipeApi.nutritionById(id);
    if (!context.mounted) return;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          title: const Text(
            'Nutrition Facts',
            style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w700, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _nutritionTile('Calories', nutrition.calories, const Color(0xFFE8120C)),
                  const SizedBox(width: 10),
                  _nutritionTile('Carbs', nutrition.carbs, const Color(0xFF3B82F6)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _nutritionTile('Fat', nutrition.fat, const Color(0xFFF59E0B)),
                  const SizedBox(width: 10),
                  _nutritionTile('Protein', nutrition.protein, const Color(0xFF16A34A)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _nutritionTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.20)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
