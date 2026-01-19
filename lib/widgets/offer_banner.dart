import 'package:flutter/material.dart';
import '../core/config/app_config.dart';
import '../core/utils/constants.dart';

class OfferBanner extends StatelessWidget {
  const OfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 340,
            margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppConfig.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppConfig.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.local_offer,
                    size: 120,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppConfig.accentColor,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall),
                        ),
                        child: const Text(
                          '50% OFF',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      const Text(
                        'On your first order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        'Use code: FIRST50',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: AppConstants.fontSizeMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
