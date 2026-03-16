import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Expose firestore instance for direct queries
  FirebaseFirestore get firestore => _firestore;

  // ========== USER OPERATIONS ==========

  // Create or update user profile
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      await _firestore.collection(AppConstants.usersCollection).doc(userId).set({
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<DocumentSnapshot> getUserProfile(String userId) async {
    try {
      return await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
    } catch (e) {
      print('Error getting user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(data);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // ========== MENU OPERATIONS ==========

  // Get all menu items
  Stream<QuerySnapshot> getMenuItems() {
    return _firestore
        .collection(AppConstants.menuItemsCollection)
        .orderBy('name')
        .snapshots();
  }

  // Get menu items by category
  Stream<QuerySnapshot> getMenuItemsByCategory(String category) {
    return _firestore
        .collection(AppConstants.menuItemsCollection)
        .where('category', isEqualTo: category)
        .snapshots();
  }

  // Get popular menu items
  Stream<QuerySnapshot> getPopularMenuItems() {
    return _firestore
        .collection(AppConstants.menuItemsCollection)
        .where('isPopular', isEqualTo: true)
        .limit(10)
        .snapshots();
  }

  // Get single menu item
  Future<DocumentSnapshot> getMenuItem(String itemId) async {
    return await _firestore
        .collection(AppConstants.menuItemsCollection)
        .doc(itemId)
        .get();
  }

  // ========== CATEGORY OPERATIONS ==========

  // Get all categories
  Stream<QuerySnapshot> getCategories() {
    return _firestore
        .collection(AppConstants.categoriesCollection)
        .orderBy('order')
        .snapshots();
  }

  // ========== ORDER OPERATIONS ==========

  // Create order
  Future<String> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
    required String phoneNumber,
    required String customerName,
    required String paymentMethod,
    String? specialInstructions,
  }) async {
    try {
      // Calculate subtotal and delivery charge
      double subtotal = 0;
      for (var item in items) {
        subtotal += (item['price'] as double) * (item['quantity'] as int);
      }
      double deliveryCharge = subtotal > 0 ? 40.0 : 0.0;

      DocumentReference orderRef = await _firestore
          .collection(AppConstants.ordersCollection)
          .add({
        'userId': userId,
        'items': items,
        'subtotal': subtotal,
        'deliveryCharge': deliveryCharge,
        'totalAmount': totalAmount,
        'deliveryAddress': deliveryAddress,
        'phoneNumber': phoneNumber,
        'customerName': customerName,
        'paymentMethod': paymentMethod,
        'specialInstructions': specialInstructions,
        'status': AppConstants.orderPending,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return orderRef.id;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  // Get user orders
  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get single order
  Future<DocumentSnapshot> getOrder(String orderId) async {
    return await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .get();
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  // ========== SEED DATA ==========

  // Seed initial menu items and categories if Firestore is empty
  Future<void> seedInitialData() async {
    try {
      final existing = await _firestore
          .collection(AppConstants.menuItemsCollection)
          .limit(1)
          .get();
      if (existing.docs.isNotEmpty) return; // already seeded

      final batch = _firestore.batch();

      final menuItems = [
        {'id': '1', 'name': 'Margherita Pizza', 'description': 'Classic pizza with fresh tomato sauce and mozzarella', 'price': 349.0, 'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&q=80', 'category': 'Pizza', 'isVeg': true, 'isPopular': false, 'rating': 4.5, 'reviews': 120, 'tags': ['pizza', 'veg'], 'preparationTime': 25},
        {'id': '2', 'name': 'Classic Cheeseburger', 'description': 'Juicy beef patty with cheese, lettuce and tomato', 'price': 299.0, 'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80', 'category': 'Burgers', 'isVeg': false, 'isPopular': true, 'rating': 4.7, 'reviews': 95, 'tags': ['burger', 'non-veg'], 'preparationTime': 20},
        {'id': '3', 'name': 'Chocolate Cupcake', 'description': 'Rich chocolate cupcake with creamy frosting', 'price': 149.0, 'imageUrl': 'https://images.unsplash.com/photo-1587668178277-295251f900ce?w=400&q=80', 'category': 'Desserts', 'isVeg': true, 'isPopular': false, 'rating': 4.8, 'reviews': 60, 'tags': ['dessert', 'sweet'], 'preparationTime': 15},
        {'id': '4', 'name': 'Chocolate Cake', 'description': 'Decadent layered chocolate cake', 'price': 399.0, 'imageUrl': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&q=80', 'category': 'Desserts', 'isVeg': true, 'isPopular': true, 'rating': 4.9, 'reviews': 200, 'tags': ['dessert', 'cake'], 'preparationTime': 30},
        {'id': '5', 'name': 'Crispy Chicken Burger', 'description': 'Crispy fried chicken with special sauce', 'price': 329.0, 'imageUrl': 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=400&q=80', 'category': 'Burgers', 'isVeg': false, 'isPopular': false, 'rating': 4.6, 'reviews': 80, 'tags': ['burger', 'chicken'], 'preparationTime': 20},
        {'id': '6', 'name': 'Pepperoni Pizza', 'description': 'Loaded with pepperoni and mozzarella cheese', 'price': 399.0, 'imageUrl': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&q=80', 'category': 'Pizza', 'isVeg': false, 'isPopular': true, 'rating': 4.7, 'reviews': 150, 'tags': ['pizza', 'non-veg'], 'preparationTime': 25},
        {'id': '7', 'name': 'Strawberry Shake', 'description': 'Refreshing strawberry milkshake', 'price': 179.0, 'imageUrl': 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400&q=80', 'category': 'Drinks', 'isVeg': true, 'isPopular': false, 'rating': 4.4, 'reviews': 45, 'tags': ['drink', 'shake'], 'preparationTime': 10},
        {'id': '8', 'name': 'Ice Cream Sundae', 'description': 'Vanilla ice cream with chocolate sauce and cherry', 'price': 199.0, 'imageUrl': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&q=80', 'category': 'Desserts', 'isVeg': true, 'isPopular': false, 'rating': 4.6, 'reviews': 70, 'tags': ['dessert', 'ice cream'], 'preparationTime': 5},
        {'id': '9', 'name': 'Veggie Supreme Pizza', 'description': 'Loaded with fresh vegetables and cheese', 'price': 369.0, 'imageUrl': 'https://images.unsplash.com/photo-1571407970349-bc81e7e96a47?w=400&q=80', 'category': 'Pizza', 'isVeg': true, 'isPopular': false, 'rating': 4.5, 'reviews': 55, 'tags': ['pizza', 'veg'], 'preparationTime': 25},
        {'id': '10', 'name': 'Double Patty Burger', 'description': 'Two beef patties with cheese and special sauce', 'price': 429.0, 'imageUrl': 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400&q=80', 'category': 'Burgers', 'isVeg': false, 'isPopular': true, 'rating': 4.8, 'reviews': 110, 'tags': ['burger', 'non-veg'], 'preparationTime': 25},
        {'id': '11', 'name': 'Fresh Orange Juice', 'description': 'Freshly squeezed orange juice', 'price': 129.0, 'imageUrl': 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&q=80', 'category': 'Drinks', 'isVeg': true, 'isPopular': false, 'rating': 4.5, 'reviews': 30, 'tags': ['drink', 'juice'], 'preparationTime': 5},
        {'id': '12', 'name': 'Red Velvet Cake', 'description': 'Classic red velvet with cream cheese frosting', 'price': 449.0, 'imageUrl': 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=400&q=80', 'category': 'Desserts', 'isVeg': true, 'isPopular': true, 'rating': 4.7, 'reviews': 180, 'tags': ['dessert', 'cake'], 'preparationTime': 30},
        {'id': '13', 'name': 'Greek Salad', 'description': 'Fresh greens with olives, feta and dressing', 'price': 249.0, 'imageUrl': 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&q=80', 'category': 'Salads', 'isVeg': true, 'isPopular': true, 'rating': 4.8, 'reviews': 90, 'tags': ['salad', 'healthy'], 'preparationTime': 10},
      ];

      for (final item in menuItems) {
        final id = item['id'] as String;
        final data = Map<String, dynamic>.from(item)..remove('id');
        final ref = _firestore.collection(AppConstants.menuItemsCollection).doc(id);
        batch.set(ref, data);
      }

      final categories = [
        {'name': 'All', 'icon': 'all', 'order': 0},
        {'name': 'Pizza', 'icon': 'pizza', 'order': 1},
        {'name': 'Burgers', 'icon': 'burger', 'order': 2},
        {'name': 'Drinks', 'icon': 'drink', 'order': 3},
        {'name': 'Desserts', 'icon': 'dessert', 'order': 4},
        {'name': 'Salads', 'icon': 'salad', 'order': 5},
      ];

      for (final cat in categories) {
        final ref = _firestore.collection(AppConstants.categoriesCollection).doc();
        batch.set(ref, cat);
      }

      await batch.commit();
    } catch (e) {
      print('Seed error (ignored): $e');
    }
  }

  // ========== OFFERS OPERATIONS ==========

  // Get active offers
  Stream<QuerySnapshot> getActiveOffers() {
    return _firestore
        .collection(AppConstants.offersCollection)
        .where('isActive', isEqualTo: true)
        .where('expiryDate', isGreaterThan: Timestamp.now())
        .orderBy('expiryDate')
        .snapshots();
  }

  // Get single offer
  Future<DocumentSnapshot> getOffer(String offerId) async {
    return await _firestore
        .collection(AppConstants.offersCollection)
        .doc(offerId)
        .get();
  }
}
