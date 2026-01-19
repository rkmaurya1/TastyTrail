class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isPopular;
  final bool isVeg;
  final double rating;
  final int reviews;
  final List<String> tags;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isPopular = false,
    this.isVeg = true,
    this.rating = 0.0,
    this.reviews = 0,
    this.tags = const [],
  });

  factory MenuItem.fromMap(Map<String, dynamic> map, String id) {
    return MenuItem(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      isPopular: map['isPopular'] ?? false,
      isVeg: map['isVeg'] ?? true,
      rating: (map['rating'] ?? 0).toDouble(),
      reviews: map['reviews'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isPopular': isPopular,
      'isVeg': isVeg,
      'rating': rating,
      'reviews': reviews,
      'tags': tags,
    };
  }
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int order;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.order,
  });

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'order': order,
    };
  }
}
