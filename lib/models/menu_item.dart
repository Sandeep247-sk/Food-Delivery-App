import 'customization_option.dart';
import 'review.dart';

class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String categoryId;
  final String imageUrl;
  final int calories;
  final String prepTime;
  final String distance;
  final bool isPopular;
  final bool isVeg;
  final String restaurantName;
  final String offerTag;
  final List<String> ingredients;
  final List<FoodSizeOption> sizes;
  final List<FoodToppingOption> toppings;
  final List<ReviewModel> reviews;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.categoryId,
    required this.imageUrl,
    required this.calories,
    required this.prepTime,
    this.distance = '2.2 km',
    this.isPopular = false,
    this.isVeg = false,
    this.restaurantName = 'Savoria Gourmet Bistro',
    this.offerTag = '50% OFF UP TO ₹100',
    this.ingredients = const [],
    this.sizes = const [
      FoodSizeOption(name: 'Regular', extraPrice: 0.0),
      FoodSizeOption(name: 'Large', extraPrice: 2.50),
    ],
    this.toppings = const [],
    this.reviews = const [],
  });
}
