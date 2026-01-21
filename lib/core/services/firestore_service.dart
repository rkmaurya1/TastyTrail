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
