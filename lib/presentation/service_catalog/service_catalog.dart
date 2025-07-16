import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/service_card_widget.dart';

class ServiceCatalog extends StatefulWidget {
  const ServiceCatalog({super.key});

  @override
  State<ServiceCatalog> createState() => _ServiceCatalogState();
}

class _ServiceCatalogState extends State<ServiceCatalog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'Tous';
  int _activeFiltersCount = 0;
  bool _isLoading = false;
  bool _isSearching = false;

  final List<String> _categories = [
    'Tous',
    'Web Design',
    'Branding',
    'Marketing',
    'Development'
  ];

  final List<Map<String, dynamic>> _services = [
    {
      "id": 1,
      "name": "Site Web Vitrine",
      "category": "Web Design",
      "price": 899.0,
      "originalPrice": 999.0,
      "discount": 10,
      "rating": 4.8,
      "reviewCount": 124,
      "deliveryTime": "7-10 jours",
      "image":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=300&fit=crop",
      "description":
          "Création d'un site web professionnel responsive avec design moderne",
      "isFavorite": false,
      "tags": ["Responsive", "SEO", "Mobile"]
    },
    {
      "id": 2,
      "name": "Logo & Identité Visuelle",
      "category": "Branding",
      "price": 449.0,
      "originalPrice": 499.0,
      "discount": 10,
      "rating": 4.9,
      "reviewCount": 89,
      "deliveryTime": "3-5 jours",
      "image":
          "https://images.unsplash.com/photo-1558655146-d09347e92766?w=400&h=300&fit=crop",
      "description":
          "Création de logo professionnel et charte graphique complète",
      "isFavorite": true,
      "tags": ["Logo", "Charte", "Print"]
    },
    {
      "id": 3,
      "name": "Campagne Google Ads",
      "category": "Marketing",
      "price": 299.0,
      "originalPrice": 349.0,
      "discount": 10,
      "rating": 4.7,
      "reviewCount": 156,
      "deliveryTime": "1-3 jours",
      "image":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=300&fit=crop",
      "description":
          "Configuration et optimisation de campagnes publicitaires Google",
      "isFavorite": false,
      "tags": ["Google", "PPC", "ROI"]
    },
    {
      "id": 4,
      "name": "Application Mobile",
      "category": "Development",
      "price": 2699.0,
      "originalPrice": 2999.0,
      "discount": 10,
      "rating": 4.6,
      "reviewCount": 67,
      "deliveryTime": "21-30 jours",
      "image":
          "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400&h=300&fit=crop",
      "description": "Développement d'application mobile native iOS et Android",
      "isFavorite": false,
      "tags": ["iOS", "Android", "Native"]
    },
    {
      "id": 5,
      "name": "E-commerce Shopify",
      "category": "Web Design",
      "price": 1349.0,
      "originalPrice": 1499.0,
      "discount": 10,
      "rating": 4.8,
      "reviewCount": 203,
      "deliveryTime": "10-14 jours",
      "image":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=300&fit=crop",
      "description": "Création de boutique en ligne complète avec Shopify",
      "isFavorite": true,
      "tags": ["Shopify", "E-commerce", "Paiement"]
    },
    {
      "id": 6,
      "name": "Stratégie Social Media",
      "category": "Marketing",
      "price": 599.0,
      "originalPrice": 699.0,
      "discount": 10,
      "rating": 4.5,
      "reviewCount": 91,
      "deliveryTime": "5-7 jours",
      "image":
          "https://images.unsplash.com/photo-1611926653458-09294b3142bf?w=400&h=300&fit=crop",
      "description": "Élaboration de stratégie complète pour réseaux sociaux",
      "isFavorite": false,
      "tags": ["Instagram", "Facebook", "LinkedIn"]
    }
  ];

  List<Map<String, dynamic>> _filteredServices = [];
  List<String> _recentSearches = ['Logo design', 'Site web', 'Marketing'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _filteredServices = List.from(_services);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreServices();
    }
  }

  void _loadMoreServices() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _filterServices() {
    setState(() {
      _filteredServices = _services.where((service) {
        bool matchesCategory = _selectedCategory == 'Tous' ||
            service['category'] == _selectedCategory;
        bool matchesSearch = _searchController.text.isEmpty ||
            service['name']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            service['description']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterServices();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    _filterServices();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onFiltersApplied: (filterCount) {
          setState(() {
            _activeFiltersCount = filterCount;
          });
          _filterServices();
        },
      ),
    );
  }

  void _onServiceTap(Map<String, dynamic> service) {
    Navigator.pushNamed(context, '/service-detail', arguments: service);
  }

  void _onServiceLongPress(Map<String, dynamic> service) {
    _showServiceActions(service);
  }

  void _showServiceActions(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName:
                    service['isFavorite'] ? 'favorite' : 'favorite_border',
                color: AppTheme.primaryOrange,
                size: 24,
              ),
              title: Text(
                service['isFavorite']
                    ? 'Retirer des favoris'
                    : 'Ajouter aux favoris',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                setState(() {
                  service['isFavorite'] = !service['isFavorite'];
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text(
                'Partager',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'similar',
                color: AppTheme.neutralMedium,
                size: 24,
              ),
              title: Text(
                'Services similaires',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _filteredServices = List.from(_services);
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'Tous';
      _searchController.clear();
      _activeFiltersCount = 0;
      _isSearching = false;
    });
    _filterServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Inno\'v Group',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: AppTheme.neutralMedium,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Accueil'),
            Tab(text: 'Services'),
            Tab(text: 'Commandes'),
            Tab(text: 'Profil'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home-dashboard');
                break;
              case 1:
                break;
              case 2:
                break;
              case 3:
                break;
            }
          },
        ),
      ),
      body: Column(
        children: [
          _buildStickyHeader(),
          _buildCategoryChips(),
          Expanded(
            child: _buildServiceGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.neutralMedium.withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Rechercher un service...',
                  hintStyle: AppTheme.lightTheme.inputDecorationTheme.hintStyle,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.neutralMedium,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _isSearching
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme.neutralMedium,
                            size: 20,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(2.w),
                          child: CustomIconWidget(
                            iconName: 'mic',
                            color: AppTheme.neutralMedium,
                            size: 20,
                          ),
                        ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Container(
              height: 6.h,
              width: 12.w,
              decoration: BoxDecoration(
                color: _activeFiltersCount > 0
                    ? AppTheme.primaryOrange
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _activeFiltersCount > 0
                      ? AppTheme.primaryOrange
                      : AppTheme.neutralMedium.withValues(alpha: 0.3),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: _activeFiltersCount > 0
                        ? AppTheme.surfaceWhite
                        : AppTheme.neutralMedium,
                    size: 20,
                  ),
                  if (_activeFiltersCount > 0)
                    Positioned(
                      top: 0.5.h,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.all(0.5.w),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _activeFiltersCount.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.surfaceWhite,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: CategoryChipWidget(
              category: _categories[index],
              isSelected: _selectedCategory == _categories[index],
              onTap: () => _onCategorySelected(_categories[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceGrid() {
    if (_filteredServices.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.primaryOrange,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 100.w > 600 ? 3 : 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.w,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _filteredServices.length) {
                    return ServiceCardWidget(
                      service: _filteredServices[index],
                      onTap: () => _onServiceTap(_filteredServices[index]),
                      onLongPress: () =>
                          _onServiceLongPress(_filteredServices[index]),
                    );
                  }
                  return null;
                },
                childCount: _filteredServices.length,
              ),
            ),
          ),
          if (_isLoading)
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.neutralMedium,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'Aucun service trouvé',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.neutralMedium,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Essayez de modifier vos critères de recherche ou explorez nos catégories',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutralMedium,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _clearFilters,
              child: const Text('Effacer les filtres'),
            ),
            SizedBox(height: 2.h),
            if (_recentSearches.isNotEmpty) ...[
              Text(
                'Recherches récentes',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                children: _recentSearches.map((search) {
                  return ActionChip(
                    label: Text(search),
                    onPressed: () {
                      _searchController.text = search;
                      _onSearchChanged(search);
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
