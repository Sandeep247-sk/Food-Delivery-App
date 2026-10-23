class FoodSizeOption {
  final String name;
  final double extraPrice;

  const FoodSizeOption({
    required this.name,
    this.extraPrice = 0.0,
  });
}

class FoodToppingOption {
  final String id;
  final String name;
  final double price;

  const FoodToppingOption({
    required this.id,
    required this.name,
    required this.price,
  });
}
