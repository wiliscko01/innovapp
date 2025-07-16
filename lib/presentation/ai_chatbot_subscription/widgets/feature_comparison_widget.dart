import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeatureComparisonWidget extends StatelessWidget {
  final List<Map<String, dynamic>> plans;
  final VoidCallback onClose;

  const FeatureComparisonWidget({
    Key? key,
    required this.plans,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a comprehensive feature list
    final List<String> allFeatures = [
      'Messages WhatsApp/mois',
      'IA conversationnelle',
      'Personnalisation des réponses',
      'Support technique',
      'Intégration WhatsApp Business',
      'Rapports et analytics',
      'Intégration CRM',
      'Gestion multi-agents',
      'Templates personnalisés',
      'API personnalisée',
      'Formation équipe',
      'Gestion multi-comptes',
      'Sauvegarde renforcée',
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comparaison des fonctionnalités',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryOrange,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.primaryOrange,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Comparison table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: DataTable(
                columnSpacing: 4.w,
                headingRowColor: WidgetStateProperty.all(
                  AppTheme.neutralLight,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'Fonctionnalité',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...plans.map((plan) {
                    return DataColumn(
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            plan['name'],
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: plan['isRecommended']
                                  ? AppTheme.primaryOrange
                                  : AppTheme.neutralDark,
                            ),
                          ),
                          Text(
                            '${plan['currency']}${plan['price']}/${plan['period']}',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.neutralMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
                rows: _buildComparisonRows(allFeatures),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildComparisonRows(List<String> features) {
    return features.map((feature) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              feature,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...plans.map((plan) {
            return DataCell(
              _getFeatureValue(feature, plan),
            );
          }).toList(),
        ],
      );
    }).toList();
  }

  Widget _getFeatureValue(String feature, Map<String, dynamic> plan) {
    final String planId = plan['id'];

    switch (feature) {
      case 'Messages WhatsApp/mois':
        if (planId == 'basic') return _buildValueText('100');
        if (planId == 'pro') return _buildValueText('500');
        if (planId == 'premium') return _buildValueText('Illimité');
        break;

      case 'IA conversationnelle':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(true);
        if (planId == 'premium') return _buildValueText('Ultra-performante');
        break;

      case 'Personnalisation des réponses':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(true);
        if (planId == 'premium') return _buildValueText('Complète');
        break;

      case 'Support technique':
        if (planId == 'basic') return _buildValueText('Email');
        if (planId == 'pro') return _buildValueText('24/7');
        if (planId == 'premium') return _buildValueText('Dédié 24/7');
        break;

      case 'Intégration WhatsApp Business':
        return _buildCheckIcon(true);

      case 'Rapports et analytics':
        if (planId == 'basic') return _buildValueText('Mensuels');
        if (planId == 'pro') return _buildValueText('Temps réel');
        if (planId == 'premium') return _buildValueText('Avancés');
        break;

      case 'Intégration CRM':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(true);
        if (planId == 'premium') return _buildValueText('Avancées');
        break;

      case 'Gestion multi-agents':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(true);
        if (planId == 'premium') return _buildCheckIcon(true);
        break;

      case 'Templates personnalisés':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(true);
        if (planId == 'premium') return _buildCheckIcon(true);
        break;

      case 'API personnalisée':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(false);
        if (planId == 'premium') return _buildCheckIcon(true);
        break;

      case 'Formation équipe':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(false);
        if (planId == 'premium') return _buildCheckIcon(true);
        break;

      case 'Gestion multi-comptes':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(false);
        if (planId == 'premium') return _buildCheckIcon(true);
        break;

      case 'Sauvegarde renforcée':
        if (planId == 'basic') return _buildCheckIcon(false);
        if (planId == 'pro') return _buildCheckIcon(false);
        if (planId == 'premium') return _buildCheckIcon(true);
        break;

      default:
        return _buildCheckIcon(false);
    }

    return _buildCheckIcon(false);
  }

  Widget _buildCheckIcon(bool isAvailable) {
    return CustomIconWidget(
      iconName: isAvailable ? 'check_circle' : 'cancel',
      color: isAvailable ? AppTheme.successGreen : AppTheme.neutralMedium,
      size: 20,
    );
  }

  Widget _buildValueText(String value) {
    return Text(
      value,
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppTheme.neutralDark,
      ),
      textAlign: TextAlign.center,
    );
  }
}
