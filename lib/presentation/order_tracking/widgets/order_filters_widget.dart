import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OrderFiltersWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const OrderFiltersWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'All', 'label': 'Tout'},
      {'key': 'In Progress', 'label': 'En cours'},
      {'key': 'Completed', 'label': 'Terminé'},
      {'key': 'Cancelled', 'label': 'Annulé'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter['key'];

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(filter['label']!),
              selected: isSelected,
              onSelected: (selected) {
                onFilterChanged(filter['key']!);
              },
              backgroundColor: AppTheme.neutralLight,
              selectedColor: AppTheme.primaryOrange.withAlpha(26),
              checkmarkColor: AppTheme.primaryOrange,
              labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.neutralMedium,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : AppTheme.neutralLight,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
