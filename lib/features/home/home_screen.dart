import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';
import '../../core/services/cart_service.dart';
import '../../core/utils/constants.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/search_bar_widget.dart';
import '../menu/menu_screen.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late int _currentIndex;
  final CartService _cartService = CartService();

  // Banner carousel
  late PageController _bannerPageController;
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  // Animation controllers
  late AnimationController _categoryAnimController;
  late AnimationController _itemsAnimController;

  final List<Map<String, dynamic>> _banners = [
    {
      'title1': 'DELICIOUS',
      'title2': 'MENU',
      'tag': 'SPECIAL OFFER',
      'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&q=80',
      'bgImage': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
      'colors': [Color(0xFFFF6B35), Color(0xFFFF5722)],
    },
    {
      'title1': 'FRESH',
      'title2': 'SALADS',
      'tag': 'HEALTHY CHOICE',
      'image': 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=300&q=80',
      'bgImage': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
      'colors': [Color(0xFF43A047), Color(0xFF2E7D32)],
    },
    {
      'title1': 'TASTY',
      'title2': 'BURGERS',
      'tag': 'COMBO DEALS',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&q=80',
      'bgImage': 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800&q=80',
      'colors': [Color(0xFFE65100), Color(0xFFBF360C)],
    },
    {
      'title1': 'SWEET',
      'title2': 'TREATS',
      'tag': 'DESSERT TIME',
      'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=300&q=80',
      'bgImage': 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800&q=80',
      'colors': [Color(0xFFD81B60), Color(0xFFC2185B)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Banner setup
    _bannerPageController = PageController(viewportFraction: 0.92);
    _startAutoScroll();

    // Animation controllers
    _categoryAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _itemsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Start animations
    _categoryAnimController.forward();
    _itemsAnimController.forward();
  }

  void _startAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerPageController.hasClients) {
        int nextPage = (_currentBannerPage + 1) % _banners.length;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    _categoryAnimController.dispose();
    _itemsAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: AppConfig.primaryColor,
              elevation: 0,
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
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _cartService,
                      builder: (context, child) {
                        if (_cartService.itemCount == 0) {
                          return const SizedBox.shrink();
                        }
                        return Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${_cartService.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
          : null,
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuScreen()),
                );
              },
              child: const SearchBarWidget(),
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          // Animated Banner Carousel
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _bannerPageController,
              onPageChanged: (index) {
                setState(() => _currentBannerPage = index);
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _bannerPageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_bannerPageController.position.haveDimensions) {
                      value = (_bannerPageController.page ?? 0) - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeOut.transform(value) * 180,
                        child: child,
                      ),
                    );
                  },
                  child: _buildBannerCard(_banners[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Banner Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentBannerPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentBannerPage == index
                      ? AppConfig.primaryColor
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MenuScreen()),
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Category Icons with Animation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAnimatedCategory(
                  'Fast Food',
                  Icons.fastfood,
                  const Color(0xFFFFF3E0),
                  Colors.orange,
                  0,
                ),
                _buildAnimatedCategory(
                  'Salads',
                  Icons.lunch_dining,
                  const Color(0xFFE8F5E9),
                  Colors.green,
                  1,
                ),
                _buildAnimatedCategory(
                  'Seafood',
                  Icons.set_meal,
                  const Color(0xFFE3F2FD),
                  Colors.blue,
                  2,
                ),
                _buildAnimatedCategory(
                  'Desserts',
                  Icons.cake,
                  const Color(0xFFFCE4EC),
                  Colors.pink,
                  3,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          // Popular Items Section
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Items',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MenuScreen()),
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Popular Items Horizontal List with Animation
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              children: [
                _buildAnimatedPopularItem(
                  'Cheeseburger',
                  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
                  4.5,
                  0,
                ),
                _buildAnimatedPopularItem(
                  'Greek Salad',
                  'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&q=80',
                  4.8,
                  1,
                ),
                _buildAnimatedPopularItem(
                  'Chocolate Cake',
                  'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&q=80',
                  4.7,
                  2,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: banner['colors'] as List<Color>,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: (banner['colors'] as List<Color>)[0].withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  banner['bgImage'] as String,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.2),
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.transparent);
                  },
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            banner['tag'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner['title1'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          banner['title2'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Order Now',
                            style: TextStyle(
                              color: (banner['colors'] as List<Color>)[0],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Food Image
                  Hero(
                    tag: 'banner_${banner['image']}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        banner['image'] as String,
                        width: 120,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.fastfood,
                              size: 50,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCategory(
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor,
    int index,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _categoryAnimController,
          curve: Interval(
            index * 0.15,
            0.6 + (index * 0.15),
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: _categoryAnimController,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _categoryAnimController,
              curve: Interval(
                index * 0.15,
                0.6 + (index * 0.15),
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: _buildCategoryIcon(label, icon, bgColor, iconColor),
        ),
      ),
    );
  }

  Widget _buildAnimatedPopularItem(
    String name,
    String imageUrl,
    double rating,
    int index,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _itemsAnimController,
          curve: Interval(
            index * 0.2,
            0.5 + (index * 0.2),
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: _itemsAnimController,
        child: _buildPopularItemCard(name, imageUrl, rating),
      ),
    );
  }

  Widget _buildCategoryIcon(
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuScreen()),
        );
      },
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItemCard(String name, String imageUrl, double rating) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuScreen()),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    width: 160,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 160,
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.fastfood, size: 50),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildRestaurantCard(String name, double rating, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant,
                color: Colors.orange,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'View Menu',
                style: TextStyle(
                  color: AppConfig.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTab() {
    return const MenuScreen();
  }

  Widget _buildOrdersTab() {
    return const OrdersScreen();
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }
}
