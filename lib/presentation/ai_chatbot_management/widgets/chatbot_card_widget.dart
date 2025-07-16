import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatbotCardWidget extends StatelessWidget {
  final Map<String, dynamic> chatbot;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool) onToggle;
  final VoidCallback onOpenWhatsApp;

  const ChatbotCardWidget({
    Key? key,
    required this.chatbot,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.onOpenWhatsApp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = chatbot['settings'] as Map<String, dynamic>? ?? {};
    final isActive = chatbot['is_active'] as bool? ?? false;
    final createdAt = DateTime.parse(chatbot['created_at'] as String);
    final features = (settings['features'] as List<dynamic>?) ?? [];

    return Card(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and actions
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'smart_toy',
                    color: AppTheme.accentPurple,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatbot['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.successGreen
                                  : AppTheme.neutralMedium,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isActive ? 'Actif' : 'Inactif',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.surfaceWhite,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Créé le ${_formatDate(createdAt)}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                      case 'share':
                        _shareWhatsAppLink();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Modifier'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share, size: 18),
                          SizedBox(width: 8),
                          Text('Partager'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete,
                              size: 18, color: AppTheme.errorRed),
                          SizedBox(width: 8),
                          Text('Supprimer',
                              style: TextStyle(color: AppTheme.errorRed)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (chatbot['description'] != null) ...[
              SizedBox(height: 2.h),
              Text(
                chatbot['description'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ],

            SizedBox(height: 2.h),

            // Features
            if (features.isNotEmpty) ...[
              Text(
                'Fonctionnalités:',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: features.map((feature) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _getFeatureLabel(feature.toString()),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 2.h),
            ],

            // Action buttons
            Row(
              children: [
                // Toggle switch
                Row(
                  children: [
                    Switch(
                      value: isActive,
                      onChanged: onToggle,
                      activeColor: AppTheme.successGreen,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Activé',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // WhatsApp button
                if (settings['whatsapp_number'] != null) ...[
                  OutlinedButton.icon(
                    onPressed: onOpenWhatsApp,
                    icon: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.successGreen,
                      size: 4.w,
                    ),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.successGreen,
                      side: const BorderSide(color: AppTheme.successGreen),
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],
                // Edit button
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Modifier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: AppTheme.surfaceWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _getFeatureLabel(String feature) {
    switch (feature) {
      case 'whatsapp':
        return 'WhatsApp';
      case 'auto_response':
        return 'Réponse automatique';
      case 'multilingual':
        return 'Multilingue';
      case 'analytics':
        return 'Analyses';
      case 'custom_personality':
        return 'Personnalité personnalisée';
      default:
        return feature;
    }
  }

  void _shareWhatsAppLink() {
    final settings = chatbot['settings'] as Map<String, dynamic>? ?? {};
    final whatsappNumber = settings['whatsapp_number'] as String? ?? '';

    if (whatsappNumber.isNotEmpty) {
      final shareText =
          'Découvrez mon chatbot IA "${chatbot['name']}" sur WhatsApp: https://wa.me/$whatsappNumber';
      Share.share(shareText);
    }
  }
}
