import 'package:flutter/material.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/home/data/models/meal_summary_model.dart';

class FavoriteMealCard extends StatelessWidget {
  const FavoriteMealCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onRemoveFavorite,
  });

  final MealSummaryModel meal;
  final VoidCallback onTap;
  final VoidCallback onRemoveFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: AppColor.secondary,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Hero(
                    tag: 'fav_${meal.id}',
                    child: Image.network(
                      meal.thumb,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColor.primary,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 40,
                            color: AppColor.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onRemoveFavorite,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AppColor.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            meal.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: AppColor.textSecondary,
              ),
              SizedBox(width: 4),
              Text(
                '25 min',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
