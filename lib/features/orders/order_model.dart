import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double total;
  final Map<String, dynamic> deliveryAddress;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    required this.deliveryAddress,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryCharge: (map['deliveryCharge'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      deliveryAddress: map['deliveryAddress'] ?? {},
      notes: map['notes'],
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  String getStatusText() {
    switch (status) {
      case 'pending':
        return 'Order Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'on_the_way':
        return 'On the Way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}

class OrderItem {
  final String itemId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemId: map['itemId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  double get total => price * quantity;
}
