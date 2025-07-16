import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;
  final VoidCallback onContactSupport;
  final VoidCallback onRequestRevision;
  final VoidCallback onDownloadFiles;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onTap,
    required this.onContactSupport,
    required this.onRequestRevision,
    required this.onDownloadFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Service Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: order['serviceImage'],
                      width: 15.w,
                      height: 15.w,
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
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Commande #${order['id']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutralMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: (order['statusColor'] as Color).withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order['currentStatus'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: order['statusColor'] as Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Progress Bar (if in progress)
              if (order['currentStatus'] == 'En cours') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progression',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutralMedium,
                          ),
                        ),
                        Text(
                          '${(order['progress'] * 100).toInt()}%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutralMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: order['progress'],
                      backgroundColor: AppTheme.neutralLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryOrange),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],

              // Order Details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Commande passée',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutralMedium,
                          ),
                        ),
                        Text(
                          _formatDate(order['orderDate']),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Livraison prévue',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutralMedium,
                          ),
                        ),
                        Text(
                          _formatDate(order['deliveryDate']),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Montant',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutralMedium,
                        ),
                      ),
                      Text(
                        order['price'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Action Buttons
              Row(
                children: [
                  // Contact Support
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onContactSupport,
                      icon: const Icon(Icons.support_agent, size: 18),
                      label: const Text('Support'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlue,
                        side: const BorderSide(color: AppTheme.primaryBlue),
                      ),
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // Conditional Action Button
                  Expanded(
                    child: _buildActionButton(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    switch (order['currentStatus']) {
      case 'En cours':
        return ElevatedButton.icon(
          onPressed: onRequestRevision,
          icon: const Icon(Icons.rate_review, size: 18),
          label: const Text('Révision'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.warningAmber,
            foregroundColor: AppTheme.surfaceWhite,
          ),
        );
      case 'Livré':
        return ElevatedButton.icon(
          onPressed: onDownloadFiles,
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Télécharger'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successGreen,
            foregroundColor: AppTheme.surfaceWhite,
          ),
        );
      case 'Annulé':
        return ElevatedButton.icon(
          onPressed: () => _handleFeexpayRefund(),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Remboursement'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.errorRed,
            foregroundColor: AppTheme.surfaceWhite,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleFeexpayRefund() {
    // Implement Feexpay refund processing
    // This would integrate with Feexpay API for refund processing
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
