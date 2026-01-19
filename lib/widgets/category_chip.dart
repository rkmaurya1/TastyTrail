import 'package:flutter/material.dart';
import '../core/config/app_config.dart';
import '../core/utils/constants.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppConfig.primaryColor,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
