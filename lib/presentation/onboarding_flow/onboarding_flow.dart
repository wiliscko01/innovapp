import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  bool _isAnimating = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "id": 1,
      "title": "Réductions Exclusives Mobile",
      "subtitle": "10% de réduction sur tous les services",
      "description":
          "Profitez d'offres spéciales réservées aux utilisateurs mobiles. Économisez sur tous nos services numériques avec des prix préférentiels.",
      "image":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?fm=jpg&q=80&w=800&ixlib=rb-4.0.3",
      "color": AppTheme.primaryOrange,
      "icon": "local_offer"
    },
    {
      "id": 2,
      "title": "Assistant IA WhatsApp",
      "subtitle": "Chatbot intelligent 24/7",
      "description":
          "Accédez à notre assistant IA via WhatsApp. Support instantané, conseils personnalisés et gestion de vos projets en temps réel.",
      "image":
          "https://images.unsplash.com/photo-1531746790731-6c087fecd65a?fm=jpg&q=80&w=800&ixlib=rb-4.0.3",
      "color": AppTheme.primaryBlue,
      "icon": "smart_toy"
    },
    {
      "id": 3,
      "title": "Commande Simplifiée",
      "subtitle": "Processus optimisé mobile",
      "description":
          "Interface intuitive pour commander vos services. Upload de fichiers, suivi en temps réel et notifications push pour rester informé.",
      "image":
          "https://images.unsplash.com/photo-1551650975-87deedd944c3?fm=jpg&q=80&w=800&ixlib=rb-4.0.3",
      "color": AppTheme.accentPurple,
      "icon": "touch_app"
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_isAnimating) return;

    if (_currentPage < _onboardingData.length - 1) {
      _isAnimating = true;
      HapticFeedback.lightImpact();
      _pageController
          .nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        _isAnimating = false;
      });
    } else {
      _getStarted();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
  }

  void _getStarted() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
  }

  void _onPageChanged(int page) {
    if (!_isAnimating) {
      setState(() {
        _currentPage = page;
      });
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightTheme.scaffoldBackgroundColor,
                    AppTheme.lightTheme.scaffoldBackgroundColor
                        .withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),

            // Skip button
            Positioned(
              top: 2.h,
              right: 4.w,
              child: TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Text(
                  'Passer',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.neutralMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: _OnboardingSlide(
                          title: data["title"] as String,
                          subtitle: data["subtitle"] as String,
                          description: data["description"] as String,
                          imageUrl: data["image"] as String,
                          color: data["color"] as Color,
                          iconName: data["icon"] as String,
                        ),
                      );
                    },
                  ),
                ),

                // Bottom navigation area
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => _PageIndicator(
                            isActive: index == _currentPage,
                            color: (_onboardingData[_currentPage])["color"]
                                as Color,
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Navigation button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                (_onboardingData[_currentPage])["color"]
                                    as Color,
                            foregroundColor: AppTheme.surfaceWhite,
                            elevation: 2,
                            shadowColor:
                                ((_onboardingData[_currentPage])["color"]
                                        as Color)
                                    .withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Commencer'
                                : 'Suivant',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.surfaceWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Permission preview on last slide
                      _currentPage == _onboardingData.length - 1
                          ? Text(
                              'Autorisations: Caméra, Notifications, Fichiers',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.neutralMedium,
                                fontSize: 10.sp,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final Color color;
  final String iconName;

  const _OnboardingSlide({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.iconName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 4.h),

          // Image container with parallax effect
          Container(
            width: 70.w,
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: imageUrl,
                    width: 70.w,
                    height: 35.h,
                    fit: BoxFit.cover,
                  ),

                  // Overlay with icon
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          color.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),

                  // Icon
                  Positioned(
                    bottom: 3.h,
                    right: 4.w,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: iconName,
                        color: color,
                        size: 6.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Subtitle
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
                fontSize: 12.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _PageIndicator({
    Key? key,
    required this.isActive,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      height: 1.h,
      width: isActive ? 6.w : 2.w,
      decoration: BoxDecoration(
        color: isActive ? color : AppTheme.neutralMedium.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
