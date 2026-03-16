import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/config/app_config.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/firestore_service.dart';
import 'menu_model.dart';
import '../cart/cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CartService _cartService = CartService();
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Pizza', 'Burgers', 'Drinks', 'Desserts', 'Salads',
  ];

  Stream<QuerySnapshot> get _menuStream {
    if (_selectedCategory == 'All') {
      return _firestoreService.getMenuItems();
    }
    return _firestoreService.getMenuItemsByCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConfig.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.restaurant_menu, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Tasty Trail',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Tabs
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: AppConfig.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          // Section Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _selectedCategory == 'All'
                  ? 'Delicious Dishes Awaiting'
                  : 'Fresh & Fast Bites',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Menu Items Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _menuStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: AppConfig.primaryColor),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restaurant_menu, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No items found',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                final items = snapshot.data!.docs
                    .map((doc) => MenuItem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList();
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _buildMenuItem(items[index]),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Cart Button
      floatingActionButton: AnimatedBuilder(
        animation: _cartService,
        builder: (context, child) {
          if (_cartService.itemCount == 0) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            backgroundColor: AppConfig.primaryColor,
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              'View Cart (${_cartService.itemCount} items)\n₹${_cartService.total.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    item.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: AppConfig.primaryColor,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.fastfood, size: 50),
                      );
                    },
                  ),
                ),
                // Veg/Non-veg indicator
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 12,
                      color: item.isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Description or rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        item.rating.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price and Add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _cartService,
                        builder: (context, child) {
                          final inCart = _cartService.isInCart(item.id);
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: inCart
                                ? Container(
                                    key: const ValueKey('check'),
                                    decoration: BoxDecoration(
                                      color: AppConfig.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    key: const ValueKey('add'),
                                    onTap: () {
                                      _cartService.addItem(item);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${item.name} added to cart'),
                                          duration: const Duration(milliseconds: 800),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppConfig.primaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
