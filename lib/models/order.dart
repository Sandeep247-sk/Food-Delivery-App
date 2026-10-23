import 'cart_item.dart';

enum OrderStatus {
  placed,
  preparing,
  onTheWay,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final DateTime orderTime;
  final OrderStatus status;
  final String deliveryAddress;

  OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.orderTime,
    required this.status,
    required this.deliveryAddress,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Cooking in Kitchen';
      case OrderStatus.onTheWay:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
