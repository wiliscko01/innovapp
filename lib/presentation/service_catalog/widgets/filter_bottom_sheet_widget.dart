import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(int) onFiltersApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  RangeValues _priceRange = const RangeValues(0, 3000);
  String _selectedServiceType = 'Tous';
  String _selectedDeliveryTime = 'Tous';
  double _minRating = 0;

  final List<String> _serviceTypes = [
    'Tous',
    'Web Design',
    'Branding',
    'Marketing',
    'Development'
  ];

  final List<String> _deliveryTimes = [
    'Tous',
    '1-3 jours',
    '3-7 jours',
    '1-2 semaines',
    '2-4 semaines'
  ];

  int _getActiveFiltersCount() {
    int count = 0;
    if (_priceRange.start > 0 || _priceRange.end < 3000) count++;
    if (_selectedServiceType != 'Tous') count++;
    if (_selectedDeliveryTime != 'Tous') count++;
    if (_minRating > 0) count++;
    return count;
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 3000);
      _selectedServiceType = 'Tous';
      _selectedDeliveryTime = 'Tous';
      _minRating = 0;
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_getActiveFiltersCount());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeSection(),
                  SizedBox(height: 3.h),
                  _buildServiceTypeSection(),
                  SizedBox(height: 3.h),
                  _buildDeliveryTimeSection(),
                  SizedBox(height: 3.h),
                  _buildRatingSection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Filtres',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Réinitialiser'),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.neutralMedium,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return _buildExpandableSection(
      title: 'Fourchette de prix',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 3000,
            divisions: 30,
            labels: RangeLabels(
              '${_priceRange.start.round()}€',
              '${_priceRange.end.round()}€',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_priceRange.start.round()}€',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_priceRange.end.round()}€',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeSection() {
    return _buildExpandableSection(
      title: 'Type de service',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _serviceTypes.map((type) {
          return FilterChip(
            label: Text(type),
            selected: _selectedServiceType == type,
            onSelected: (selected) {
              setState(() {
                _selectedServiceType = selected ? type : 'Tous';
              });
            },
            selectedColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
            checkmarkColor: AppTheme.primaryOrange,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeliveryTimeSection() {
    return _buildExpandableSection(
      title: 'Délai de livraison',
      child: Column(
        children: _deliveryTimes.map((time) {
          return RadioListTile<String>(
            title: Text(time),
            value: time,
            groupValue: _selectedDeliveryTime,
            onChanged: (value) {
              setState(() {
                _selectedDeliveryTime = value ?? 'Tous';
              });
            },
            activeColor: AppTheme.primaryOrange,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingSection() {
    return _buildExpandableSection(
      title: 'Note minimum',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10,
            label: _minRating == 0
                ? 'Toutes'
                : '${_minRating.toStringAsFixed(1)} étoiles',
            onChanged: (value) {
              setState(() {
                _minRating = value;
              });
            },
          ),
          Row(
            children: [
              for (int i = 1; i <= 5; i++)
                Padding(
                  padding: EdgeInsets.only(right: 1.w),
                  child: CustomIconWidget(
                    iconName: i <= _minRating ? 'star' : 'star_border',
                    color: AppTheme.warningAmber,
                    size: 20,
                  ),
                ),
              SizedBox(width: 2.w),
              Text(
                _minRating == 0
                    ? 'Toutes les notes'
                    : '${_minRating.toStringAsFixed(1)} et plus',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.neutralMedium.withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text(
                'Appliquer (${_getActiveFiltersCount()})',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
