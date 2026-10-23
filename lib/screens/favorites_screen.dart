import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/food_card.dart';
import 'item_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final AppState appState;

  const FavoritesScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final favorites = appState.favoriteItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites (${favorites.length})'),
        actions: [
          IconButton(
            icon: Icon(
              appState.isDarkMode ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              color: appState.isDarkMode ? Colors.amber : null,
            ),
            tooltip: appState.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => appState.toggleDarkMode(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the heart icon on any dish to save it here for quick ordering.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.82,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return FoodCard(
                    menuItem: item,
                    isFavorite: true,
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
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
