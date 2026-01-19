import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/constants.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/menu_item_card.dart';
import '../../widgets/offer_banner.dart';
import '../../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deliver to',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppConfig.primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Home - 123 Street',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildMenuTab();
      case 2:
        return _buildOrdersTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.paddingMedium),
          // Search Bar
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium),
            child: SearchBarWidget(),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          // Offer Banner
          const OfferBanner(),
          const SizedBox(height: AppConstants.paddingLarge),
          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.categories,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(color: AppConfig.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium),
              children: const [
                CategoryChip(
                  icon: Icons.fastfood,
                  label: 'Burgers',
                ),
                CategoryChip(
                  icon: Icons.local_pizza,
                  label: 'Pizza',
                ),
                CategoryChip(
                  icon: Icons.rice_bowl,
                  label: 'Biryani',
                ),
                CategoryChip(
                  icon: Icons.icecream,
                  label: 'Desserts',
                ),
                CategoryChip(
                  icon: Icons.local_cafe,
                  label: 'Beverages',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          // Popular Items
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.popularItems,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(color: AppConfig.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium),
              children: const [
                MenuItemCard(
                  name: 'Chicken Biryani',
                  price: 299,
                  rating: 4.5,
                  imageUrl: '',
                  isVeg: false,
                ),
                MenuItemCard(
                  name: 'Paneer Tikka',
                  price: 249,
                  rating: 4.2,
                  imageUrl: '',
                  isVeg: true,
                ),
                MenuItemCard(
                  name: 'Butter Chicken',
                  price: 349,
                  rating: 4.7,
                  imageUrl: '',
                  isVeg: false,
                ),
                MenuItemCard(
                  name: 'Veg Pizza',
                  price: 199,
                  rating: 4.0,
                  imageUrl: '',
                  isVeg: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildMenuTab() {
    return const Center(
      child: Text('Menu Screen - Coming Soon'),
    );
  }

  Widget _buildOrdersTab() {
    return const Center(
      child: Text('Orders Screen - Coming Soon'),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text('Profile Screen - Coming Soon'),
    );
  }
}
