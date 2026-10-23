import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/mock_data.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import '../models/reservation.dart';

class SupabaseService {
  // Replace these placeholders with your actual Supabase URL & Key from your Supabase Dashboard
  static const String supabaseUrl = 'https://YOUR_SUPABASE_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  static bool _isInitialized = false;

  static Future<void> init() async {
    if (supabaseUrl.contains('YOUR_SUPABASE_PROJECT_ID')) {
      if (kDebugMode) {
        print('ℹ️ Supabase running in Mock Fallback mode. Add your Supabase URL & Key in lib/services/supabase_service.dart to connect live PostgreSQL DB.');
      }
      return;
    }

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _isInitialized = true;
      if (kDebugMode) {
        print('✅ Supabase connected successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Supabase connection warning: $e');
      }
    }
  }

  static SupabaseClient? get client {
    if (_isInitialized) {
      return Supabase.instance.client;
    }
    return null;
  }

  // Fetch Menu Items from Supabase DB Table 'menu_items'
  static Future<List<MenuItemModel>> fetchMenuItems() async {
    final supabase = client;
    if (supabase == null) return MockData.menuItems;

    try {
      final response = await supabase.from('menu_items').select();
      if (response.isNotEmpty) {
        return (response as List).map((data) {
          return MenuItemModel(
            id: data['id'].toString(),
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            rating: (data['rating'] as num?)?.toDouble() ?? 4.8,
            reviewCount: (data['review_count'] as num?)?.toInt() ?? 100,
            categoryId: data['category_id'] ?? 'burgers',
            imageUrl: data['image_url'] ?? '',
            calories: (data['calories'] as num?)?.toInt() ?? 500,
            prepTime: data['prep_time'] ?? '20 mins',
            distance: data['distance'] ?? '2.0 km',
            isPopular: data['is_popular'] ?? false,
            isVeg: data['is_veg'] ?? true,
            restaurantName: data['restaurant_name'] ?? 'Savoria Bistro',
            offerTag: data['offer_tag'] ?? '50% OFF UP TO ₹100',
          );
        }).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching menu_items from Supabase: $e');
      }
    }
    return MockData.menuItems;
  }

  // Save new Order to Supabase DB Table 'orders'
  static Future<bool> createOrder(OrderModel order) async {
    final supabase = client;
    if (supabase == null) return false;

    try {
      final itemsSummary = order.items.map((ci) => {
        'name': ci.item.name,
        'quantity': ci.quantity,
        'price': ci.totalPrice,
      }).toList();

      await supabase.from('orders').insert({
        'id': order.id,
        'items': itemsSummary,
        'subtotal': order.subtotal,
        'delivery_fee': order.deliveryFee,
        'tax': order.tax,
        'total': order.total,
        'status': order.status.name,
        'delivery_address': order.deliveryAddress,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting order into Supabase: $e');
      }
      return false;
    }
  }

  // Save Table Reservation to Supabase DB Table 'reservations'
  static Future<bool> createReservation(TableReservation reservation) async {
    final supabase = client;
    if (supabase == null) return false;

    try {
      await supabase.from('reservations').insert({
        'id': reservation.id,
        'date': reservation.date.toIso8601String(),
        'time_slot': reservation.timeSlot,
        'party_size': reservation.partySize,
        'seating_preference': reservation.seatingPreference,
        'special_request': reservation.specialRequest,
        'status': reservation.status.name,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting reservation into Supabase: $e');
      }
      return false;
    }
  }
}
