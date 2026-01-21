import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';
import 'auth_service.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  String get _userId => _authService.currentUser?.uid ?? '';

  // Get user's addresses
  Stream<List<Address>> getUserAddresses() {
    if (_userId.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .snapshots()
        .map((snapshot) {
      final addresses = snapshot.docs.map((doc) {
        final data = doc.data();
        return Address.fromJson({...data, 'id': doc.id});
      }).toList();

      // Sort in memory: default addresses first, then by creation date
      addresses.sort((a, b) {
        if (a.isDefault && !b.isDefault) return -1;
        if (!a.isDefault && b.isDefault) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      return addresses;
    });
  }

  // Get single address
  Future<Address?> getAddress(String addressId) async {
    if (_userId.isEmpty) return null;

    final doc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .doc(addressId)
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return Address.fromJson({...data, 'id': doc.id});
  }

  // Add new address
  Future<void> addAddress(Address address) async {
    if (_userId.isEmpty) {
      throw Exception('User not logged in');
    }

    // If this is set as default, unset other defaults
    if (address.isDefault) {
      await _unsetAllDefaults();
    }

    final addressData = address.toJson();
    addressData['userId'] = _userId;
    addressData.remove('id'); // Let Firestore generate ID

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .add(addressData);
  }

  // Update address
  Future<void> updateAddress(Address address) async {
    if (_userId.isEmpty) {
      throw Exception('User not logged in');
    }

    // If this is set as default, unset other defaults
    if (address.isDefault) {
      await _unsetAllDefaults(excludeId: address.id);
    }

    final addressData = address.copyWith(
      updatedAt: DateTime.now(),
    ).toJson();
    addressData.remove('id');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .doc(address.id)
        .update(addressData);
  }

  // Delete address
  Future<void> deleteAddress(String addressId) async {
    if (_userId.isEmpty) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  // Set address as default
  Future<void> setDefaultAddress(String addressId) async {
    if (_userId.isEmpty) {
      throw Exception('User not logged in');
    }

    await _unsetAllDefaults();

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .doc(addressId)
        .update({
      'isDefault': true,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Get default address
  Future<Address?> getDefaultAddress() async {
    if (_userId.isEmpty) return null;

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .where('isDefault', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    final data = doc.data();
    return Address.fromJson({...data, 'id': doc.id});
  }

  // Unset all default addresses
  Future<void> _unsetAllDefaults({String? excludeId}) async {
    if (_userId.isEmpty) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('addresses')
        .where('isDefault', isEqualTo: true)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      if (excludeId != null && doc.id == excludeId) continue;
      batch.update(doc.reference, {
        'isDefault': false,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }

    await batch.commit();
  }
}
