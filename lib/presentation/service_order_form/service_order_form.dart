import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/supabase_service.dart';
import './widgets/bottom_action_widget.dart';
import './widgets/budget_delivery_widget.dart';
import './widgets/file_upload_widget.dart';
import './widgets/form_progress_widget.dart';
import './widgets/project_details_widget.dart';
import './widgets/service_selection_widget.dart';

class ServiceOrderForm extends StatefulWidget {
  const ServiceOrderForm({Key? key}) : super(key: key);

  @override
  State<ServiceOrderForm> createState() => _ServiceOrderFormState();
}

class _ServiceOrderFormState extends State<ServiceOrderForm>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _supabaseService = SupabaseService();

  // Form data
  String selectedService = '';
  String projectDescription = '';
  DateTime? deliveryDate;
  double budgetRange = 500.0;
  List<Map<String, dynamic>> uploadedFiles = [];
  String contactEmail = '';
  String contactPhone = '';
  String additionalRequirements = '';

  // Form state
  int currentStep = 0;
  bool isFormValid = false;
  bool isDraftSaved = false;
  bool _isSubmitting = false;

  // Mock services data
  final List<Map<String, dynamic>> services = [
    {
      "id": 1,
      "name": "Développement Web",
      "description": "Sites web modernes et responsifs",
      "basePrice": 1500.0,
      "icon": "web",
      "fields": ["CMS", "E-commerce", "Responsive Design"]
    },
    {
      "id": 2,
      "name": "Design Graphique",
      "description": "Identité visuelle et supports marketing",
      "basePrice": 800.0,
      "icon": "design_services",
      "fields": ["Logo", "Brochure", "Carte de visite"]
    },
    {
      "id": 3,
      "name": "Marketing Digital",
      "description": "Stratégies marketing et publicité en ligne",
      "basePrice": 1200.0,
      "icon": "campaign",
      "fields": ["SEO", "Social Media", "Google Ads"]
    },
    {
      "id": 4,
      "name": "Application Mobile",
      "description": "Applications iOS et Android natives",
      "basePrice": 2500.0,
      "icon": "smartphone",
      "fields": ["iOS", "Android", "Cross-platform"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadDraftData();
  }

  void _loadDraftData() {
    // Simulate loading draft data from local storage
    setState(() {
      isDraftSaved = false;
    });
  }

  void _saveDraft() {
    // Simulate saving draft to local storage
    setState(() {
      isDraftSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Brouillon sauvegardé'),
        backgroundColor: AppTheme.successGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _validateForm() {
    bool isValid = selectedService.isNotEmpty &&
        projectDescription.isNotEmpty &&
        deliveryDate != null &&
        contactEmail.isNotEmpty;

    setState(() {
      isFormValid = isValid;
    });
  }

  void _nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _proceedToPayment() {
    if (isFormValid) {
      // Navigate to payment or next step
      Navigator.pushNamed(context, '/ai-chatbot-subscription');
    }
  }

  void _handleSubmitOrder() {
    if (!_formKey.currentState!.validate()) return;

    // Check if user is authenticated
    if (!_supabaseService.isAuthenticated) {
      // Navigate to login with return route
      Navigator.pushNamed(
        context,
        AppRoutes.login,
        arguments: AppRoutes.serviceOrderForm,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate order submission
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isSubmitting = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Commande soumise avec succès !'),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      // Navigate to order tracking
      Navigator.pushReplacementNamed(context, AppRoutes.orderTracking);
    });
  }

  double get _totalPrice {
    double basePrice = services.firstWhere(
          (service) => service['name'] == selectedService,
          orElse: () => {'basePrice': 0.0},
        )['basePrice'] ??
        0.0;

    // Apply 10% mobile discount
    return basePrice * 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Commande de Service',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: Text(
              'Sauvegarder',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          FormProgressWidget(
            currentStep: currentStep,
            totalSteps: 4,
          ),

          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                children: [
                  // Step 1: Service Selection
                  ServiceSelectionWidget(
                    services: services,
                    selectedService: selectedService,
                    onServiceSelected: (service) {
                      setState(() {
                        selectedService = service;
                      });
                      _validateForm();
                    },
                  ),

                  // Step 2: Project Details
                  ProjectDetailsWidget(
                    projectDescription: projectDescription,
                    contactEmail: contactEmail,
                    contactPhone: contactPhone,
                    additionalRequirements: additionalRequirements,
                    onProjectDescriptionChanged: (value) {
                      setState(() {
                        projectDescription = value;
                      });
                      _validateForm();
                    },
                    onContactEmailChanged: (value) {
                      setState(() {
                        contactEmail = value;
                      });
                      _validateForm();
                    },
                    onContactPhoneChanged: (value) {
                      setState(() {
                        contactPhone = value;
                      });
                    },
                    onAdditionalRequirementsChanged: (value) {
                      setState(() {
                        additionalRequirements = value;
                      });
                    },
                  ),

                  // Step 3: File Upload
                  FileUploadWidget(
                    uploadedFiles: uploadedFiles,
                    onFilesChanged: (files) {
                      setState(() {
                        uploadedFiles = files;
                      });
                    },
                  ),

                  // Step 4: Budget & Delivery
                  BudgetDeliveryWidget(
                    budgetRange: budgetRange,
                    deliveryDate: deliveryDate,
                    onBudgetChanged: (value) {
                      setState(() {
                        budgetRange = value;
                      });
                    },
                    onDeliveryDateChanged: (date) {
                      setState(() {
                        deliveryDate = date;
                      });
                      _validateForm();
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom action area
          BottomActionWidget(
            currentStep: currentStep,
            totalSteps: 4,
            isFormValid: isFormValid,
            totalPrice: _totalPrice,
            onPrevious: _previousStep,
            onNext: _nextStep,
            onProceedToPayment: _proceedToPayment,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
