import 'package:flutter/material.dart';
import 'app_config.dart';

enum FlavorType {
  restaurant1,
  restaurant2,
  restaurant3,
}

class FlavorConfig {
  final FlavorType flavor;

  FlavorConfig(this.flavor) {
    _setFlavor();
  }

  void _setFlavor() {
    switch (flavor) {
      case FlavorType.restaurant1:
        _setRestaurant1Config();
        break;
      case FlavorType.restaurant2:
        _setRestaurant2Config();
        break;
      case FlavorType.restaurant3:
        _setRestaurant3Config();
        break;
    }
  }

  void _setRestaurant1Config() {
    AppConfig.appName = "Royal Biryani";
    AppConfig.tagline = "Authentic Biryani Experience";
    AppConfig.primaryColor = const Color(0xFFDC143C);
    AppConfig.secondaryColor = const Color(0xFFFFD700);
    AppConfig.primaryGradient = [
      const Color(0xFFDC143C),
      const Color(0xFFB22222),
    ];
    AppConfig.restaurantPhone = "+91 9876543210";
    AppConfig.restaurantEmail = "contact@royalbiryani.com";
  }

  void _setRestaurant2Config() {
    AppConfig.appName = "Pizza Paradise";
    AppConfig.tagline = "Best Pizza in Town";
    AppConfig.primaryColor = const Color(0xFFE74C3C);
    AppConfig.secondaryColor = const Color(0xFFF39C12);
    AppConfig.primaryGradient = [
      const Color(0xFFE74C3C),
      const Color(0xFFC0392B),
    ];
    AppConfig.restaurantPhone = "+91 9876543211";
    AppConfig.restaurantEmail = "contact@pizzaparadise.com";
  }

  void _setRestaurant3Config() {
    AppConfig.appName = "Burger House";
    AppConfig.tagline = "Juicy Burgers, Happy Moments";
    AppConfig.primaryColor = const Color(0xFFFF5722);
    AppConfig.secondaryColor = const Color(0xFFFFC107);
    AppConfig.primaryGradient = [
      const Color(0xFFFF5722),
      const Color(0xFFE64A19),
    ];
    AppConfig.restaurantPhone = "+91 9876543212";
    AppConfig.restaurantEmail = "contact@burgerhouse.com";
  }
}
