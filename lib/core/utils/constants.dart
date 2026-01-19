class AppConstants {
  // API Endpoints (if needed)
  static const String baseUrl = "https://api.tastytrail.com";

  // Firebase Collection Names
  static const String usersCollection = "users";
  static const String restaurantsCollection = "restaurants";
  static const String menuItemsCollection = "menu_items";
  static const String ordersCollection = "orders";
  static const String offersCollection = "offers";
  static const String categoriesCollection = "categories";

  // Shared Preferences Keys
  static const String keyUserId = "user_id";
  static const String keyUserName = "user_name";
  static const String keyUserEmail = "user_email";
  static const String keyUserPhone = "user_phone";
  static const String keyIsLoggedIn = "is_logged_in";

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXL = 24.0;

  // Padding & Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXL = 32.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeTitle = 28.0;

  // Order Status
  static const String orderPending = "pending";
  static const String orderConfirmed = "confirmed";
  static const String orderPreparing = "preparing";
  static const String orderOnTheWay = "on_the_way";
  static const String orderDelivered = "delivered";
  static const String orderCancelled = "cancelled";
}

class AppStrings {
  static const String appName = "TastyTrail";
  static const String welcome = "Welcome to";
  static const String loginWithGoogle = "Continue with Google";
  static const String loginWithPhone = "Continue with Phone";
  static const String continueAsGuest = "Continue as Guest";
  static const String home = "Home";
  static const String menu = "Menu";
  static const String orders = "Orders";
  static const String offers = "Offers";
  static const String profile = "Profile";
  static const String cart = "Cart";
  static const String search = "Search for delicious food...";
  static const String popularItems = "Popular Items";
  static const String categories = "Categories";
  static const String recentOrders = "Recent Orders";
  static const String logout = "Logout";
  static const String settings = "Settings";
  static const String aboutUs = "About Us";
  static const String termsConditions = "Terms & Conditions";
  static const String privacyPolicy = "Privacy Policy";
}
