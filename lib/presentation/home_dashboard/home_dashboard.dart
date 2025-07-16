import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_chatbot_promotion_widget.dart';
import './widgets/featured_services_widget.dart';
import './widgets/promotional_slider_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_orders_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data for promotional banners
  final List<Map<String, dynamic>> _promotionalBanners = [
    {
      "id": 1,
      "title": "Remise Mobile Exclusive",
      "subtitle": "10% de réduction sur tous les services",
      "imageUrl":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "actionText": "Commander Maintenant",
      "discount": "10%",
      "backgroundColor": AppTheme.primaryOrange,
    },
    {
      "id": 2,
      "title": "Services IA Premium",
      "subtitle": "Chatbot WhatsApp avec IA avancée",
      "imageUrl":
          "https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "actionText": "Découvrir",
      "discount": "Nouveau",
      "backgroundColor": AppTheme.primaryBlue,
    },
    {
      "id": 3,
      "title": "Pack Marketing Digital",
      "subtitle": "Solution complète pour votre entreprise",
      "imageUrl":
          "https://images.pixabay.com/photo/2017/01/14/12/59/iceland-1979445_1280.jpg",
      "actionText": "Voir Offres",
      "discount": "15%",
      "backgroundColor": AppTheme.accentPurple,
    },
  ];

  // Mock data for quick actions
  final List<Map<String, dynamic>> _quickActions = [
    {
      "id": 1,
      "title": "Design Logo",
      "description": "Création de logo professionnel",
      "iconName": "design_services",
      "color": AppTheme.primaryOrange,
      "route": "/service-detail",
    },
    {
      "id": 2,
      "title": "Site Web",
      "description": "Développement site responsive",
      "iconName": "web",
      "color": AppTheme.primaryBlue,
      "route": "/service-detail",
    },
    {
      "id": 3,
      "title": "Marketing",
      "description": "Campagne publicitaire digitale",
      "iconName": "campaign",
      "color": AppTheme.successGreen,
      "route": "/service-detail",
    },
    {
      "id": 4,
      "title": "Chatbot IA",
      "description": "Assistant virtuel intelligent",
      "iconName": "smart_toy",
      "color": AppTheme.accentPurple,
      "route": "/ai-chatbot-subscription",
    },
  ];

  // Mock data for featured services
  final List<Map<String, dynamic>> _featuredServices = [
    {
      "id": 1,
      "title": "Logo Design Premium",
      "description": "Design de logo professionnel avec révisions illimitées",
      "originalPrice": "199€",
      "discountedPrice": "179€",
      "discount": "10%",
      "imageUrl":
          "https://images.unsplash.com/photo-1626785774573-4b799315345d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.8,
      "reviews": 156,
      "deliveryTime": "3-5 jours",
    },
    {
      "id": 2,
      "title": "Site Web Responsive",
      "description": "Développement site web moderne et optimisé mobile",
      "originalPrice": "899€",
      "discountedPrice": "809€",
      "discount": "10%",
      "imageUrl":
          "https://images.pexels.com/photos/196644/pexels-photo-196644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.9,
      "reviews": 89,
      "deliveryTime": "7-14 jours",
    },
    {
      "id": 3,
      "title": "Campagne Facebook Ads",
      "description": "Gestion complète de vos publicités Facebook et Instagram",
      "originalPrice": "299€",
      "discountedPrice": "269€",
      "discount": "10%",
      "imageUrl":
          "https://images.pixabay.com/photo/2017/01/18/16/46/social-media-1989152_1280.jpg",
      "rating": 4.7,
      "reviews": 234,
      "deliveryTime": "1-3 jours",
    },
    {
      "id": 4,
      "title": "Branding Complet",
      "description": "Identité visuelle complète pour votre marque",
      "originalPrice": "599€",
      "discountedPrice": "539€",
      "discount": "10%",
      "imageUrl":
          "https://images.unsplash.com/photo-1558655146-d09347e92766?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.8,
      "reviews": 67,
      "deliveryTime": "5-10 jours",
    },
  ];

  // Mock data for recent orders
  final List<Map<String, dynamic>> _recentOrders = [
    {
      "id": 1,
      "serviceName": "Logo Design",
      "status": "En cours",
      "orderDate": "12/07/2025",
      "deliveryDate": "17/07/2025",
      "price": "179€",
      "statusColor": AppTheme.warningAmber,
    },
    {
      "id": 2,
      "serviceName": "Site Web",
      "status": "Livré",
      "orderDate": "05/07/2025",
      "deliveryDate": "15/07/2025",
      "price": "809€",
      "statusColor": AppTheme.successGreen,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: AppTheme.primaryOrange,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Promotional Slider
                  PromotionalSliderWidget(
                    banners: _promotionalBanners,
                    onBannerTap: _handleBannerTap,
                  ),
                  SizedBox(height: 3.h),

                  // Quick Actions
                  QuickActionsWidget(
                    actions: _quickActions,
                    onActionTap: _handleQuickActionTap,
                  ),
                  SizedBox(height: 3.h),

                  // Featured Services
                  FeaturedServicesWidget(
                    services: _featuredServices,
                    onServiceTap: _handleServiceTap,
                  ),
                  SizedBox(height: 3.h),

                  // Recent Orders (if user has history)
                  if (_recentOrders.isNotEmpty) ...[
                    RecentOrdersWidget(
                      orders: _recentOrders,
                      onOrderTap: _handleOrderTap,
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // AI Chatbot Promotion
                  AiChatbotPromotionWidget(
                    onPromotionTap: _handleChatbotPromotionTap,
                  ),
                  SizedBox(height: 10.h), // Extra space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      title: Row(
        children: [
          CustomImageWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
            width: 8.w,
            height: 8.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 3.w),
          Text(
            "Inno'v Group",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryOrange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Handle notifications
          },
          icon: Stack(
            children: [
              CustomIconWidget(
                iconName: 'notifications_outlined',
                color: AppTheme.neutralMedium,
                size: 6.w,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: const BoxDecoration(
                    color: AppTheme.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
      ],
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
              color: AppTheme.primaryOrange,
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
              color: AppTheme.neutralMedium,
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, '/service-catalog');
      },
      backgroundColor: AppTheme.primaryOrange,
      foregroundColor: AppTheme.surfaceWhite,
      elevation: 4.0,
      icon: CustomIconWidget(
        iconName: 'add_shopping_cart',
        color: AppTheme.surfaceWhite,
        size: 5.w,
      ),
      label: Text(
        "Catalogue",
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.surfaceWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleBannerTap(Map<String, dynamic> banner) {
    Navigator.pushNamed(context, '/service-catalog');
  }

  void _handleQuickActionTap(Map<String, dynamic> action) {
    final route = action['route'] as String? ?? '/service-detail';
    Navigator.pushNamed(context, route);
  }

  void _handleServiceTap(Map<String, dynamic> service) {
    Navigator.pushNamed(context, '/service-detail');
  }

  void _handleOrderTap(Map<String, dynamic> order) {
    // Handle order tap - navigate to order details
  }

  void _handleChatbotPromotionTap() {
    Navigator.pushNamed(context, '/ai-chatbot-subscription');
  }

  void _handleTabTap(int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/service-catalog');
        break;
      case 2:
        // Navigate to orders
        break;
      case 3:
        Navigator.pushNamed(context, '/ai-chatbot-subscription');
        break;
      case 4:
        // Navigate to profile
        break;
    }
  }
}
