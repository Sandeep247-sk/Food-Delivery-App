import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final AppState appState;

  const MainScreen({super.key, required this.appState});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, child) {
        final pages = [
          HomeScreen(
            appState: widget.appState,
            onTapViewCart: () {
              setState(() {
                _currentIndex = 2; // Jump to Cart Screen
              });
            },
          ),
          FavoritesScreen(appState: widget.appState),
          CartScreen(
            appState: widget.appState,
            onOrderPlaced: () {
              setState(() {
                _currentIndex = 3; // Jump to Orders Tab
              });
            },
          ),
          OrdersScreen(appState: widget.appState),
          ProfileScreen(appState: widget.appState),
        ];

        final cartCount = widget.appState.cartTotalQuantity;
        final favCount = widget.appState.favoriteIds.length;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              indicatorColor: AppTheme.primaryColor.withValues(alpha: 0.15),
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.restaurant_outlined),
                  selectedIcon: Icon(Icons.restaurant, color: AppTheme.primaryColor),
                  label: 'Food',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('$favCount'),
                    isLabelVisible: favCount > 0,
                    child: const Icon(Icons.favorite_border),
                  ),
                  selectedIcon: Badge(
                    label: Text('$favCount'),
                    isLabelVisible: favCount > 0,
                    child: const Icon(Icons.favorite, color: AppTheme.primaryColor),
                  ),
                  label: 'Favorites',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('$cartCount'),
                    isLabelVisible: cartCount > 0,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  selectedIcon: Badge(
                    label: Text('$cartCount'),
                    isLabelVisible: cartCount > 0,
                    child: const Icon(Icons.shopping_bag, color: AppTheme.primaryColor),
                  ),
                  label: 'Cart',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long, color: AppTheme.primaryColor),
                  label: 'Reorder',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: AppTheme.primaryColor),
                  label: 'Account',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
