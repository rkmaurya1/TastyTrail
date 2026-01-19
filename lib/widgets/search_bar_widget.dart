import 'package:flutter/material.dart';
import '../core/config/app_config.dart';
import '../core/utils/constants.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onChanged;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppConfig.primaryColor,
              size: 24,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                enabled: onTap == null,
                decoration: const InputDecoration(
                  hintText: AppStrings.search,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Icon(
              Icons.tune,
              color: Colors.grey[600],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
