import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomActionWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isFormValid;
  final double totalPrice;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onProceedToPayment;

  const BottomActionWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.isFormValid,
    required this.totalPrice,
    required this.onPrevious,
    required this.onNext,
    required this.onProceedToPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price summary (only show on last step)
            if (isLastStep && totalPrice > 0) ...[
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total estimé',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutralMedium,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${totalPrice.toStringAsFixed(0)}€',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Remise mobile -10%',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomIconWidget(
                      iconName: 'local_offer',
                      color: AppTheme.primaryOrange,
                      size: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Action buttons
            Row(
              children: [
                // Previous button
                if (currentStep > 0)
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: onPrevious,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        side: BorderSide(color: AppTheme.neutralMedium),
                        foregroundColor: AppTheme.neutralMedium,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.neutralMedium,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Précédent',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (currentStep > 0) SizedBox(width: 3.w),

                // Next/Continue button
                Expanded(
                  flex: currentStep > 0 ? 2 : 1,
                  child: ElevatedButton(
                    onPressed: isLastStep
                        ? (isFormValid ? onProceedToPayment : null)
                        : onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLastStep && isFormValid
                          ? AppTheme.successGreen
                          : AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      elevation: 2,
                      disabledBackgroundColor: AppTheme.neutralMedium,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLastStep) ...[
                          CustomIconWidget(
                            iconName: 'payment',
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Continuer vers le paiement',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Suivant',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Form validation message
            if (isLastStep && !isFormValid) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'error',
                      color: AppTheme.errorRed,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Veuillez remplir tous les champs obligatoires',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Progress indicator dots
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (index) {
                final isActive = index <= currentStep;
                final isCurrent = index == currentStep;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: isCurrent ? 8.w : 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.primaryOrange
                        : AppTheme.neutralLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
