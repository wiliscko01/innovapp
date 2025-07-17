import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/service_catalog/service_catalog.dart';
import '../presentation/service_detail/service_detail.dart';
import '../presentation/ai_chatbot_subscription/ai_chatbot_subscription.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/service_order_form/service_order_form.dart';
import '../presentation/order_tracking/order_tracking.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/register_screen.dart';
import '../presentation/ai_chatbot_management/ai_chatbot_management.dart';
import '../presentation/ai_settings/ai_settings_page.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String serviceCatalog = '/service-catalog';
  static const String serviceDetail = '/service-detail';
  static const String aiChatbotSubscription = '/ai-chatbot-subscription';
  static const String homeDashboard = '/home-dashboard';
  static const String serviceOrderForm = '/service-order-form';
  static const String orderTracking = '/order-tracking';
  static const String userProfile = '/user-profile';
  static const String login = '/login';
  static const String register = '/register';
  static const String aiChatbotManagement = '/ai-chatbot-management';
  static const String aiSettings = '/ai-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    onboardingFlow: (context) => const OnboardingFlow(),
    serviceCatalog: (context) => const ServiceCatalog(),
    serviceDetail: (context) => const ServiceDetail(),
    aiChatbotSubscription: (context) => const AiChatbotSubscription(),
    homeDashboard: (context) => const HomeDashboard(),
    serviceOrderForm: (context) => const ServiceOrderForm(),
    orderTracking: (context) => const OrderTracking(),
    userProfile: (context) => const UserProfile(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    aiChatbotManagement: (context) => const AiChatbotManagement(),
    aiSettings: (context) => const AiSettingsPage(),
    // TODO: Add your other routes here
  };
}
