import 'package:flutter/material.dart';
import '../state/app_state.dart';

class FilterModal extends StatefulWidget {
  final AppState appState;

  const FilterModal({super.key, required this.appState});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late double _maxPrice;
  late double _minRating;
  late int _maxCalories;
  late SortOption _sortOption;

  @override
  void initState() {
    super.initState();
    _maxPrice = widget.appState.maxPrice;
    _minRating = widget.appState.minRating;
    _maxCalories = widget.appState.maxCalories;
    _sortOption = widget.appState.sortOption;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter & Sort Dishes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    widget.appState.resetFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset All'),
                ),
              ],
            ),
            const Divider(height: 20),

            // Sort Options
            const Text(
              'Sort By',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _buildSortChip('Popularity', SortOption.popularity),
                _buildSortChip('Top Rated', SortOption.rating),
                _buildSortChip('Price: Low to High', SortOption.priceLowToHigh),
                _buildSortChip('Price: High to Low', SortOption.priceHighToLow),
              ],
            ),
            const SizedBox(height: 24),

            // Max Price Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Max Price',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_maxPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            Slider(
              value: _maxPrice,
              min: 5.0,
              max: 30.0,
              divisions: 25,
              activeColor: theme.primaryColor,
              onChanged: (val) => setState(() => _maxPrice = val),
            ),
            const SizedBox(height: 16),

            // Min Rating Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minimum Rating',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_minRating.toStringAsFixed(1)}+ ★',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            Slider(
              value: _minRating,
              min: 0.0,
              max: 4.8,
              divisions: 8,
              activeColor: Colors.amber,
              onChanged: (val) => setState(() => _minRating = val),
            ),
            const SizedBox(height: 16),

            // Max Calories Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Max Calories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_maxCalories kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            Slider(
              value: _maxCalories.toDouble(),
              min: 200,
              max: 1000,
              divisions: 8,
              activeColor: Colors.orange,
              onChanged: (val) => setState(() => _maxCalories = val.toInt()),
            ),
            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.appState.setSortOption(_sortOption);
                  widget.appState.updateFilters(
                    maxPrice: _maxPrice,
                    minRating: _minRating,
                    maxCalories: _maxCalories,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, SortOption option) {
    final isSelected = _sortOption == option;
    final primary = Theme.of(context).primaryColor;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _sortOption = option);
        }
      },
    );
  }
}
