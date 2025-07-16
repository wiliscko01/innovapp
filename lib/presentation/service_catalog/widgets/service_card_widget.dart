import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceCardWidget extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceImage(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryBadge(),
                    SizedBox(height: 1.h),
                    _buildServiceName(),
                    SizedBox(height: 0.5.h),
                    _buildRatingAndReviews(),
                    const Spacer(),
                    _buildPricing(),
                    SizedBox(height: 1.h),
                    _buildDeliveryTime(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: CustomImageWidget(
            imageUrl: service['image'] ?? '',
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 2.w,
          right: 2.w,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName:
                    service['isFavorite'] ? 'favorite' : 'favorite_border',
                color: service['isFavorite']
                    ? AppTheme.errorRed
                    : AppTheme.neutralMedium,
                size: 16,
              ),
            ),
          ),
        ),
        if (service['discount'] != null && service['discount'] > 0)
          Positioned(
            top: 2.w,
            left: 2.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-${service['discount']}%',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.surfaceWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        service['category'] ?? '',
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.primaryBlue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildServiceName() {
    return Text(
      service['name'] ?? '',
      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRatingAndReviews() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'star',
          color: AppTheme.warningAmber,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          service['rating']?.toString() ?? '0.0',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          '(${service['reviewCount'] ?? 0})',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.neutralMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildPricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (service['originalPrice'] != null &&
                service['discount'] != null &&
                service['discount'] > 0) ...[
              Text(
                '${service['originalPrice']?.toStringAsFixed(0)}€',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.neutralMedium,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Text(
              '${service['price']?.toStringAsFixed(0)}€',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (service['discount'] != null && service['discount'] > 0)
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'Remise mobile exclusive',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.successGreen,
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeliveryTime() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'schedule',
          color: AppTheme.neutralMedium,
          size: 12,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            service['deliveryTime'] ?? '',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.neutralMedium,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
