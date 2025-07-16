import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final Function(Map<String, dynamic>) onOrderTap;
  final Function(Map<String, dynamic>) onReorderTap;

  const OrderHistoryWidget({
    super.key,
    required this.orders,
    required this.onOrderTap,
    required this.onReorderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...orders.take(3).map((order) => _buildOrderItem(order, context)),
        if (orders.length > 3)
          Padding(
            padding: EdgeInsets.all(4.w),
            child: TextButton(
              onPressed: () => onOrderTap({}),
              child: Text(
                'Voir toutes les commandes (${orders.length})',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.neutralLight.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neutralLight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Service Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: order['thumbnail'],
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 3.w),

              // Order Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['serviceName'],
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Terminé le ${_formatDate(order['completionDate'])}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutralMedium,
                      ),
                    ),
                  ],
                ),
              ),

              // Price and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order['price'],
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order['status'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Rating and Actions
          Row(
            children: [
              // Rating
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < order['rating']
                          ? AppTheme.warningAmber
                          : AppTheme.neutralLight,
                      size: 4.w,
                    );
                  }),
                  SizedBox(width: 2.w),
                  Text(
                    '${order['rating']}/5',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralMedium,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Reorder Button
              TextButton.icon(
                onPressed: () => onReorderTap(order),
                icon: Icon(
                  Icons.refresh,
                  size: 4.w,
                  color: AppTheme.primaryOrange,
                ),
                label: Text(
                  'Recommander',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
