import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/faq_section_widget.dart';
import './widgets/feature_comparison_widget.dart';
import './widgets/selected_plan_summary_widget.dart';
import './widgets/subscription_plan_card_widget.dart';

class AiChatbotSubscription extends StatefulWidget {
  const AiChatbotSubscription({Key? key}) : super(key: key);

  @override
  State<AiChatbotSubscription> createState() => _AiChatbotSubscriptionState();
}

class _AiChatbotSubscriptionState extends State<AiChatbotSubscription>
    with TickerProviderStateMixin {
  final _supabaseService = SupabaseService();

  String selectedPlan = 'Pro';
  bool isLoading = false;
  bool _isProcessing = false;
  bool showFeatureComparison = false;
  bool showFAQ = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      "id": "basic",
      "name": "Basic",
      "price": "29",
      "currency": "€",
      "period": "mois",
      "isRecommended": false,
      "isFreeTrial": true,
      "trialDays": 7,
      "features": [
        "100 messages WhatsApp/mois",
        "Réponses automatiques de base",
        "Support par email",
        "Intégration WhatsApp Business",
        "Rapports mensuels"
      ],
      "limitations": [
        "Pas de personnalisation avancée",
        "Support limité aux heures ouvrables"
      ],
      "description":
          "Parfait pour les petites entreprises qui débutent avec l'automatisation WhatsApp"
    },
    {
      "id": "pro",
      "name": "Pro",
      "price": "79",
      "currency": "€",
      "period": "mois",
      "isRecommended": true,
      "isFreeTrial": true,
      "trialDays": 14,
      "features": [
        "500 messages WhatsApp/mois",
        "IA conversationnelle avancée",
        "Personnalisation des réponses",
        "Support prioritaire 24/7",
        "Intégration CRM",
        "Rapports détaillés en temps réel",
        "Gestion multi-agents",
        "Templates de messages personnalisés"
      ],
      "limitations": [],
      "description":
          "Solution complète pour les entreprises en croissance avec besoins avancés"
    },
    {
      "id": "premium",
      "name": "Premium",
      "price": "149",
      "currency": "€",
      "period": "mois",
      "isRecommended": false,
      "isFreeTrial": false,
      "trialDays": 0,
      "features": [
        "Messages WhatsApp illimités",
        "IA ultra-performante avec apprentissage",
        "Personnalisation complète",
        "Support dédié 24/7",
        "Intégrations avancées (Salesforce, HubSpot)",
        "Analytics avancés et prédictifs",
        "API personnalisée",
        "Formation équipe incluse",
        "Gestion multi-comptes",
        "Sauvegarde et sécurité renforcée"
      ],
      "limitations": [],
      "description":
          "Solution enterprise pour les grandes organisations avec besoins spécifiques"
    }
  ];

  final List<Map<String, dynamic>> faqData = [
    {
      "question": "Comment fonctionne l'intégration WhatsApp ?",
      "answer":
          "Notre chatbot s'intègre directement avec WhatsApp Business API. Après l'abonnement, nous configurons votre bot en 24-48h avec vos paramètres personnalisés."
    },
    {
      "question": "Puis-je changer de plan à tout moment ?",
      "answer":
          "Oui, vous pouvez upgrader ou downgrader votre plan à tout moment. Les changements prennent effet immédiatement avec ajustement proportionnel de la facturation."
    },
    {
      "question": "Que se passe-t-il si je dépasse ma limite de messages ?",
      "answer":
          "Vous recevrez une notification à 80% de votre limite. Au-delà, les messages supplémentaires sont facturés 0,05€ par message ou vous pouvez upgrader votre plan."
    },
    {
      "question": "Le bot peut-il comprendre plusieurs langues ?",
      "answer":
          "Oui, nos bots supportent le français, l'anglais, l'espagnol et l'allemand. La détection de langue est automatique selon le plan choisi."
    },
    {
      "question": "Comment annuler mon abonnement ?",
      "answer":
          "Vous pouvez annuler à tout moment depuis votre tableau de bord. L'annulation prend effet à la fin de votre période de facturation actuelle."
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectPlan(String planId) {
    setState(() {
      selectedPlan = planId;
    });
  }

  void _toggleFeatureComparison() {
    setState(() {
      showFeatureComparison = !showFeatureComparison;
    });
  }

  void _toggleFAQ() {
    setState(() {
      showFAQ = !showFAQ;
    });
  }

  Future<void> _proceedToPayment() async {
    setState(() {
      isLoading = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // Show success dialog
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successGreen,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Abonnement activé !',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre chatbot WhatsApp sera configuré dans les 24-48h.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prochaines étapes :',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '1. Vérifiez votre email pour les instructions\n2. Notre équipe vous contactera sous 24h\n3. Configuration et tests du bot\n4. Formation et mise en service',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/home-dashboard');
              },
              child: Text('Retour à l\'accueil'),
            ),
          ],
        );
      },
    );
  }

  void _handleSubscription(Map<String, dynamic> plan) {
    // Check if user is authenticated
    if (!_supabaseService.isAuthenticated) {
      // Navigate to login with return route
      Navigator.pushNamed(
        context,
        AppRoutes.login,
        arguments: AppRoutes.aiChatbotSubscription,
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate subscription process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isProcessing = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Abonnement ${plan['name']} activé avec succès !'),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      // Navigate to AI chatbot management
      Navigator.pushReplacementNamed(context, AppRoutes.aiChatbotManagement);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlanData = subscriptionPlans.firstWhere(
      (plan) => plan['id'] == selectedPlan,
      orElse: () => subscriptionPlans[1],
    );

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        title: Text(
          'Abonnement Chatbot IA',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _toggleFeatureComparison,
            icon: CustomIconWidget(
              iconName: 'compare_arrows',
              color: showFeatureComparison
                  ? AppTheme.primaryOrange
                  : AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Container(
                      width: double.infinity,
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
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'smart_toy',
                            color: AppTheme.primaryOrange,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Chatbot WhatsApp IA',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.neutralDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Automatisez vos conversations WhatsApp avec notre IA avancée. Répondez à vos clients 24/7 et boostez votre productivité.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.neutralMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Feature comparison toggle
                    if (showFeatureComparison) ...[
                      FeatureComparisonWidget(
                        plans: subscriptionPlans,
                        onClose: _toggleFeatureComparison,
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Subscription plans
                    Text(
                      'Choisissez votre plan',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Plans list
                    ...subscriptionPlans.map((plan) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 3.w),
                        child: SubscriptionPlanCardWidget(
                          plan: plan,
                          isSelected: selectedPlan == plan['id'],
                          onSelect: () => _selectPlan(plan['id']),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 3.h),

                    // FAQ Section
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: _toggleFAQ,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Questions fréquentes',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  CustomIconWidget(
                                    iconName:
                                        showFAQ ? 'expand_less' : 'expand_more',
                                    color: AppTheme.primaryOrange,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (showFAQ) ...[
                            FaqSectionWidget(
                              faqData: faqData,
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Terms and conditions
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.neutralLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.neutralMedium.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conditions d\'abonnement',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '• Renouvellement automatique mensuel\n• Annulation possible à tout moment\n• Remboursement sous 30 jours si non satisfait\n• Support technique inclus\n• Conformité RGPD garantie',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.neutralMedium,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h), // Space for bottom sticky area
                  ],
                ),
              ),
            ),

            // Bottom sticky area
            SelectedPlanSummaryWidget(
              selectedPlan: selectedPlanData,
              isLoading: isLoading,
              onProceedToPayment: _proceedToPayment,
            ),
          ],
        ),
      ),
    );
  }
}