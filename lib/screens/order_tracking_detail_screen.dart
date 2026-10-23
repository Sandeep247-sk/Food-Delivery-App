import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrderTrackingDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingDetailScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderTrackingDetailScreen> createState() =>
      _OrderTrackingDetailScreenState();
}

class _OrderTrackingDetailScreenState extends State<OrderTrackingDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _currentStepIndex = 1; // Default to Cooking / Preparing

  final List<Map<String, dynamic>> _trackingSteps = [
    {
      'title': 'Order Placed & Confirmed',
      'subtitle': 'Restaurant accepted your order',
      'icon': Icons.check_circle_rounded,
      'time': '8:01 PM',
    },
    {
      'title': 'Preparing in Kitchen',
      'subtitle': 'Chef is crafting your delicious meal',
      'icon': Icons.soup_kitchen_rounded,
      'time': '8:04 PM',
    },
    {
      'title': 'Valet Picked Up Order',
      'subtitle': 'Ramesh is on his way on his scooter',
      'icon': Icons.two_wheeler_rounded,
      'time': 'Estimated 8:18 PM',
    },
    {
      'title': 'Arrived at Your Doorstep',
      'subtitle': 'Enjoy your hot meal!',
      'icon': Icons.home_rounded,
      'time': 'Estimated 8:25 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Map order status to step
    if (widget.order.status == OrderStatus.placed) _currentStepIndex = 0;
    if (widget.order.status == OrderStatus.preparing) _currentStepIndex = 1;
    if (widget.order.status == OrderStatus.onTheWay) _currentStepIndex = 2;
    if (widget.order.status == OrderStatus.delivered) _currentStepIndex = 3;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Order Tracking • ${widget.order.id}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Savoria Gourmet Bistro',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Support',
            icon: const Icon(Icons.help_outline_rounded,
                color: AppTheme.primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connecting to Swiggy 24/7 Live Support Chat...'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ETA Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF282C3F), // Swiggy Dark Blue Header
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESTIMATED DELIVERY TIME',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              '18-22 MINS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FadeTransition(
                              opacity: _pulseController,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.vegGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'ON TIME',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Arriving at Work • 742 Evergreen Terrace',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF3D4152),
                    child: Icon(
                      Icons.delivery_dining_rounded,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Simulated Live Route Map View Card
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Map Background Styling Simulation
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: const Color(0xFFE5E3DF),
                        child: CustomPaint(
                          painter: MapPathPainter(),
                        ),
                      ),
                    ),
                  ),

                  // Restaurant Pin
                  Positioned(
                    left: 40,
                    top: 50,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.primaryColor,
                          child: const Icon(Icons.restaurant,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4)
                            ],
                          ),
                          child: const Text(
                            'Savoria Bistro',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Delivery Rider Scooter Animation Simulation
                  Positioned(
                    left: 150,
                    top: 85,
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: Tween(begin: 0.9, end: 1.1)
                              .animate(_pulseController),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.vegGreen,
                            child: const Icon(Icons.two_wheeler,
                                color: Colors.white, size: 22),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4)
                            ],
                          ),
                          child: const Text(
                            'Ramesh (Rider)',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Customer Home Pin
                  Positioned(
                    right: 40,
                    bottom: 40,
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueAccent,
                          child:
                              Icon(Icons.home, color: Colors.white, size: 18),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4)
                            ],
                          ),
                          child: const Text(
                            'Your Location',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Delivery Partner / Valet Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Ramesh Kumar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.verified,
                                    color: Colors.blue, size: 16),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Delivery Partner • KA 05 EQ 8821',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    size: 14, color: Colors.amber),
                                Text(
                                  ' 4.9 (1,420 deliveries)',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons (Call / Message)
                      Row(
                        children: [
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  AppTheme.vegGreen.withValues(alpha: 0.15),
                            ),
                            icon: const Icon(Icons.phone,
                                color: AppTheme.vegGreen),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Calling Ramesh Kumar...')),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor
                                  .withValues(alpha: 0.15),
                            ),
                            icon: const Icon(Icons.message_rounded,
                                color: AppTheme.primaryColor),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Opening chat with Ramesh Kumar...')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Order Step Tracker Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Status Timeline',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _trackingSteps.length,
                        itemBuilder: (ctx, index) {
                          final step = _trackingSteps[index];
                          final isCompleted = index <= _currentStepIndex;
                          final isCurrent = index == _currentStepIndex;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Step Circle Icon & Connecting Line
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isCompleted
                                        ? AppTheme.vegGreen
                                        : Colors.grey.shade300,
                                    child: Icon(
                                      step['icon'] as IconData,
                                      size: 16,
                                      color: isCompleted
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  if (index < _trackingSteps.length - 1)
                                    Container(
                                      width: 2,
                                      height: 36,
                                      color: index < _currentStepIndex
                                          ? AppTheme.vegGreen
                                          : Colors.grey.shade300,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 14),

                              // Step Title & Subtitle
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            step['title'] as String,
                                            style: TextStyle(
                                              fontWeight: isCurrent ||
                                                      isCompleted
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isCurrent
                                                  ? AppTheme.primaryColor
                                                  : isCompleted
                                                      ? theme.textTheme
                                                          .bodyLarge?.color
                                                      : Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            step['time'] as String,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        step['subtitle'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isCurrent
                                              ? Colors.black87
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Order Items Summary Accordion Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ExpansionTile(
                  title: Text(
                    'Order Items (${widget.order.items.length})',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Text('Total Paid: \$${widget.order.total.toStringAsFixed(2)}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: widget.order.items.map((cartItem) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${cartItem.quantity}x ${cartItem.item.name}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to draw road path on simulated map background
class MapPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintPath = Paint()
      ..color = AppTheme.vegGreen
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(40, 50);
    path.cubicTo(100, 50, 120, 120, 180, 120);
    path.cubicTo(240, 120, 260, 150, size.width - 40, size.height - 40);

    canvas.drawPath(path, paintRoad);
    canvas.drawPath(path, paintPath);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
