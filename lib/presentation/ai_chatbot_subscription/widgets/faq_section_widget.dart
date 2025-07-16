import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FaqSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> faqData;

  const FaqSectionWidget({
    Key? key,
    required this.faqData,
  }) : super(key: key);

  @override
  State<FaqSectionWidget> createState() => _FaqSectionWidgetState();
}

class _FaqSectionWidgetState extends State<FaqSectionWidget> {
  int? expandedIndex;

  void _toggleExpansion(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neutralMedium.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: widget.faqData.asMap().entries.map((entry) {
          final int index = entry.key;
          final Map<String, dynamic> faq = entry.value;
          final bool isExpanded = expandedIndex == index;

          return Container(
            decoration: BoxDecoration(
              border: index > 0
                  ? Border(
                      top: BorderSide(
                        color: AppTheme.neutralMedium.withValues(alpha: 0.1),
                      ),
                    )
                  : null,
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              childrenPadding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
              title: Text(
                faq['question'],
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralDark,
                ),
              ),
              trailing: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: CustomIconWidget(
                  iconName: 'expand_more',
                  color: AppTheme.primaryOrange,
                  size: 24,
                ),
              ),
              iconColor: AppTheme.primaryOrange,
              collapsedIconColor: AppTheme.neutralMedium,
              onExpansionChanged: (expanded) {
                _toggleExpansion(expanded ? index : -1);
              },
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.neutralLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    faq['answer'],
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.neutralMedium,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
