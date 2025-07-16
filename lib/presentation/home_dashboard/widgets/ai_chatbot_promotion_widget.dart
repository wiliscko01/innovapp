import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiChatbotPromotionWidget extends StatelessWidget {
  final VoidCallback onPromotionTap;

  const AiChatbotPromotionWidget({
    super.key,
    required this.onPromotionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Assistant IA WhatsApp",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.neutralDark,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPromotionCard(),
        ],
      ),
    );
  }

  Widget _buildPromotionCard() {
    return GestureDetector(
      onTap: onPromotionTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.accentPurple,
              AppTheme.primaryBlue,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentPurple.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // AI Icon
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'smart_toy',
                      color: AppTheme.surfaceWhite,
                      size: 8.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chatbot IA Premium",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.surfaceWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "Assistant intelligent pour WhatsApp Business",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.surfaceWhite.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Features
            Row(
              children: [
                Expanded(
                  child: _buildFeatureItem(
                    icon: 'chat',
                    title: "Réponses 24/7",
                    subtitle: "Support automatique",
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildFeatureItem(
                    icon: 'language',
                    title: "Multi-langues",
                    subtitle: "Français & Anglais",
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildFeatureItem(
                    icon: 'analytics',
                    title: "Analytics",
                    subtitle: "Rapports détaillés",
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Pricing and CTA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "À partir de",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.surfaceWhite.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      "29€/mois",
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.surfaceWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onPromotionTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceWhite,
                    foregroundColor: AppTheme.accentPurple,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 1.5.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Découvrir",
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: AppTheme.accentPurple,
                        size: 4.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.surfaceWhite,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.surfaceWhite,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.surfaceWhite.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
