import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/supabase_service.dart';

class AiSettingsPage extends StatefulWidget {
  const AiSettingsPage({Key? key}) : super(key: key);

  @override
  State<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends State<AiSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseService = SupabaseService();
  
  // Form controllers
  final _businessNameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _welcomeMessageController = TextEditingController();
  
  // Form state
  bool _dailySummary = true;
  String _selectedPlan = 'Basic';
  bool _isLoading = false;
  bool _isSaving = false;

  final List<String> _subscriptionPlans = ['Basic', 'Pro', 'Premium'];

  @override
  void initState() {
    super.initState();
    _loadAiSettings();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _whatsappController.dispose();
    _welcomeMessageController.dispose();
    super.dispose();
  }

  Future<void> _loadAiSettings() async {
    setState(() => _isLoading = true);
    
    try {
      // Load user's AI chatbot settings
      final chatbots = await _supabaseService.getUserChatbots();
      if (chatbots.isNotEmpty && mounted) {
        final chatbot = chatbots.first;
        final settings = chatbot['settings'] as Map<String, dynamic>? ?? {};
        
        setState(() {
          _businessNameController.text = chatbot['name'] ?? '';
          _whatsappController.text = settings['whatsapp_number'] ?? '';
          _welcomeMessageController.text = settings['welcome_message'] ?? 'Bonjour! Comment puis-je vous aider aujourd\'hui?';
          _dailySummary = settings['daily_summary'] ?? true;
          _selectedPlan = settings['subscription_plan'] ?? 'Basic';
        });
      }
    } catch (error) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Erreur lors du chargement des paramètres',
          backgroundColor: AppTheme.errorRed,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final chatbots = await _supabaseService.getUserChatbots();
      
      final settingsData = {
        'whatsapp_number': _whatsappController.text.trim(),
        'welcome_message': _welcomeMessageController.text.trim(),
        'daily_summary': _dailySummary,
        'subscription_plan': _selectedPlan,
      };

      if (chatbots.isNotEmpty) {
        // Update existing chatbot
        await _supabaseService.updateChatbot(
          chatbots.first['id'],
          {
            'name': _businessNameController.text.trim(),
            'settings': settingsData,
          },
        );
      } else {
        // Create new chatbot
        await _supabaseService.createChatbot({
          'name': _businessNameController.text.trim(),
          'description': 'Assistant IA pour ${_businessNameController.text.trim()}',
          'settings': settingsData,
        });
      }

      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Paramètres sauvegardés avec succès',
          backgroundColor: AppTheme.successGreen,
        );
      }
    } catch (error) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Erreur lors de la sauvegarde: ${error.toString()}',
          backgroundColor: AppTheme.errorRed,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Paramètres IA',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryOrange.withValues(alpha: 0.1),
                            AppTheme.primaryBlue.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.smart_toy,
                              color: AppTheme.primaryOrange,
                              size: 8.w,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Configuration IA',
                                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.neutralDark,
                                  ),
                                ),
                                Text(
                                  'Personnalisez votre assistant intelligent',
                                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.neutralMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Business Information Section
                    _buildSection(
                      title: 'Informations Business',
                      icon: Icons.business,
                      children: [
                        TextFormField(
                          controller: _businessNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nom de l\'entreprise *',
                            hintText: 'Inno\'v Group',
                            prefixIcon: Icon(Icons.business),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le nom de l\'entreprise est requis';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        TextFormField(
                          controller: _whatsappController,
                          decoration: const InputDecoration(
                            labelText: 'Numéro WhatsApp *',
                            hintText: '+33612345678',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le numéro WhatsApp est requis';
                            }
                            if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                              return 'Format de numéro invalide';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // AI Configuration Section
                    _buildSection(
                      title: 'Configuration IA',
                      icon: Icons.psychology,
                      children: [
                        TextFormField(
                          controller: _welcomeMessageController,
                          decoration: const InputDecoration(
                            labelText: 'Message de bienvenue *',
                            hintText: 'Bonjour! Comment puis-je vous aider?',
                            prefixIcon: Icon(Icons.message),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le message de bienvenue est requis';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2.h),
                        SwitchListTile(
                          title: const Text('Résumé quotidien'),
                          subtitle: const Text('Recevoir un résumé des conversations chaque jour'),
                          value: _dailySummary,
                          onChanged: (value) {
                            setState(() {
                              _dailySummary = value;
                            });
                          },
                          activeColor: AppTheme.primaryOrange,
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Subscription Section
                    _buildSection(
                      title: 'Plan d\'abonnement',
                      icon: Icons.workspace_premium,
                      children: [
                        ...(_subscriptionPlans.map((plan) {
                          return RadioListTile<String>(
                            title: Text(plan),
                            subtitle: Text(_getPlanDescription(plan)),
                            value: plan,
                            groupValue: _selectedPlan,
                            onChanged: (value) {
                              setState(() {
                                _selectedPlan = value!;
                              });
                            },
                            activeColor: AppTheme.primaryOrange,
                          );
                        }).toList()),
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppTheme.primaryBlue,
                                size: 5.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  'Vous pouvez changer de plan à tout moment depuis la page d\'abonnement.',
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

                    SizedBox(height: 4.h),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppTheme.surfaceWhite,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Sauvegarder les paramètres',
                                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                                  color: AppTheme.surfaceWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryOrange,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  String _getPlanDescription(String plan) {
    switch (plan) {
      case 'Basic':
        return '100 messages/mois - 29€';
      case 'Pro':
        return '500 messages/mois - 79€';
      case 'Premium':
        return 'Messages illimités - 149€';
      default:
        return '';
    }
  }
}