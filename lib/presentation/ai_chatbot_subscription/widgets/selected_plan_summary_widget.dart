import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SelectedPlanSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> selectedPlan;
  final bool isLoading;
  final VoidCallback onProceedToPayment;

  const SelectedPlanSummaryWidget({
    Key? key,
    required this.selectedPlan,
    required this.isLoading,
    required this.onProceedToPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isFreeTrial = selectedPlan['isFreeTrial'] ?? false;
    final int trialDays = selectedPlan['trialDays'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selected plan summary
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plan sélectionné : ${selectedPlan['name']}',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.neutralDark,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          if (isFreeTrial)
                            Text(
                              '$trialDays jours gratuits, puis ${selectedPlan['currency']}${selectedPlan['price']}/${selectedPlan['period']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.neutralMedium,
                              ),
                            )
                          else
                            Text(
                              '${selectedPlan['currency']}${selectedPlan['price']}/${selectedPlan['period']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.neutralMedium,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      isFreeTrial
                          ? 'GRATUIT'
                          : '${selectedPlan['currency']}${selectedPlan['price']}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isFreeTrial
                            ? AppTheme.successGreen
                            : AppTheme.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Payment information
              if (isFreeTrial)
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
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Aucun paiement requis maintenant. Vous serez facturé après la période d\'essai.',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (isFreeTrial) SizedBox(height: 2.h),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onProceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: AppTheme.surfaceWhite,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.surfaceWhite,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Traitement...',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.surfaceWhite,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: isFreeTrial ? 'play_arrow' : 'payment',
                              color: AppTheme.surfaceWhite,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              isFreeTrial
                                  ? 'Commencer l\'essai gratuit'
                                  : 'Continuer vers le paiement',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.surfaceWhite,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: 1.h),

              // Security and terms
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.neutralMedium,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Paiement sécurisé • Annulation facile',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
