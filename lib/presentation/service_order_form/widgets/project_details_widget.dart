import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectDetailsWidget extends StatefulWidget {
  final String projectDescription;
  final String contactEmail;
  final String contactPhone;
  final String additionalRequirements;
  final Function(String) onProjectDescriptionChanged;
  final Function(String) onContactEmailChanged;
  final Function(String) onContactPhoneChanged;
  final Function(String) onAdditionalRequirementsChanged;

  const ProjectDetailsWidget({
    Key? key,
    required this.projectDescription,
    required this.contactEmail,
    required this.contactPhone,
    required this.additionalRequirements,
    required this.onProjectDescriptionChanged,
    required this.onContactEmailChanged,
    required this.onContactPhoneChanged,
    required this.onAdditionalRequirementsChanged,
  }) : super(key: key);

  @override
  State<ProjectDetailsWidget> createState() => _ProjectDetailsWidgetState();
}

class _ProjectDetailsWidgetState extends State<ProjectDetailsWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();

  bool _isDescriptionExpanded = false;
  bool _isRequirementsExpanded = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.projectDescription;
    _emailController.text = widget.contactEmail;
    _phoneController.text = widget.contactPhone;
    _requirementsController.text = widget.additionalRequirements;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails du projet',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Décrivez votre projet en détail pour obtenir un devis précis',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralMedium,
            ),
          ),
          SizedBox(height: 3.h),

          // Project Description Section
          _buildCollapsibleSection(
            title: 'Description du projet *',
            isExpanded: _isDescriptionExpanded,
            onToggle: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    hintText:
                        'Décrivez votre projet, vos objectifs, votre public cible...',
                    counterText: '${_descriptionController.text.length}/1000',
                  ),
                  onChanged: widget.onProjectDescriptionChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La description du projet est requise';
                    }
                    if (value.length < 50) {
                      return 'La description doit contenir au moins 50 caractères';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Contact Information Section
          _buildCollapsibleSection(
            title: 'Informations de contact *',
            isExpanded: true,
            onToggle: () {},
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    hintText: 'votre.email@exemple.com',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'email',
                        color: AppTheme.neutralMedium,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: widget.onContactEmailChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'L\'email est requis';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$')
                        .hasMatch(value)) {
                      return 'Format d\'email invalide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Téléphone (optionnel)',
                    hintText: '0123456789',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.neutralMedium,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: widget.onContactPhoneChanged,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Technical Requirements Section
          _buildCollapsibleSection(
            title: 'Exigences techniques',
            isExpanded: _isRequirementsExpanded,
            onToggle: () {
              setState(() {
                _isRequirementsExpanded = !_isRequirementsExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spécifications techniques, contraintes, intégrations requises...',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralMedium,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _requirementsController,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText:
                        'Décrivez vos exigences techniques spécifiques...',
                    counterText: '${_requirementsController.text.length}/500',
                  ),
                  onChanged: widget.onAdditionalRequirementsChanged,
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Help section
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Plus votre description est détaillée, plus notre devis sera précis et adapté à vos besoins.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryBlue,
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

  Widget _buildCollapsibleSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightTheme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                  bottom: isExpanded ? Radius.zero : Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.neutralMedium,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: EdgeInsets.all(3.w),
              child: child,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }
}
