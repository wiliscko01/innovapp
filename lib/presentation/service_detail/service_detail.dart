import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/related_services_widget.dart';
import './widgets/reviews_section_widget.dart';
import './widgets/service_gallery_widget.dart';
import './widgets/service_info_widget.dart';
import './widgets/service_sections_widget.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({Key? key}) : super(key: key);

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isFavorite = false;
  bool _showTitle = false;

  // Mock service data
  final Map<String, dynamic> serviceData = {
    "id": 1,
    "title": "Création de Site Web Professionnel",
    "category": "Développement Web",
    "originalPrice": "€1,200",
    "discountedPrice": "€1,080",
    "discount": "10%",
    "rating": 4.8,
    "reviewCount": 127,
    "images": [
      "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1547658719-da2b51169166?w=800&h=600&fit=crop"
    ],
    "description":
        """Créez une présence en ligne professionnelle avec notre service de développement web complet. Notre équipe d'experts conçoit des sites web modernes, responsifs et optimisés pour les moteurs de recherche.

Nous utilisons les dernières technologies pour garantir des performances optimales et une expérience utilisateur exceptionnelle sur tous les appareils.""",
    "included": [
      "Design responsive adaptatif",
      "Optimisation SEO de base",
      "Intégration CMS WordPress",
      "Certificat SSL inclus",
      "Support technique 3 mois",
      "Formation utilisateur"
    ],
    "deliveryTime": "2-3 semaines",
    "requirements": [
      "Logo et éléments de branding",
      "Contenu textuel et images",
      "Spécifications fonctionnelles",
      "Accès hébergement web"
    ],
    "reviews": [
      {
        "id": 1,
        "userName": "Marie Dubois",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rating": 5,
        "comment":
            "Service exceptionnel ! L'équipe a parfaitement compris nos besoins et livré un site magnifique dans les délais.",
        "date": "2025-01-10"
      },
      {
        "id": 2,
        "userName": "Pierre Martin",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rating": 4,
        "comment":
            "Très satisfait du résultat. Le site est moderne et fonctionne parfaitement sur mobile.",
        "date": "2025-01-08"
      },
      {
        "id": 3,
        "userName": "Sophie Laurent",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "rating": 5,
        "comment":
            "Équipe professionnelle et réactive. Le support post-livraison est excellent.",
        "date": "2025-01-05"
      }
    ],
    "relatedServices": [
      {
        "id": 2,
        "title": "Référencement SEO",
        "price": "€450",
        "image":
            "https://images.unsplash.com/photo-1432888622747-4eb9a8efeb07?w=400&h=300&fit=crop",
        "rating": 4.7
      },
      {
        "id": 3,
        "title": "Design Logo",
        "price": "€280",
        "image":
            "https://images.unsplash.com/photo-1626785774573-4b799315345d?w=400&h=300&fit=crop",
        "rating": 4.9
      },
      {
        "id": 4,
        "title": "Marketing Digital",
        "price": "€680",
        "image":
            "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=300&fit=crop",
        "rating": 4.6
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  void _shareService() {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lien du service copié dans le presse-papiers'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  void _orderService() {
    Navigator.pushNamed(context, '/service-order-form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 60.h,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                leading: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: _shareService,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  ),
                ],
                title: _showTitle
                    ? Text(
                        serviceData["title"] as String,
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      )
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  background: ServiceGalleryWidget(
                    images: (serviceData["images"] as List).cast<String>(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceInfoWidget(
                      title: serviceData["title"] as String,
                      category: serviceData["category"] as String,
                      originalPrice: serviceData["originalPrice"] as String,
                      discountedPrice: serviceData["discountedPrice"] as String,
                      discount: serviceData["discount"] as String,
                      rating: serviceData["rating"] as double,
                      reviewCount: serviceData["reviewCount"] as int,
                    ),
                    SizedBox(height: 2.h),
                    ServiceSectionsWidget(
                      description: serviceData["description"] as String,
                      included:
                          (serviceData["included"] as List).cast<String>(),
                      deliveryTime: serviceData["deliveryTime"] as String,
                      requirements:
                          (serviceData["requirements"] as List).cast<String>(),
                    ),
                    SizedBox(height: 2.h),
                    ReviewsSectionWidget(
                      rating: serviceData["rating"] as double,
                      reviewCount: serviceData["reviewCount"] as int,
                      reviews:
                          serviceData["reviews"] as List<Map<String, dynamic>>,
                    ),
                    SizedBox(height: 2.h),
                    RelatedServicesWidget(
                      services: serviceData["relatedServices"]
                          as List<Map<String, dynamic>>,
                    ),
                    SizedBox(height: 12.h), // Space for sticky button
                  ],
                ),
              ),
            ],
          ),
          // Sticky Order Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: _orderService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: AppTheme.surfaceWhite,
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'shopping_cart',
                        color: AppTheme.surfaceWhite,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Commander Maintenant',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.surfaceWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating Action Button
          Positioned(
            bottom: 15.h,
            right: 4.w,
            child: FloatingActionButton(
              onPressed: _toggleFavorite,
              backgroundColor: _isFavorite
                  ? AppTheme.primaryOrange
                  : AppTheme.lightTheme.colorScheme.surface,
              child: CustomIconWidget(
                iconName: _isFavorite ? 'favorite' : 'favorite_border',
                color: _isFavorite
                    ? AppTheme.surfaceWhite
                    : AppTheme.primaryOrange,
                size: 6.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
