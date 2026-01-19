import 'package:flutter/material.dart';
import '../core/config/app_config.dart';
import '../core/utils/constants.dart';

class MenuItemCard extends StatelessWidget {
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final bool isVeg;
  final VoidCallback? onTap;

  const MenuItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.isVeg = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusMedium),
                      topRight: Radius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusMedium),
                      topRight: Radius.circular(AppConstants.radiusMedium),
                    ),
                    child: imageUrl.isEmpty
                        ? Center(
                            child: Icon(
                              Icons.fastfood,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          )
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ),
                // Veg/Non-veg indicator
                Positioned(
                  top: AppConstants.paddingSmall,
                  left: AppConstants.paddingSmall,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 12,
                      color: isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                // Rating
                Positioned(
                  top: AppConstants.paddingSmall,
                  right: AppConstants.paddingSmall,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeRegular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppConfig.currencySymbol}${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppConfig.primaryColor,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
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
}
