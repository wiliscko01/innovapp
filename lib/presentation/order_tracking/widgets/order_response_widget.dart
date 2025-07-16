import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/supabase_service.dart';

class OrderResponseWidget extends StatefulWidget {
  final String orderId;
  final bool isAdmin;

  const OrderResponseWidget({
    Key? key,
    required this.orderId,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<OrderResponseWidget> createState() => _OrderResponseWidgetState();
}

class _OrderResponseWidgetState extends State<OrderResponseWidget> {
  final _supabaseService = SupabaseService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _supabaseService.getOrderMessages(widget.orderId);
      setState(() {
        _messages = List<Map<String, dynamic>>.from(messages);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (error) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: 'Erreur lors du chargement: ${error.toString()}',
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.surfaceWhite,
      );
    }
  }

  void _subscribeToMessages() {
    _supabaseService.subscribeToOrderMessages(widget.orderId, (payload) {
      if (payload['eventType'] == 'INSERT') {
        setState(() {
          _messages.add(payload['new'] as Map<String, dynamic>);
        });
        _scrollToBottom();
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() => _isSending = true);
    final message = _messageController.text.trim();
    _messageController.clear();

    try {
      await _supabaseService.sendOrderMessage(widget.orderId, message);
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Erreur lors de l\'envoi: ${error.toString()}',
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.surfaceWhite,
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _shareOnWhatsApp(String message) {
    final shareText = 'Message de commande: $message';
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(shareText)}';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.neutralLight,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Text(
                  widget.isAdmin
                      ? 'Répondre au client'
                      : 'Messages de la commande',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryOrange,
                    ),
                  )
                : _messages.isEmpty
                    ? _buildEmptyView()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(4.w),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return _buildMessageBubble(message);
                        },
                      ),
          ),

          // Message input
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.neutralLight,
              border: Border(
                top: BorderSide(
                  color: AppTheme.neutralMedium.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: widget.isAdmin
                          ? 'Taper votre réponse...'
                          : 'Taper votre message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.surfaceWhite,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _isSending ? null : _sendMessage,
                    icon: _isSending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.surfaceWhite,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: AppTheme.surfaceWhite,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'message',
            size: 12.w,
            color: AppTheme.neutralMedium,
          ),
          SizedBox(height: 2.h),
          Text(
            'Aucun message',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.isAdmin
                ? 'Commencez la conversation avec le client'
                : 'Aucun message pour cette commande',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final currentUser = _supabaseService.currentUser;
    final isCurrentUser = message['sender_id'] == currentUser?.id;
    final senderProfile = message['user_profiles'] as Map<String, dynamic>?;
    final isAdminSender = senderProfile?['role'] == 'admin';
    final createdAt = DateTime.parse(message['created_at'] as String);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message bubble
          Container(
            constraints: BoxConstraints(maxWidth: 75.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppTheme.primaryOrange
                  : isAdminSender
                      ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                      : AppTheme.neutralLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser && senderProfile != null) ...[
                  Row(
                    children: [
                      Text(
                        senderProfile['full_name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isAdminSender
                              ? AppTheme.primaryBlue
                              : AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                      if (isAdminSender) ...[
                        SizedBox(width: 1.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Admin',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.surfaceWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 1.h),
                ],
                Text(
                  message['message'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isCurrentUser
                        ? AppTheme.surfaceWhite
                        : AppTheme.textHighEmphasisLight,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 0.5.h),

          // Message info and actions
          Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                _formatTime(createdAt),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
              if (!isCurrentUser) ...[
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () => _shareOnWhatsApp(message['message'] as String),
                  child: CustomIconWidget(
                    iconName: 'share',
                    size: 4.w,
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    }
  }
}
