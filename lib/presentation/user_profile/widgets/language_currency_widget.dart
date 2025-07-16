import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/supabase_service.dart';
import '../../../theme/app_theme.dart';

class LanguageCurrencyWidget extends StatefulWidget {
  final String currentLanguage;
  final String currentCurrency;
  final Function(String, String) onChanged;

  const LanguageCurrencyWidget({
    Key? key,
    required this.currentLanguage,
    required this.currentCurrency,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<LanguageCurrencyWidget> createState() => _LanguageCurrencyWidgetState();
}

class _LanguageCurrencyWidgetState extends State<LanguageCurrencyWidget> {
  final _supabaseService = SupabaseService();

  String _selectedLanguage = 'fr';
  String _selectedCurrency = 'FCFA';
  bool _isLoading = false;

  final Map<String, String> _languages = {
    'fr': 'Français',
    'en': 'English',
    'es': 'Español',
  };

  final Map<String, String> _currencies = {
    'FCFA': 'FCFA (XOF)',
    'EUR': 'Euro (EUR)',
    'USD': 'Dollar US (USD)',
  };

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
    _selectedCurrency = widget.currentCurrency;
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);

    try {
      await _supabaseService.updateUserProfile({
        'language': _selectedLanguage,
        'currency': _selectedCurrency,
      });

      widget.onChanged(_selectedLanguage, _selectedCurrency);

      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Préférences mises à jour avec succès',
          backgroundColor: AppTheme.successGreen,
          textColor: AppTheme.surfaceWhite,
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Erreur lors de la mise à jour: ${error.toString()}',
          backgroundColor: AppTheme.errorRed,
          textColor: AppTheme.surfaceWhite,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Langue et Devise',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Language selection
          Text(
            'Langue de l\'application',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppTheme.neutralMedium.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isExpanded: true,
                items: _languages.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        _buildLanguageFlag(entry.key),
                        SizedBox(width: 3.w),
                        Text(entry.value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Currency selection
          Text(
            'Devise par défaut',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppTheme.neutralMedium.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCurrency,
                isExpanded: true,
                items: _currencies.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        _buildCurrencyIcon(entry.key),
                        SizedBox(width: 3.w),
                        Text(entry.value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
                },
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Currency info
          if (_selectedCurrency == 'FCFA') ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.successGreen),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'FCFA (XOF) est la devise par défaut recommandée pour les services locaux',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 4.h),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppTheme.surfaceWhite,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Sauvegarder',
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
    );
  }

  Widget _buildLanguageFlag(String language) {
    switch (language) {
      case 'fr':
        return Container(
          width: 6.w,
          height: 4.w,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: const Text('🇫🇷', style: TextStyle(fontSize: 16)),
        );
      case 'en':
        return Container(
          width: 6.w,
          height: 4.w,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: const Text('🇺🇸', style: TextStyle(fontSize: 16)),
        );
      case 'es':
        return Container(
          width: 6.w,
          height: 4.w,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: const Text('🇪🇸', style: TextStyle(fontSize: 16)),
        );
      default:
        return Container(
          width: 6.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: AppTheme.neutralMedium,
            borderRadius: BorderRadius.circular(2),
          ),
        );
    }
  }

  Widget _buildCurrencyIcon(String currency) {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          _getCurrencySymbol(currency),
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'FCFA':
        return 'F';
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      default:
        return currency;
    }
  }
}
