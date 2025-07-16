import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/supabase_service.dart';
import './widgets/empty_orders_widget.dart';
import './widgets/order_card_widget.dart';
import './widgets/order_filters_widget.dart';
import './widgets/order_response_widget.dart';
import './widgets/order_timeline_widget.dart';

class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking>
    with TickerProviderStateMixin {
  final _supabaseService = SupabaseService();
  late TabController _tabController;
  bool _isRefreshing = false;
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for orders
  final List<Map<String, dynamic>> _orders = [
    {
      "id": "ORD-2025-001",
      "serviceName": "Logo Design Premium",
      "serviceImage":
          "https://images.unsplash.com/photo-1626785774573-4b799315345d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "currentStatus": "En cours",
      "orderDate": "2025-07-12T10:30:00Z",
      "deliveryDate": "2025-07-17T18:00:00Z",
      "price": "179€",
      "statusColor": AppTheme.warningAmber,
      "progress": 0.6,
      "timeline": [
        {
          "status": "Commande passée",
          "date": "2025-07-12T10:30:00Z",
          "description": "Commande confirmée et paiement validé",
          "completed": true
        },
        {
          "status": "Examen des exigences",
          "date": "2025-07-12T14:00:00Z",
          "description": "Analyse des besoins en cours",
          "completed": true
        },
        {
          "status": "Travail en cours",
          "date": "2025-07-13T09:00:00Z",
          "description": "Création du design en cours",
          "completed": true
        },
        {
          "status": "Révision",
          "date": "",
          "description": "Révisions selon vos commentaires",
          "completed": false
        },
        {
          "status": "Livraison",
          "date": "",
          "description": "Livraison finale du projet",
          "completed": false
        }
      ]
    },
    {
      "id": "ORD-2025-002",
      "serviceName": "Site Web Responsive",
      "serviceImage":
          "https://images.pexels.com/photos/196644/pexels-photo-196644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "currentStatus": "Livré",
      "orderDate": "2025-07-05T09:15:00Z",
      "deliveryDate": "2025-07-15T17:30:00Z",
      "price": "809€",
      "statusColor": AppTheme.successGreen,
      "progress": 1.0,
      "timeline": [
        {
          "status": "Commande passée",
          "date": "2025-07-05T09:15:00Z",
          "description": "Commande confirmée et paiement validé",
          "completed": true
        },
        {
          "status": "Examen des exigences",
          "date": "2025-07-05T11:00:00Z",
          "description": "Analyse des besoins terminée",
          "completed": true
        },
        {
          "status": "Travail en cours",
          "date": "2025-07-06T09:00:00Z",
          "description": "Développement du site web",
          "completed": true
        },
        {
          "status": "Révision",
          "date": "2025-07-12T14:00:00Z",
          "description": "Révisions appliquées",
          "completed": true
        },
        {
          "status": "Livraison",
          "date": "2025-07-15T17:30:00Z",
          "description": "Projet livré avec succès",
          "completed": true
        }
      ]
    },
    {
      "id": "ORD-2025-003",
      "serviceName": "Campagne Facebook Ads",
      "serviceImage":
          "https://images.pixabay.com/photo/2017/01/18/16/46/social-media-1989152_1280.jpg",
      "currentStatus": "Annulé",
      "orderDate": "2025-07-10T16:20:00Z",
      "deliveryDate": "2025-07-13T12:00:00Z",
      "price": "269€",
      "statusColor": AppTheme.errorRed,
      "progress": 0.0,
      "timeline": [
        {
          "status": "Commande passée",
          "date": "2025-07-10T16:20:00Z",
          "description": "Commande confirmée et paiement validé",
          "completed": true
        },
        {
          "status": "Annulation",
          "date": "2025-07-11T10:00:00Z",
          "description": "Commande annulée par le client",
          "completed": true
        }
      ]
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    List<Map<String, dynamic>> filtered = _orders;

    // Filter by status
    if (_selectedFilter != 'All') {
      filtered = filtered.where((order) {
        switch (_selectedFilter) {
          case 'In Progress':
            return order['currentStatus'] == 'En cours';
          case 'Completed':
            return order['currentStatus'] == 'Livré';
          case 'Cancelled':
            return order['currentStatus'] == 'Annulé';
          default:
            return true;
        }
      }).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((order) {
        final searchTerm = _searchController.text.toLowerCase();
        return order['serviceName'].toLowerCase().contains(searchTerm) ||
            order['id'].toLowerCase().contains(searchTerm);
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 2; // Set Orders tab as active
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
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
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: AppTheme.surfaceWhite,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une commande...',
                    prefixIcon:
                        Icon(Icons.search, color: AppTheme.neutralMedium),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                color: AppTheme.neutralMedium),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 2.h),

                // Filter Options
                OrderFiltersWidget(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: _filteredOrders.isEmpty
                ? const EmptyOrdersWidget()
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: AppTheme.primaryOrange,
                    child: ListView.builder(
                      padding: EdgeInsets.all(4.w),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return OrderCardWidget(
                          order: order,
                          onTap: () => _showOrderDetails(order),
                          onContactSupport: () => _contactSupport(order),
                          onRequestRevision: () => _requestRevision(order),
                          onDownloadFiles: () => _downloadFiles(order),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suivi des Commandes',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${_filteredOrders.length} commande${_filteredOrders.length > 1 ? 's' : ''}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralMedium,
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
              color: AppTheme.primaryOrange,
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
        Navigator.pushNamed(context, AppRoutes.serviceCatalog);
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
        "Nouvelle Commande",
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.surfaceWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.neutralMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      order['serviceName'],
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.close, color: AppTheme.neutralMedium),
                  ),
                ],
              ),
            ),

            // Timeline
            Expanded(
              child: OrderTimelineWidget(
                timeline: order['timeline'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _contactSupport(Map<String, dynamic> order) {
    // Implement contact support functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacter le support pour ${order['id']}'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _requestRevision(Map<String, dynamic> order) {
    // Implement revision request functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demande de révision pour ${order['id']}'),
        backgroundColor: AppTheme.warningAmber,
      ),
    );
  }

  void _downloadFiles(Map<String, dynamic> order) {
    // Implement file download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Téléchargement des fichiers pour ${order['id']}'),
        backgroundColor: AppTheme.successGreen,
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
        // Already on orders
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.aiChatbotSubscription);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.userProfile);
        break;
    }
  }

  void _handleOrderTap(Map<String, dynamic> order) {
    // Check if user is authenticated
    if (!_supabaseService.isAuthenticated) {
      // Navigate to login with return route
      Navigator.pushNamed(
        context,
        AppRoutes.login,
        arguments: AppRoutes.orderTracking,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderResponseWidget(
        orderId: order['id'] as String,
        isAdmin: false, // Set based on user role
      ),
    );
  }
}
