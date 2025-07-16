import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FeexpayPaymentWidget extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final VoidCallback onAddPaymentMethod;
  final Function(String) onRemovePaymentMethod;
  final Function(String) onSetDefault;

  const FeexpayPaymentWidget({
    super.key,
    required this.paymentMethods,
    required this.onAddPaymentMethod,
    required this.onRemovePaymentMethod,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Payment Methods List
        ...paymentMethods.map((method) => _buildPaymentMethodItem(method)),

        SizedBox(height: 2.h),

        // Add Payment Method Button
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onAddPaymentMethod,
            icon: const Icon(Icons.add_card),
            label: const Text('Ajouter une méthode de paiement'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryOrange,
              side: const BorderSide(color: AppTheme.primaryOrange),
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Feexpay Info
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.primaryBlue.withAlpha(77),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.security,
                color: AppTheme.primaryBlue,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paiements sécurisés par Feexpay',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    Text(
                      'Vos informations de paiement sont cryptées et sécurisées.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutralMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildPaymentMethodItem(Map<String, dynamic> method) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: method['isDefault']
              ? AppTheme.primaryOrange
              : AppTheme.neutralLight,
          width: method['isDefault'] ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Card Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getCardColor(method['brand']).withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCardIcon(method['brand']),
              color: _getCardColor(method['brand']),
              size: 6.w,
            ),
          ),

          SizedBox(width: 3.w),

          // Card Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getCardBrandName(method['brand'])} •••• ${method['last4']}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralDark,
                  ),
                ),
                if (method['isDefault'])
                  Text(
                    'Méthode par défaut',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'set_default':
                  onSetDefault(method['id']);
                  break;
                case 'remove':
                  onRemovePaymentMethod(method['id']);
                  break;
              }
            },
            itemBuilder: (context) => [
              if (!method['isDefault'])
                PopupMenuItem(
                  value: 'set_default',
                  child: Row(
                    children: [
                      Icon(Icons.star,
                          size: 4.w, color: AppTheme.neutralMedium),
                      SizedBox(width: 2.w),
                      const Text('Définir par défaut'),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 4.w, color: AppTheme.errorRed),
                    SizedBox(width: 2.w),
                    const Text('Supprimer'),
                  ],
                ),
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: AppTheme.neutralMedium,
              size: 5.w,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCardIcon(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  Color _getCardColor(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return AppTheme.primaryBlue;
      case 'mastercard':
        return AppTheme.warningAmber;
      case 'amex':
        return AppTheme.successGreen;
      default:
        return AppTheme.neutralMedium;
    }
  }

  String _getCardBrandName(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'amex':
        return 'American Express';
      default:
        return 'Carte';
    }
  }
}
