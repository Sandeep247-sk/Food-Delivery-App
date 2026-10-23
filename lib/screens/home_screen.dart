import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_modal.dart';
import '../widgets/food_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/swiggy_floating_cart_pill.dart';
import 'item_detail_screen.dart';
import 'reservation_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onTapViewCart;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onTapViewCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = appState.filteredMenuItems;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        centerTitle: false,
        title: Row(
          children: [
            Icon(Icons.navigation_rounded,
                size: 20, color: theme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Work',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                  Text(
                    appState.userAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Swiggy One Gold Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, size: 14, color: Colors.black),
                Text(
                  'ONE',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.primaryColor,
            child: const Text(
              'AM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),

      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Search & Filter Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) => appState.setSearchQuery(val),
                          decoration: InputDecoration(
                            hintText: 'Search for "Biryani", "Burger", "Pizza"...',
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppTheme.primaryColor),
                            suffixIcon: appState.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () =>
                                        appState.setSearchQuery(''),
                                  )
                                : const Icon(Icons.mic_none_rounded,
                                    color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Filter Button
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24)),
                            ),
                            builder: (ctx) =>
                                FilterModal(appState: appState),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.tune_rounded,
                              color: AppTheme.primaryColor, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Swiggy Service Grid Cards ("Food", "Instamart", "Dineout", "Genie")
              if (appState.searchQuery.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: MockData.swiggyServices.map((service) {
                            final colorInt = int.parse(service['color']!);
                            return Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Color(colorInt),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      service['icon']!,
                                      style: const TextStyle(fontSize: 26),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      service['title']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      service['subtitle']!,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

              // Swiggy Promo Offer Banners Slider
              if (appState.searchQuery.isEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: PageView.builder(
                          itemCount: MockData.promoBanners.length,
                          itemBuilder: (context, index) {
                            return PromoBanner(
                              banner: MockData.promoBanners[index],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

              // "What's on your mind?" Category Circles Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'WHAT\'S ON YOUR MIND?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: MockData.categories.length,
                        itemBuilder: (context, index) {
                          final category = MockData.categories[index];
                          final isSelected =
                              appState.selectedCategoryId == category.id;

                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: InkWell(
                              onTap: () =>
                                  appState.setSelectedCategory(category.id),
                              borderRadius: BorderRadius.circular(40),
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : theme.cardColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.06),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        category.icon,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Swiggy Quick Filter Pills
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildQuickFilterChip(
                        context,
                        label: 'Fast Delivery ⚡',
                        isSelected: false,
                        onTap: () {},
                      ),
                      _buildQuickFilterChip(
                        context,
                        label: 'Pure Veg 🟢',
                        isSelected: false,
                        onTap: () {},
                      ),
                      _buildQuickFilterChip(
                        context,
                        label: 'Rating 4.0+ ⭐',
                        isSelected: appState.minRating >= 4.0,
                        onTap: () {
                          if (appState.minRating >= 4.0) {
                            appState.updateFilters(minRating: 0.0);
                          } else {
                            appState.updateFilters(minRating: 4.0);
                          }
                        },
                      ),
                      _buildQuickFilterChip(
                        context,
                        label: 'Offers 🏷️',
                        isSelected: false,
                        onTap: () {},
                      ),
                      _buildQuickFilterChip(
                        context,
                        label: 'Dineout Table 🍽️',
                        isSelected: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReservationScreen(appState: appState),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Top Restaurants & Recommended Dishes Header
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appState.selectedCategoryId == 'all'
                            ? 'Top Dishes Near You'
                            : 'Dishes',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '${items.length} options',
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Dishes Grid
              if (items.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text(
                          'No dishes match your filters',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try resetting your search or filter tags.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => appState.resetFilters(),
                          child: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        final isFav = appState.isFavorite(item.id);

                        // Find quantity in cart
                        final cartIndex = appState.cart
                            .indexWhere((ci) => ci.item.id == item.id);
                        final qty = cartIndex >= 0
                            ? appState.cart[cartIndex].quantity
                            : 0;

                        return FoodCard(
                          menuItem: item,
                          isFavorite: isFav,
                          cartQuantity: qty,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(
                                  item: item,
                                  appState: appState,
                                ),
                              ),
                            );
                          },
                          onFavoriteTap: () => appState.toggleFavorite(item.id),
                          onAddToCartTap: () {
                            appState.addToCart(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added ${item.name} to cart!'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          onUpdateQuantity: (delta) {
                            appState.updateQuantity(item.id, delta);
                          },
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
            ],
          ),

          // Swiggy Floating Cart Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SwiggyFloatingCartPill(
              appState: appState,
              onTapViewCart: onTapViewCart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.12)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.primaryColor : null,
            ),
          ),
        ),
      ),
    );
  }
}
