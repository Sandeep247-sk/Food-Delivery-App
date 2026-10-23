import 'package:flutter/material.dart';
import '../models/customization_option.dart';
import '../models/menu_item.dart';
import '../models/review.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/safe_image.dart';
import '../widgets/veg_nonveg_badge.dart';

class ItemDetailScreen extends StatefulWidget {
  final MenuItemModel item;
  final AppState appState;

  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.appState,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;
  late FoodSizeOption _selectedSize;
  final Set<FoodToppingOption> _selectedToppings = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.item.sizes.isNotEmpty
        ? widget.item.sizes.first
        : const FoodSizeOption(name: 'Regular', extraPrice: 0.0);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _calculatedUnitPrice {
    double total = widget.item.price + _selectedSize.extraPrice;
    for (var topping in _selectedToppings) {
      total += topping.price;
    }
    return total;
  }

  double get _totalPrice => _calculatedUnitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFav = widget.appState.isFavorite(widget.item.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () {
                    widget.appState.toggleFavorite(widget.item.id);
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'food-img-${widget.item.id}',
                child: SafeImageNetwork(
                  imageUrl: widget.item.imageUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Veg/Non-Veg Badge + Title & Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      VegNonVegBadge(isVeg: widget.item.isVeg, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${_calculatedUnitPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Text(
                    widget.item.restaurantName,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  // Ratings & Specs Bar
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.vegGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.item.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${widget.item.reviewCount} ratings)',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      _buildInfoBadge(
                        icon: Icons.timer,
                        text: widget.item.prepTime,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoBadge(
                        icon: Icons.local_fire_department,
                        text: '${widget.item.calories} kcal',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Portion Size Customization
                  if (widget.item.sizes.isNotEmpty) ...[
                    const Text(
                      'Customise Portion Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: widget.item.sizes.map((sizeOpt) {
                        final isSelected = _selectedSize.name == sizeOpt.name;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor.withValues(alpha: 0.08)
                                : theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                            ),
                            title: Text(
                              sizeOpt.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: sizeOpt.extraPrice > 0
                                ? Text('+ \$${sizeOpt.extraPrice.toStringAsFixed(2)}')
                                : const Text('Standard Size'),
                            onTap: () {
                              setState(() => _selectedSize = sizeOpt);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Extra Toppings Customization
                  if (widget.item.toppings.isNotEmpty) ...[
                    const Text(
                      'Add Extra Add-ons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: widget.item.toppings.map((topping) {
                        final isChecked = _selectedToppings.contains(topping);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: CheckboxListTile(
                            title: Text(topping.name,
                                style: const TextStyle(fontSize: 14)),
                            subtitle: Text('+ \$${topping.price.toStringAsFixed(2)}'),
                            value: isChecked,
                            activeColor: AppTheme.vegGreen,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedToppings.add(topping);
                                } else {
                                  _selectedToppings.remove(topping);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Ingredients List
                  if (widget.item.ingredients.isNotEmpty) ...[
                    const Text(
                      'Key Ingredients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.item.ingredients.map((ing) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(ing, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Customer Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showAddReviewDialog(context),
                        icon: const Icon(Icons.rate_review_outlined, size: 16),
                        label: const Text('Write Review'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (widget.item.reviews.isEmpty)
                    const Text('No reviews yet. Be the first to review!',
                        style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: widget.item.reviews.map((rev) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppTheme.primaryColor,
                                    child: Text(
                                      rev.userName[0],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    rev.userName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 14, color: Colors.amber),
                                      Text(
                                        ' ${rev.rating}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(rev.comment,
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Swiggy Sticky Bottom Add Bar
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL PRICE',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.vegGreen, // Swiggy Green Add
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    String finalNotes = _notesController.text;
                    if (_selectedSize.name != 'Regular') {
                      finalNotes = '[${_selectedSize.name}] $finalNotes';
                    }
                    if (_selectedToppings.isNotEmpty) {
                      final notesAddons = _selectedToppings
                          .map((t) => t.name)
                          .join(', ');
                      finalNotes = '$finalNotes (Addons: $notesAddons)';
                    }

                    widget.appState.addToCart(
                      widget.item,
                      quantity: _quantity,
                      specialInstructions: finalNotes,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added ${_quantity}x ${widget.item.name} to cart!',
                        ),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'VIEW CART',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('ADD ITEM TO CART'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Rating (1 to 5 Stars)'),
            StatefulBuilder(
              builder: (context, setDialogState) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 28,
                    ),
                    onPressed: () {
                      setDialogState(() => rating = index + 1.0);
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share your experience with this dish...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('Submit Review'),
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                final rev = ReviewModel(
                  id: 'r-${DateTime.now().millisecondsSinceEpoch}',
                  userName: widget.appState.userName,
                  rating: rating,
                  comment: commentController.text,
                  date: 'Just now',
                );
                widget.appState.addReview(widget.item.id, rev);
                setState(() {});
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your review!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
