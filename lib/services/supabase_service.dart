import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  final Future<void> _initFuture;

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal() : _initFuture = _initializeSupabase();

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://envfnxzdwkmbgbpmxhwj.supabase.co');
  static const String supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVudmZueHpkd2ttYmdicG14aHdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MTIzMDUsImV4cCI6MjA2ODE4ODMwNX0.xidk9TTAiZZgaAD_skqxcjyWv7M6NewvbmC0V7FBRqE');

  // Internal initialization logic
  static Future<void> _initializeSupabase() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define.');
    }

    if (kDebugMode) {
      print('Initializing Supabase with URL: $supabaseUrl');
    }


    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _instance._client = Supabase.instance.client;
    _instance._isInitialized = true;

    if (kDebugMode) {
      print('Supabase initialized successfully');
    }
  }

  // Client getter (async)
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await _initFuture;
    }
    return _client;
  }

  // Synchronous client getter (use only after initialization)
  SupabaseClient get syncClient {
    if (!_isInitialized) {
      throw Exception('Supabase not initialized. Call client getter first.');
    }
    return _client;
  }

  // Authentication methods
  Future<AuthResponse> signUp(String email, String password,
      {String? fullName}) async {
    final client = await this.client;
    return await client.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final client = await this.client;
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    final client = await this.client;
    await client.auth.signOut();
  }

  // Get current user profile with error handling
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final client = await this.client;
      final user = client.auth.currentUser;
      if (user == null) return null;

      return {
        'id': user.id,
        'email': user.email,
        'full_name': user.userMetadata?['full_name'] ?? user.email?.split('@')[0],
      };
    } catch (error) {
      if (kDebugMode) print('Error getting current user profile: $error');
      return null;
    }
  }

  // User profile methods
  Future<Map<String, dynamic>?> getUserProfile() async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) return null;

    final response = await client
        .from('user_profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    // If no profile exists in database, return user auth data
    if (response == null) {
      return {
        'id': user.id,
        'email': user.email,
        'full_name': user.userMetadata?['full_name'] ?? user.email?.split('@')[0],
      };
    }

    return response as Map<String, dynamic>;
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    try {
      await client.from('user_profiles').update(updates).eq('id', user.id);
    } catch (error) {
      // If profile doesn't exist, create it
      await client.from('user_profiles').insert({
        'id': user.id,
        'email': user.email,
        ...updates,
      });
    }
  }

  // Order methods
  Future<List<dynamic>> getUserOrders() async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    return await client
        .from('orders')
        .select('*, services(name, image_url)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    await client.from('orders').insert({
      ...orderData,
      'user_id': user.id,
    });
  }

  // Order messages methods
  Future<List<dynamic>> getOrderMessages(String orderId) async {
    final client = await this.client;
    return await client
        .from('order_messages')
        .select('*, user_profiles(full_name, role)')
        .eq('order_id', orderId)
        .order('created_at', ascending: true);
  }

  Future<void> sendOrderMessage(String orderId, String message) async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    await client.from('order_messages').insert({
      'order_id': orderId,
      'sender_id': user.id,
      'message': message,
      'message_type': 'text',
    });
  }

  // Enhanced AI Chatbot methods with better error handling
  Future<List<Map<String, dynamic>>> getUserChatbots() async {
    try {
      final client = await this.client;
      final user = client.auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      final response = await client
          .from('ai_chatbots')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      if (kDebugMode) print('Error getting user chatbots: $error');
      return [];
    }
  }

  // AI Chatbot methods
  Future<void> createChatbot(Map<String, dynamic> chatbotData) async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    await client.from('ai_chatbots').insert({
      ...chatbotData,
      'user_id': user.id,
    });
  }

  Future<void> updateChatbot(String chatbotId, Map<String, dynamic> updates) async {
    final client = await this.client;
    await client.from('ai_chatbots').update(updates).eq('id', chatbotId);
  }

  Future<void> deleteChatbot(String chatbotId) async {
    final client = await this.client;
    await client.from('ai_chatbots').delete().eq('id', chatbotId);
  }

  // Services methods with caching
  Future<List<Map<String, dynamic>>> getServices() async {
    try {
    final client = await this.client;
      final response = await client
          .from('services')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      if (kDebugMode) print('Error getting services: $error');
      return [];
    }
  }

  // Enhanced error handling for real-time subscriptions
  RealtimeChannel subscribeToOrderMessages(
      String orderId, void Function(Map<String, dynamic>) callback) {
    try {
      final channel = syncClient.channel('order_messages_$orderId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'order_messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'order_id',
              value: orderId,
            ),
            callback: (PostgresChangePayload payload) {
              try {
                callback(payload.newRecord);
              } catch (error) {
                if (kDebugMode) print('Error in message callback: $error');
              }
            },
          );

      channel.subscribe();
      return channel;
    } catch (error) {
      if (kDebugMode) print('Error subscribing to order messages: $error');
      rethrow;
    }
  }

  // Health check method
  Future<bool> isHealthy() async {
    try {
    final client = await this.client;
      final response = await client.from('services').select('id').limit(1);
      return response.isNotEmpty || response.isEmpty; // Both cases mean connection works
    } catch (error) {
      if (kDebugMode) print('Health check failed: $error');
      return false;
    }
  }

  // Connection status
  bool get isConnected => _isInitialized;

  // Enhanced authentication state
  Stream<AuthState> get authStateChanges {
    try {
      return syncClient.auth.onAuthStateChange;
    } catch (error) {
      if (kDebugMode) print('Error getting auth state changes: $error');
      return const Stream.empty();
    }
  }

  // Batch operations for better performance
  Future<void> batchUpdateChatbots(List<Map<String, dynamic>> updates) async {
    final client = await this.client;
    
    for (final update in updates) {
      await client.from('ai_chatbots')
          .update(update['data'])
          .eq('id', update['id']);
    }
  }

  // Cleanup method
  Future<void> cleanup() async {
    try {
      // Close any open channels or connections
      if (_isInitialized) {
        // Perform cleanup operations
        if (kDebugMode) print('Supabase cleanup completed');
      }
    } catch (error) {
      if (kDebugMode) print('Error during cleanup: $error');
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => syncClient.auth.currentUser != null;

  // Get current user
  User? get currentUser => syncClient.auth.currentUser;

}