import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../../services/supabase_service.dart';
import './widgets/chatbot_card_widget.dart';
import './widgets/chatbot_form_widget.dart';

class AiChatbotManagement extends StatefulWidget {
  const AiChatbotManagement({Key? key}) : super(key: key);

  @override
  State<AiChatbotManagement> createState() => _AiChatbotManagementState();
}

class _AiChatbotManagementState extends State<AiChatbotManagement>
    with TickerProviderStateMixin {
  final _supabaseService = SupabaseService();
  late TabController _tabController;

  List<Map<String, dynamic>> _chatbots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 3; // Set AI tab as active
    _loadChatbots();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadChatbots() async {
    try {
      final chatbots = await _supabaseService.getUserChatbots();
      setState(() {
        _chatbots = List<Map<String, dynamic>>.from(chatbots);
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: 'Erreur lors du chargement: ${error.toString()}',
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.surfaceWhite,
      );
    }
  }

  void _showCreateChatbotDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer un nouveau chatbot'),
        content: ChatbotFormWidget(
          onSubmit: _handleCreateChatbot,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showEditChatbotDialog(Map<String, dynamic> chatbot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le chatbot'),
        content: ChatbotFormWidget(
          initialData: chatbot,
          onSubmit: (data) => _handleUpdateChatbot(chatbot['id'], data),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreateChatbot(Map<String, dynamic> data) async {
    try {
      await _supabaseService.createChatbot(data);
      Navigator.pop(context);
      _loadChatbots();
      Fluttertoast.showToast(
        msg: 'Chatbot créé avec succès',
        backgroundColor: AppTheme.successGreen,
        textColor: AppTheme.surfaceWhite,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la création: ${error.toString()}',
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.surfaceWhite,
      );
    }
  }

  Future<void> _handleUpdateChatbot(
      String chatbotId, Map<String, dynamic> data) async {
    try {
      await _supabaseService.updateChatbot(chatbotId, data);
      Navigator.pop(context);
      _loadChatbots();
      Fluttertoast.showToast(
        msg: 'Chatbot mis à jour avec succès',
        backgroundColor: AppTheme.successGreen,
        textColor: AppTheme.surfaceWhite,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la mise à jour: ${error.toString()}',
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.surfaceWhite,
      );
    }
  }

  Future<void> _handleDeleteChatbot(String chatbotId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le chatbot'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer ce chatbot? Cette action ne peut pas être annulée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _supabaseService.deleteChatbot(chatbotId);
        _loadChatbots();
        Fluttertoast.showToast(
          msg: 'Chatbot supprimé avec succès',
          backgroundColor: AppTheme.successGreen,
          textColor: AppTheme.surfaceWhite,
        );
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Erreur lors de la suppression: ${error.toString()}',
          backgroundColor: AppTheme.errorRed,
          textColor: AppTheme.surfaceWhite,
        );
      }
    }
  }

  Future<void> _handleToggleChatbot(String chatbotId, bool isActive) async {
    try {
      await _supabaseService.updateChatbot(chatbotId, {'is_active': isActive});
      _loadChatbots();
      Fluttertoast.showToast(
        msg: isActive ? 'Chatbot activé' : 'Chatbot désactivé',
        backgroundColor: AppTheme.successGreen,
        textColor: AppTheme.surfaceWhite,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la mise à jour: ${error.toString()}',
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.surfaceWhite,
      );
    }
  }

  Future<void> _handleOpenWhatsApp(Map<String, dynamic> chatbot) async {
    try {
      final settings = chatbot['settings'] as Map<String, dynamic>? ?? {};
      final whatsappNumber = settings['whatsapp_number'] as String? ?? '';

      if (whatsappNumber.isNotEmpty) {
        final url = Uri.parse('https://wa.me/$whatsappNumber');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw Exception('Impossible d\'ouvrir WhatsApp');
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Numéro WhatsApp non configuré',
          backgroundColor: AppTheme.warningAmber,
          textColor: AppTheme.surfaceWhite,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Erreur lors de l\'ouverture: ${error.toString()}',
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.surfaceWhite,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingView() : _buildChatbotsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateChatbotDialog,
        backgroundColor: AppTheme.primaryOrange,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      title: Text(
        'Gestion des Chatbots IA',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _loadChatbots,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primaryOrange,
      ),
    );
  }

  Widget _buildChatbotsList() {
    if (_chatbots.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      onRefresh: _loadChatbots,
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: _chatbots.length,
        itemBuilder: (context, index) {
          final chatbot = _chatbots[index];
          return ChatbotCardWidget(
            chatbot: chatbot,
            onEdit: () => _showEditChatbotDialog(chatbot),
            onDelete: () => _handleDeleteChatbot(chatbot['id']),
            onToggle: (isActive) =>
                _handleToggleChatbot(chatbot['id'], isActive),
            onOpenWhatsApp: () => _handleOpenWhatsApp(chatbot),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'smart_toy',
            size: 15.w,
            color: AppTheme.neutralMedium,
          ),
          SizedBox(height: 3.h),
          Text(
            'Aucun chatbot créé',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Créez votre premier chatbot IA pour\nautomatiser vos communications',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: _showCreateChatbotDialog,
            icon: const Icon(Icons.add),
            label: const Text('Créer un chatbot'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            ),
          ),
        ],
      ),
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
              color: AppTheme.primaryOrange,
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
        // Already on AI management
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.userProfile);
        break;
    }
  }
}
