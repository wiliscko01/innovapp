import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceSectionsWidget extends StatefulWidget {
  final String description;
  final List<String> included;
  final String deliveryTime;
  final List<String> requirements;

  const ServiceSectionsWidget({
    Key? key,
    required this.description,
    required this.included,
    required this.deliveryTime,
    required this.requirements,
  }) : super(key: key);

  @override
  State<ServiceSectionsWidget> createState() => _ServiceSectionsWidgetState();
}

class _ServiceSectionsWidgetState extends State<ServiceSectionsWidget> {
  bool _isDescriptionExpanded = false;
  bool _isIncludedExpanded = true;
  bool _isDeliveryExpanded = false;
  bool _isRequirementsExpanded = false;
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          // Description Section
          _buildExpandableSection(
            title: 'Description du service',
            isExpanded: _isDescriptionExpanded,
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _showFullDescription
                      ? widget.description
                      : widget.description.length > 200
                          ? '${widget.description.substring(0, 200)}...'
                          : widget.description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
                if (widget.description.length > 200) ...[
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showFullDescription = !_showFullDescription;
                      });
                    },
                    child: Text(
                      _showFullDescription ? 'Voir moins' : 'Lire plus',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // What's Included Section
          _buildExpandableSection(
            title: 'Ce qui est inclus',
            isExpanded: _isIncludedExpanded,
            onTap: () {
              setState(() {
                _isIncludedExpanded = !_isIncludedExpanded;
              });
            },
            child: Column(
              children: widget.included.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successGreen,
                        size: 4.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Delivery Timeline Section
          _buildExpandableSection(
            title: 'Délai de livraison',
            isExpanded: _isDeliveryExpanded,
            onTap: () {
              setState(() {
                _isDeliveryExpanded = !_isDeliveryExpanded;
              });
            },
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.primaryBlue,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  widget.deliveryTime,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          // Requirements Section
          _buildExpandableSection(
            title: 'Prérequis',
            isExpanded: _isRequirementsExpanded,
            onTap: () {
              setState(() {
                _isRequirementsExpanded = !_isRequirementsExpanded;
              });
            },
            child: Column(
              children: widget.requirements.map((requirement) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconWidget(
                        iconName: 'info_outline',
                        color: AppTheme.warningAmber,
                        size: 4.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          requirement,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                    child: child,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
