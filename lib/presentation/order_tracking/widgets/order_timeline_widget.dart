import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OrderTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;

  const OrderTimelineWidget({
    super.key,
    required this.timeline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historique de la commande',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: ListView.builder(
              itemCount: timeline.length,
              itemBuilder: (context, index) {
                final item = timeline[index];
                final isLast = index == timeline.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    children: [
                      // Timeline indicator
                      Column(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: item['completed']
                                  ? AppTheme.primaryOrange
                                  : AppTheme.neutralLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: item['completed']
                                    ? AppTheme.primaryOrange
                                    : AppTheme.neutralMedium,
                                width: 2,
                              ),
                            ),
                            child: item['completed']
                                ? const Icon(
                                    Icons.check,
                                    color: AppTheme.surfaceWhite,
                                    size: 12,
                                  )
                                : null,
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 8.h,
                              color: item['completed']
                                  ? AppTheme.primaryOrange
                                  : AppTheme.neutralLight,
                            ),
                        ],
                      ),

                      SizedBox(width: 4.w),

                      // Timeline content
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: isLast ? 0 : 3.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['status'],
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: item['completed']
                                      ? AppTheme.neutralDark
                                      : AppTheme.neutralMedium,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              if (item['date'] != null &&
                                  item['date'].isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Text(
                                    _formatDateTime(item['date']),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.neutralMedium,
                                    ),
                                  ),
                                ),
                              Text(
                                item['description'],
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: item['completed']
                                      ? AppTheme.neutralDark
                                      : AppTheme.neutralMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
