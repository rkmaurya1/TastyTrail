import 'package:flutter/material.dart';

/// White-label configuration - Change these values for each restaurant
class AppConfig {
  // App Identity
  static String appName = "TastyTrail";
  static String tagline = "Delicious Food, Delivered Fast";

  // Branding Colors
  static Color primaryColor = const Color(0xFFFF6B6B);
  static Color secondaryColor = const Color(0xFF4ECDC4);
  static Color accentColor = const Color(0xFFFFE66D);

  // Gradient Colors
  static List<Color> primaryGradient = [
    const Color(0xFFFF6B6B),
    const Color(0xFFFF8E53),
  ];

  // Assets
  static String logo = "assets/images/logo.png";
  static String splashLogo = "assets/images/splash_logo.png";
  static String defaultFoodImage = "assets/images/default_food.png";

  // Restaurant Info
  static String restaurantPhone = "+91 9876543210";
  static String restaurantEmail = "contact@tastytrail.com";
  static String restaurantAddress = "123 Food Street, City Name";

  // App Settings
  static bool enableGoogleLogin = true;
  static bool enablePhoneLogin = true;
  static bool enableGuestMode = false;

  // Currency
  static String currencySymbol = "₹";

  // Delivery Settings
  static double deliveryCharge = 40.0;
  static double freeDeliveryAbove = 500.0;
  static double minOrderAmount = 199.0;
}
