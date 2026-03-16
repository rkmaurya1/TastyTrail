import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String description;
  final Color bgColor;
  final Color illustrationColor;
  final IconData mainIcon;
  final List<OnboardingFloatingItem> floatingItems;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.bgColor,
    required this.illustrationColor,
    required this.mainIcon,
    required this.floatingItems,
  });

  static const List<OnboardingData> pages = [
    OnboardingData(
      title: 'Discover Delicious Food',
      description: 'Browse hundreds of restaurants and dishes near you, all in one place.',
      bgColor: Color(0xFFFFF3F0),
      illustrationColor: Color(0xFFFF6B6B),
      mainIcon: Icons.restaurant_menu,
      floatingItems: [
        OnboardingFloatingItem(icon: Icons.local_pizza, color: Color(0xFFFF8C42), top: 40, left: 30),
        OnboardingFloatingItem(icon: Icons.icecream, color: Color(0xFF6C63FF), top: 60, right: 25),
        OnboardingFloatingItem(icon: Icons.lunch_dining, color: Color(0xFF43AA8B), bottom: 50, left: 20),
        OnboardingFloatingItem(icon: Icons.ramen_dining, color: Color(0xFFFFD166), bottom: 40, right: 30),
      ],
    ),
    OnboardingData(
      title: 'Lightning Fast Delivery',
      description: 'Your order reaches your door in minutes. Fresh, hot, and right on time.',
      bgColor: Color(0xFFF0F8FF),
      illustrationColor: Color(0xFF6C63FF),
      mainIcon: Icons.delivery_dining,
      floatingItems: [
        OnboardingFloatingItem(icon: Icons.timer, color: Color(0xFFFF6B6B), top: 35, right: 30),
        OnboardingFloatingItem(icon: Icons.star, color: Color(0xFFFFD166), top: 55, left: 20),
        OnboardingFloatingItem(icon: Icons.local_fire_department, color: Color(0xFFFF8C42), bottom: 55, right: 25),
        OnboardingFloatingItem(icon: Icons.thumb_up, color: Color(0xFF43AA8B), bottom: 35, left: 30),
      ],
    ),
    OnboardingData(
      title: 'Track Your Order Live',
      description: 'Real-time tracking so you always know exactly where your food is.',
      bgColor: Color(0xFFF0FFF4),
      illustrationColor: Color(0xFF43AA8B),
      mainIcon: Icons.location_on,
      floatingItems: [
        OnboardingFloatingItem(icon: Icons.check_circle, color: Color(0xFF43AA8B), top: 40, right: 25),
        OnboardingFloatingItem(icon: Icons.notifications_active, color: Color(0xFFFFD166), top: 55, left: 25),
        OnboardingFloatingItem(icon: Icons.map, color: Color(0xFF6C63FF), bottom: 50, left: 20),
        OnboardingFloatingItem(icon: Icons.celebration, color: Color(0xFFFF6B6B), bottom: 40, right: 30),
      ],
    ),
  ];
}

class OnboardingFloatingItem {
  final IconData icon;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const OnboardingFloatingItem({
    required this.icon,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}
