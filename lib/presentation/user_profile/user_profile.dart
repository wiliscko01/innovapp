import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/feexpay_payment_widget.dart';
import './widgets/language_currency_widget.dart';
import './widgets/order_history_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/subscription_card_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;

  // User data
  Map<String, dynamic> _userData = {
    'name': 'Jean Dupont',
    'email': 'jean.dupont@example.com',
    'phone': '+33 6 12 34 56 78',
    'location': 'Paris, France',
    'memberSince': '2024-01-15',
    'language': 'fr',
    'currency': 'FCFA',
    'avatar':
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'totalOrders': 15,
    'completedOrders': 12,
    'activeSubscriptions': 1,
  };

  // Recent orders
  final List<Map<String, dynamic>> _recentOrders = [
    {
      'id': 'ORD-2025-001',
      'serviceName': 'Logo Design Premium',
      'completionDate': '2025-07-15',
      'price': '179€',
      'status': 'Terminé',
      'rating': 5,
      'thumbnail':
          'https://images.unsplash.com/photo-1626785774573-4b799315345d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    },
    {
      'id': 'ORD-2025-002',
      'serviceName': 'Site Web Responsive',
      'completionDate': '2025-07-10',
      'price': '809€',
      'status': 'Terminé',
      'rating': 4,
      'thumbnail':
          'https://images.pexels.com/photos/196644/pexels-photo-196644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    },
    {
      'id': 'ORD-2025-003',
      'serviceName': 'Campagne Facebook Ads',
      'completionDate': '2025-07-05',
      'price': '269€',
      'status': 'Terminé',
      'rating': 5,
      'thumbnail':
          'https://images.pixabay.com/photo/2017/01/18/16/46/social-media-1989152_1280.jpg',
    },
  ];

  // Active subscription
  final Map<String, dynamic> _activeSubscription = {
    'planName': 'Chatbot IA Premium',
    'planType': 'Premium',
    'monthlyPrice': '49€',
    'renewalDate': '2025-08-15',
    'messagesUsed': 2847,
    'messagesLimit': 5000,
    'features': [
      'Réponses IA avancées',
      'Intégration WhatsApp',
      'Personnalisation complète',
      'Support prioritaire',
    ],
  };

  // Feexpay payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'card_001',
      'type': 'card',
      'last4': '4242',
      'brand': 'visa',
      'isDefault': true,
    },
    {
      'id': 'card_002',
      'type': 'card',
      'last4': '8888',
      'brand': 'mastercard',
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 4; // Set Profile tab as active
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userData: _userData,
              isEditing: _isEditing,
              onEdit: () => setState(() => _isEditing = !_isEditing),
              onSave: _handleSaveProfile,
              onAvatarChange: _handleAvatarChange,
            ),

            SizedBox(height: 3.h),

            // Profile Sections
            Container(
              color: AppTheme.surfaceWhite,
              child: Column(
                children: [
                  // Personal Information Section
                  ProfileSectionWidget(
                    title: 'Informations Personnelles',
                    icon: Icons.person,
                    isExpanded: true,
                    children: [
                      _buildInfoTile('Nom', _userData['name'], Icons.badge),
                      _buildInfoTile('Email', _userData['email'], Icons.email),
                      _buildInfoTile(
                          'Téléphone', _userData['phone'], Icons.phone),
                      _buildInfoTile('Localisation', _userData['location'],
                          Icons.location_on),
                      _buildInfoTile(
                          'Membre depuis',
                          _formatDate(_userData['memberSince']),
                          Icons.calendar_today),
                    ],
                  ),

                  // Order History Section
                  ProfileSectionWidget(
                    title: 'Historique des Commandes',
                    icon: Icons.history,
                    isExpanded: false,
                    children: [
                      OrderHistoryWidget(
                        orders: _recentOrders,
                        onOrderTap: _handleOrderTap,
                        onReorderTap: _handleReorderTap,
                      ),
                    ],
                  ),

                  // Active Subscriptions Section
                  ProfileSectionWidget(
                    title: 'Abonnements Actifs',
                    icon: Icons.subscriptions,
                    isExpanded: false,
                    children: [
                      SubscriptionCardWidget(
                        subscription: _activeSubscription,
                        onUpgrade: _handleUpgradeSubscription,
                        onCancel: _handleCancelSubscription,
                      ),
                    ],
                  ),

                  // Payment Methods Section (Feexpay)
                  ProfileSectionWidget(
                    title: 'Méthodes de Paiement',
                    icon: Icons.payment,
                    isExpanded: false,
                    children: [
                      FeexpayPaymentWidget(
                        paymentMethods: _paymentMethods,
                        onAddPaymentMethod: _handleAddFeexpayPayment,
                        onRemovePaymentMethod: _handleRemoveFeexpayPayment,
                        onSetDefault: _handleSetDefaultPayment,
                      ),
                    ],
                  ),

                  // Settings Section
                  ProfileSectionWidget(
                    title: 'Paramètres',
                    icon: Icons.settings,
                    isExpanded: false,
                    children: [
                      _buildSettingsTile('Notifications', Icons.notifications,
                          () => _handleNotificationSettings()),
                      _buildSettingsTile('Langue et Devise', Icons.language,
                          () => _handleLanguageSettings()),
                      _buildSettingsTile('Confidentialité', Icons.privacy_tip,
                          () => _handlePrivacySettings()),
                      _buildSettingsTile('Aide & Support', Icons.help,
                          () => _handleHelpSupport()),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Logout Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleLogout,
                        icon:
                            const Icon(Icons.logout, color: AppTheme.errorRed),
                        label: const Text('Déconnexion'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.errorRed,
                          side: const BorderSide(color: AppTheme.errorRed),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      title: Text(
        'Mon Profil',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (_isEditing)
          TextButton(
            onPressed: () => setState(() => _isEditing = false),
            child: const Text('Annuler'),
          ),
        IconButton(
          onPressed: () => setState(() => _isEditing = !_isEditing),
          icon: Icon(
            _isEditing ? Icons.save : Icons.edit,
            color: AppTheme.primaryOrange,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryOrange),
      title: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.neutralMedium,
        ),
      ),
      subtitle: Text(
        value,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: _isEditing
          ? const Icon(Icons.edit, color: AppTheme.neutralMedium)
          : null,
      onTap: _isEditing ? () => _handleEditField(label, value) : null,
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryOrange),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.neutralMedium),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.neutralMedium,
              size: 6.w,
            ),
            text: "Accueil",
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'grid_view',
              color: AppTheme.neutralMedium,
              size: 6.w,
            ),
            text: "Services",
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'shopping_bag_outlined',
              color: AppTheme.neutralMedium,
              size: 6.w,
            ),
            text: "Commandes",
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'smart_toy',
              color: AppTheme.neutralMedium,
              size: 6.w,
            ),
            text: "IA",
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person_outline',
              color: AppTheme.primaryOrange,
              size: 6.w,
            ),
            text: "Profil",
          ),
        ],
        labelColor: AppTheme.primaryOrange,
        unselectedLabelColor: AppTheme.neutralMedium,
        indicatorColor: AppTheme.primaryOrange,
        labelStyle: AppTheme.lightTheme.textTheme.labelSmall,
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
        onTap: _handleTabTap,
      ),
    );
  }

  // Event handlers
  void _handleSaveProfile() {
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil sauvegardé avec succès'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _handleAvatarChange() {
    // Implement avatar change functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de changement d\'avatar'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _handleEditField(String label, String value) {
    // Implement field editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Édition du champ: $label'),
        backgroundColor: AppTheme.warningAmber,
      ),
    );
  }

  void _handleOrderTap(Map<String, dynamic> order) {
    Navigator.pushNamed(context, AppRoutes.orderTracking);
  }

  void _handleReorderTap(Map<String, dynamic> order) {
    Navigator.pushNamed(context, AppRoutes.serviceCatalog);
  }

  void _handleUpgradeSubscription() {
    Navigator.pushNamed(context, AppRoutes.aiChatbotSubscription);
  }

  void _handleCancelSubscription() {
    // Implement subscription cancellation with Feexpay
    _showCancelSubscriptionDialog();
  }

  void _handleAddFeexpayPayment() {
    // Implement Feexpay payment method addition
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajout de méthode de paiement Feexpay'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _handleRemoveFeexpayPayment(String paymentId) {
    // Implement Feexpay payment method removal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Méthode de paiement supprimée'),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  void _handleSetDefaultPayment(String paymentId) {
    // Implement setting default Feexpay payment method
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Méthode de paiement par défaut mise à jour'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _handleNotificationSettings() {
    // Implement notification settings
  }

  void _handleLanguageSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguageCurrencyWidget(
        currentLanguage: _userData['language'] as String,
        currentCurrency: _userData['currency'] as String,
        onChanged: (language, currency) {
          setState(() {
            _userData['language'] = language;
            _userData['currency'] = currency;
          });
        },
      ),
    );
  }

  void _handlePrivacySettings() {
    // Implement privacy settings
  }

  void _handleHelpSupport() {
    // Implement help & support
  }

  void _handleLogout() {
    _showLogoutDialog();
  }

  void _showCancelSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler l\'abonnement'),
        content: const Text(
            'Êtes-vous sûr de vouloir annuler votre abonnement? Cette action ne peut pas être annulée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Process cancellation with Feexpay
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Abonnement annulé avec succès'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.onboardingFlow,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  void _handleTabTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.homeDashboard);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.serviceCatalog);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.orderTracking);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.aiChatbotSubscription);
        break;
      case 4:
        // Already on profile
        break;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
