import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../models/reservation.dart';
import '../models/review.dart';
import '../data/mock_data.dart';
import '../services/supabase_service.dart';

enum SortOption { popularity, rating, priceLowToHigh, priceHighToLow }

class AppState extends ChangeNotifier {
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  SortOption _sortOption = SortOption.popularity;

  // Filters
  double _maxPrice = 30.0;
  double _minRating = 0.0;
  int _maxCalories = 1000;

  final Set<String> _favoriteIds = {'m1', 'm3', 'm7'};
  final List<CartItem> _cart = [];
  final List<OrderModel> _orders = [];
  final List<TableReservation> _reservations = [];
  List<MenuItemModel> _liveMenuItems = [];
  bool _isDarkMode = false;
  bool _isLoadingSupabase = false;

  // User Profile Info
  String _userName = 'Alex Morgan';
  String _userPhone = '+1 (555) 234-5678';
  String _userAddress = '742 Evergreen Terrace, Sector 4';

  AppState() {
    _liveMenuItems = MockData.menuItems;

    // Add sample active order for initial view
    _orders.add(
      OrderModel(
        id: 'ORD-8921',
        items: [
          CartItem(item: MockData.menuItems[0], quantity: 2),
          CartItem(item: MockData.menuItems[6], quantity: 1),
        ],
        subtotal: 38.97,
        deliveryFee: 2.99,
        tax: 3.12,
        total: 45.08,
        orderTime: DateTime.now().subtract(const Duration(minutes: 18)),
        status: OrderStatus.preparing,
        deliveryAddress: _userAddress,
      ),
    );

    // Add sample table reservation
    _reservations.add(
      TableReservation(
        id: 'RES-102',
        date: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '7:30 PM',
        partySize: 4,
        seatingPreference: 'Indoor Window Table',
        specialRequest: 'Anniversary celebration',
      ),
    );
  }

  // Load Live Data from Supabase
  Future<void> loadSupabaseData() async {
    _isLoadingSupabase = true;
    notifyListeners();

    try {
      final supabaseItems = await SupabaseService.fetchMenuItems();
      if (supabaseItems.isNotEmpty) {
        _liveMenuItems = supabaseItems;
      }
    } catch (e) {
      debugPrint('Error loading Supabase items: $e');
    } finally {
      _isLoadingSupabase = false;
      notifyListeners();
    }
  }

  // Getters
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  double get maxPrice => _maxPrice;
  double get minRating => _minRating;
  int get maxCalories => _maxCalories;
  Set<String> get favoriteIds => _favoriteIds;
  List<CartItem> get cart => List.unmodifiable(_cart);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  List<TableReservation> get reservations => List.unmodifiable(_reservations);
  bool get isDarkMode => _isDarkMode;
  bool get isLoadingSupabase => _isLoadingSupabase;
  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userAddress => _userAddress;

  // Category & Filter Controls
  void setSelectedCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void updateFilters({double? maxPrice, double? minRating, int? maxCalories}) {
    if (maxPrice != null) _maxPrice = maxPrice;
    if (minRating != null) _minRating = minRating;
    if (maxCalories != null) _maxCalories = maxCalories;
    notifyListeners();
  }

  void resetFilters() {
    _maxPrice = 30.0;
    _minRating = 0.0;
    _maxCalories = 1000;
    _sortOption = SortOption.popularity;
    notifyListeners();
  }

  List<MenuItemModel> get filteredMenuItems {
    var result = _liveMenuItems.where((item) {
      final matchesCategory =
          _selectedCategoryId == 'all' || item.categoryId == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPrice = item.price <= _maxPrice;
      final matchesRating = item.rating >= _minRating;
      final matchesCalories = item.calories <= _maxCalories;

      return matchesCategory &&
          matchesSearch &&
          matchesPrice &&
          matchesRating &&
          matchesCalories;
    }).toList();

    // Apply Sorting
    switch (_sortOption) {
      case SortOption.popularity:
        result.sort((a, b) => (b.isPopular ? 1 : 0).compareTo(a.isPopular ? 1 : 0));
        break;
      case SortOption.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return result;
  }

  // Favorites
  bool isFavorite(String menuItemId) {
    return _favoriteIds.contains(menuItemId);
  }

  void toggleFavorite(String menuItemId) {
    if (_favoriteIds.contains(menuItemId)) {
      _favoriteIds.remove(menuItemId);
    } else {
      _favoriteIds.add(menuItemId);
    }
    notifyListeners();
  }

  List<MenuItemModel> get favoriteItems {
    return _liveMenuItems
        .where((item) => _favoriteIds.contains(item.id))
        .toList();
  }

  // Cart
  int get cartTotalQuantity {
    return _cart.fold(0, (sum, item) => sum + item.quantity);
  }

  double get cartSubtotal {
    return _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => _cart.isEmpty ? 0.0 : 2.99;
  double get taxAmount => cartSubtotal * 0.08;
  double get cartGrandTotal => cartSubtotal + deliveryFee + taxAmount;

  void addToCart(MenuItemModel menuItem,
      {int quantity = 1, String specialInstructions = ''}) {
    final existingIndex = _cart.indexWhere((ci) => ci.item.id == menuItem.id);
    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += quantity;
      if (specialInstructions.isNotEmpty) {
        _cart[existingIndex].specialInstructions = specialInstructions;
      }
    } else {
      _cart.add(
        CartItem(
          item: menuItem,
          quantity: quantity,
          specialInstructions: specialInstructions,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int delta) {
    final index = _cart.indexWhere((ci) => ci.item.id == itemId);
    if (index >= 0) {
      final newQty = _cart[index].quantity + delta;
      if (newQty <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    _cart.removeWhere((ci) => ci.item.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Orders
  OrderModel? placeOrder({required String address}) {
    if (_cart.isEmpty) return null;

    final newOrder = OrderModel(
      id: 'ORD-${1000 + _orders.length + 1}',
      items: List.from(_cart),
      subtotal: cartSubtotal,
      deliveryFee: deliveryFee,
      tax: taxAmount,
      total: cartGrandTotal,
      orderTime: DateTime.now(),
      status: OrderStatus.placed,
      deliveryAddress: address,
    );

    _orders.insert(0, newOrder);
    _cart.clear();
    notifyListeners();

    // Push to Supabase asynchronously
    SupabaseService.createOrder(newOrder);

    return newOrder;
  }

  // Table Reservation
  TableReservation bookTable({
    required DateTime date,
    required String timeSlot,
    required int partySize,
    required String seatingPreference,
    String specialRequest = '',
  }) {
    final res = TableReservation(
      id: 'RES-${100 + _reservations.length + 1}',
      date: date,
      timeSlot: timeSlot,
      partySize: partySize,
      seatingPreference: seatingPreference,
      specialRequest: specialRequest,
    );
    _reservations.insert(0, res);
    notifyListeners();

    // Push to Supabase asynchronously
    SupabaseService.createReservation(res);

    return res;
  }

  void cancelReservation(String id) {
    _reservations.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // Reviews
  void addReview(String itemId, ReviewModel review) {
    final itemIndex = _liveMenuItems.indexWhere((m) => m.id == itemId);
    if (itemIndex >= 0) {
      _liveMenuItems[itemIndex].reviews.insert(0, review);
      notifyListeners();
    }
  }

  // Settings
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateUserProfile({String? name, String? phone, String? address}) {
    if (name != null) _userName = name;
    if (phone != null) _userPhone = phone;
    if (address != null) _userAddress = address;
    notifyListeners();
  }
}
