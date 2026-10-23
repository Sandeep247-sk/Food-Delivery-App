import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/veg_nonveg_badge.dart';
import 'order_tracking_detail_screen.dart';

class CartScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onOrderPlaced;

  const CartScreen({
    super.key,
    required this.appState,
    required this.onOrderPlaced,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  bool _isPromoApplied = false;
  double _promoDiscount = 0.0;
  final Set<String> _selectedDeliveryInstructions = {'Leave at door'};

  final List<String> _deliveryInstructionOptions = [
    'Avoid calling',
    'Leave at door',
    'Leave with security',
    'Ring the doorbell'
  ];

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'SWIGGY60' || code == 'SAVOR20') {
      setState(() {
        _isPromoApplied = true;
        _promoDiscount = widget.appState.cartSubtotal * 0.20;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Promo Code Applied! Extra 20% Discount Added')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid promo code. Try SWIGGY60')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = widget.appState.cart;

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 90, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Good food is always waiting for you. Add items from the menu.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: widget.onOrderPlaced,
                child: const Text('BROWSE RESTAURANTS'),
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = widget.appState.cartSubtotal;
    const deliveryFee = 0.00; // Free with Swiggy One!
    final tax = widget.appState.taxAmount;
    final grandTotal =
        (subtotal + deliveryFee + tax - _promoDiscount).clamp(0.0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart • ${widget.appState.cartTotalQuantity} Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Cart?'),
                  content:
                      const Text('Are you sure you want to remove all items?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                    TextButton(
                      child:
                          const Text('Clear', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        widget.appState.clearCart();
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Swiggy One Free Delivery Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.swiggyGold),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt, color: Colors.orange, size: 22),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SWIGGY ONE BENEFIT UNLOCKED',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 0.5,
                            color: Colors.brown,
                          ),
                        ),
                        Text(
                          'You saved \$2.99 on Delivery Fee!',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Address Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on,
                          color: AppTheme.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery to Work',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.appState.userAddress,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Items List
            const Text(
              'Items Selected',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.length,
              separatorBuilder: (ctx, i) => const Divider(height: 20),
              itemBuilder: (ctx, i) {
                final cartItem = cart[i];
                return Row(
                  children: [
                    VegNonVegBadge(isVeg: cartItem.item.isVeg, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${cartItem.item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          if (cartItem.specialInstructions.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              cartItem.specialInstructions,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Swiggy Green Stepper
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.vegGreen, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => widget.appState.updateQuantity(
                                cartItem.item.id, -1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.remove,
                                  size: 14, color: AppTheme.vegGreen),
                            ),
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.vegGreen,
                            ),
                          ),
                          InkWell(
                            onTap: () => widget.appState.updateQuantity(
                                cartItem.item.id, 1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.add,
                                  size: 14, color: AppTheme.vegGreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Delivery Instructions Chips
            const Text(
              'Delivery Instructions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _deliveryInstructionOptions.map((opt) {
                final isSelected = _selectedDeliveryInstructions.contains(opt);
                return FilterChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                  checkmarkColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppTheme.primaryColor : null,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDeliveryInstructions.add(opt);
                      } else {
                        _selectedDeliveryInstructions.remove(opt);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Coupon Code Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: const InputDecoration(
                      hintText: 'Apply Coupon (Try SWIGGY60)',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyPromoCode,
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Swiggy Detailed Bill Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bill Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildBillRow('Item Total', '\$${subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Delivery Fee ', style: TextStyle(fontSize: 13)),
                            Text(
                              '\$2.99',
                              style: TextStyle(
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'FREE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.vegGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildBillRow(
                        'Government Taxes & Charges (8%)', '\$${tax.toStringAsFixed(2)}'),
                    if (_isPromoApplied) ...[
                      const SizedBox(height: 8),
                      _buildBillRow(
                        'Coupon Discount',
                        '-\$${_promoDiscount.toStringAsFixed(2)}',
                        isDiscount: true,
                      ),
                    ],
                    const Divider(height: 24),
                    _buildBillRow(
                      'To Pay',
                      '\$${grandTotal.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // Sticky Checkout Button
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
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.vegGreen, // Swiggy Checkout Green
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                final order = widget.appState.placeOrder(
                  address: widget.appState.userAddress,
                );
                if (order != null) {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.vegGreen,
                            size: 72,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Order Received!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your order ${order.id} is being confirmed by the restaurant.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                widget.onOrderPlaced();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderTrackingDetailScreen(order: order),
                                  ),
                                );
                              },
                              child: const Text('TRACK LIVE ORDER 🛵'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'PAY \$${grandTotal.toStringAsFixed(2)} • PLACE ORDER',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? AppTheme.vegGreen : null,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDiscount ? AppTheme.vegGreen : null,
          ),
        ),
      ],
    );
  }
}
