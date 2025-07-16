import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ChatbotFormWidget extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSubmit;

  const ChatbotFormWidget({
    Key? key,
    this.initialData,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ChatbotFormWidget> createState() => _ChatbotFormWidgetState();
}

class _ChatbotFormWidgetState extends State<ChatbotFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _whatsappController = TextEditingController();

  String _selectedLanguage = 'fr';
  String _selectedPersonality = 'professional';
  List<String> _selectedFeatures = [];

  final List<String> _languages = ['fr', 'en', 'es'];
  final List<String> _personalities = [
    'professional',
    'friendly',
    'casual',
    'expert'
  ];
  final List<String> _availableFeatures = [
    'whatsapp',
    'auto_response',
    'multilingual',
    'analytics',
    'custom_personality'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final data = widget.initialData!;
    final settings = data['settings'] as Map<String, dynamic>? ?? {};

    _nameController.text = data['name'] as String? ?? '';
    _descriptionController.text = data['description'] as String? ?? '';
    _selectedLanguage = settings['language'] as String? ?? 'fr';
    _selectedPersonality = settings['personality'] as String? ?? 'professional';
    _whatsappController.text = settings['whatsapp_number'] as String? ?? '';
    _selectedFeatures =
        List<String>.from(settings['features'] as List<dynamic>? ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'settings': {
        'language': _selectedLanguage,
        'personality': _selectedPersonality,
        'whatsapp_number': _whatsappController.text.trim(),
        'features': _selectedFeatures,
      },
    };

    widget.onSubmit(data);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90.w,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du chatbot',
                hintText: 'Assistant Commercial',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
            ),

            SizedBox(height: 2.h),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Décrivez le rôle de votre chatbot...',
              ),
              maxLines: 3,
            ),

            SizedBox(height: 2.h),

            // Language selection
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Langue principale',
              ),
              items: _languages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(_getLanguageLabel(lang)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),

            SizedBox(height: 2.h),

            // Personality selection
            DropdownButtonFormField<String>(
              value: _selectedPersonality,
              decoration: const InputDecoration(
                labelText: 'Personnalité',
              ),
              items: _personalities.map((personality) {
                return DropdownMenuItem(
                  value: personality,
                  child: Text(_getPersonalityLabel(personality)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPersonality = value!;
                });
              },
            ),

            SizedBox(height: 2.h),

            // WhatsApp number field
            TextFormField(
              controller: _whatsappController,
              decoration: const InputDecoration(
                labelText: 'Numéro WhatsApp',
                hintText: '+33612345678',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                    return 'Veuillez entrer un numéro valide';
                  }
                }
                return null;
              },
            ),

            SizedBox(height: 2.h),

            // Features selection
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
              children: _availableFeatures.map((feature) {
                final isSelected = _selectedFeatures.contains(feature);
                return FilterChip(
                  label: Text(_getFeatureLabel(feature)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFeatures.add(feature);
                      } else {
                        _selectedFeatures.remove(feature);
                      }
                    });
                  },
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryBlue,
                );
              }).toList(),
            ),

            SizedBox(height: 3.h),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  widget.initialData != null ? 'Mettre à jour' : 'Créer',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.surfaceWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageLabel(String language) {
    switch (language) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'Anglais';
      case 'es':
        return 'Espagnol';
      default:
        return language;
    }
  }

  String _getPersonalityLabel(String personality) {
    switch (personality) {
      case 'professional':
        return 'Professionnel';
      case 'friendly':
        return 'Amical';
      case 'casual':
        return 'Décontracté';
      case 'expert':
        return 'Expert';
      default:
        return personality;
    }
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
}
