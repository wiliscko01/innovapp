import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetDeliveryWidget extends StatefulWidget {
  final double budgetRange;
  final DateTime? deliveryDate;
  final Function(double) onBudgetChanged;
  final Function(DateTime) onDeliveryDateChanged;

  const BudgetDeliveryWidget({
    Key? key,
    required this.budgetRange,
    required this.deliveryDate,
    required this.onBudgetChanged,
    required this.onDeliveryDateChanged,
  }) : super(key: key);

  @override
  State<BudgetDeliveryWidget> createState() => _BudgetDeliveryWidgetState();
}

class _BudgetDeliveryWidgetState extends State<BudgetDeliveryWidget> {
  String selectedPriority = 'Standard';
  String selectedDeliveryType = 'Livraison complète';

  final List<Map<String, dynamic>> priorityOptions = [
    {
      "name": "Standard",
      "description": "Délai normal",
      "multiplier": 1.0,
      "icon": "schedule",
    },
    {
      "name": "Urgent",
      "description": "Livraison rapide (+20%)",
      "multiplier": 1.2,
      "icon": "flash_on",
    },
    {
      "name": "Express",
      "description": "Livraison express (+50%)",
      "multiplier": 1.5,
      "icon": "rocket_launch",
    },
  ];

  final List<Map<String, dynamic>> deliveryOptions = [
    {
      "name": "Livraison complète",
      "description": "Projet livré en une fois",
      "icon": "inventory",
    },
    {
      "name": "Livraison par étapes",
      "description": "Livraison progressive",
      "icon": "timeline",
    },
  ];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.deliveryDate ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      locale: Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.primaryOrange,
              headerForegroundColor: Colors.white,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return AppTheme.lightTheme.colorScheme.onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryOrange;
                }
                return null;
              }),
              todayForegroundColor:
                  WidgetStateProperty.all(AppTheme.primaryOrange),
              todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
              todayBorder: BorderSide(color: AppTheme.primaryOrange),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDeliveryDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget et livraison',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Définissez votre budget et vos préférences de livraison',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralMedium,
            ),
          ),
          SizedBox(height: 3.h),

          // Budget Range Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(color: AppTheme.lightTheme.dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget estimé',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '500€',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutralMedium,
                      ),
                    ),
                    Text(
                      '${widget.budgetRange.toStringAsFixed(0)}€',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '10000€',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutralMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.primaryOrange,
                    inactiveTrackColor: AppTheme.neutralLight,
                    thumbColor: AppTheme.primaryOrange,
                    overlayColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: widget.budgetRange,
                    min: 500,
                    max: 10000,
                    divisions: 19,
                    onChanged: widget.onBudgetChanged,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Ce budget est indicatif et peut être ajusté selon vos besoins spécifiques.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralMedium,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Delivery Date Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(color: AppTheme.lightTheme.dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date de livraison souhaitée *',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppTheme.lightTheme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: AppTheme.primaryOrange,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            widget.deliveryDate != null
                                ? _formatDate(widget.deliveryDate!)
                                : 'Sélectionner une date',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: widget.deliveryDate != null
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                  : AppTheme.neutralMedium,
                            ),
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'arrow_drop_down',
                          color: AppTheme.neutralMedium,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Priority Section
          Text(
            'Priorité du projet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: priorityOptions.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final option = priorityOptions[index];
              final isSelected = selectedPriority == option['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPriority = option['name'];
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryOrange
                          : AppTheme.lightTheme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryOrange
                              : AppTheme.neutralLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: option['icon'],
                          color: isSelected
                              ? Colors.white
                              : AppTheme.neutralMedium,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['name'],
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.primaryOrange
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              option['description'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.neutralMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.primaryOrange,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Delivery Type Section
          Text(
            'Type de livraison',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: deliveryOptions.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final option = deliveryOptions[index];
              final isSelected = selectedDeliveryType == option['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDeliveryType = option['name'];
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.lightTheme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.neutralLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: option['icon'],
                          color: isSelected
                              ? Colors.white
                              : AppTheme.neutralMedium,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['name'],
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              option['description'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.neutralMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.primaryBlue,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Summary info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.successGreen,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Un devis détaillé vous sera envoyé dans les 24h après validation de votre commande.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.successGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
