import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import 'safe_image.dart';
import 'veg_nonveg_badge.dart';

class FoodCard extends StatelessWidget {
  final MenuItemModel menuItem;
  final bool isFavorite;
  final int cartQuantity;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddToCartTap;
  final Function(int delta)? onUpdateQuantity;

  const FoodCard({
    super.key,
    required this.menuItem,
    required this.isFavorite,
    this.cartQuantity = 0,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddToCartTap,
    this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Swiggy Offer Badge Overlay
            Stack(
              children: [
                Hero(
                  tag: 'food-img-${menuItem.id}',
                  child: SafeImageNetwork(
                    imageUrl: menuItem.imageUrl,
                    height: 135,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Gradient Overlay for bottom text readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ),

                // Swiggy Offer Tag Text Overlay
                Positioned(
                  bottom: 6,
                  left: 8,
                  child: Text(
                    menuItem.offerTag.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 4),
                      ],
                    ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black38,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onFavoriteTap,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Item Details Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Veg / Non-Veg + Restaurant
                        Row(
                          children: [
                            VegNonVegBadge(isVeg: menuItem.isVeg, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                menuItem.restaurantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Title
                        Text(
                          menuItem.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Rating Pill & Time
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.vegGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star,
                                      size: 11, color: Colors.white),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${menuItem.rating}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${menuItem.prepTime}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Price & Swiggy ADD Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${menuItem.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Swiggy Iconic ADD Button / Stepper
                        cartQuantity == 0
                            ? Material(
                                color: Colors.white,
                                elevation: 2,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: onAddToCartTap,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.vegGreen,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Text(
                                      'ADD',
                                      style: TextStyle(
                                        color: AppTheme.vegGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.vegGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => onUpdateQuantity?.call(-1),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Icon(Icons.remove,
                                            size: 16, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      '$cartQuantity',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => onUpdateQuantity?.call(1),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Icon(Icons.add,
                                            size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
