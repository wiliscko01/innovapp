import 'package:supabase_flutter/supabase_flutter.dart';

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
      String.fromEnvironment('SUPABASE_URL', defaultValue: 'your_supabase_url');
  static const String supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'your_supabase_anon_key');

  // Internal initialization logic
  static Future<void> _initializeSupabase() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _instance._client = Supabase.instance.client;
    _instance._isInitialized = true;
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

    return response;
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    await client.from('user_profiles').update(updates).eq('id', user.id);
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

  // AI Chatbot methods
  Future<List<dynamic>> getUserChatbots() async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    return await client
        .from('ai_chatbots')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
  }

  Future<void> createChatbot(Map<String, dynamic> chatbotData) async {
    final client = await this.client;
    final user = client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    await client.from('ai_chatbots').insert({
      ...chatbotData,
      'user_id': user.id,
    });
  }

  Future<void> updateChatbot(
      String chatbotId, Map<String, dynamic> updates) async {
    final client = await this.client;
    await client.from('ai_chatbots').update(updates).eq('id', chatbotId);
  }

  Future<void> deleteChatbot(String chatbotId) async {
    final client = await this.client;
    await client.from('ai_chatbots').delete().eq('id', chatbotId);
  }

  // Services methods
  Future<List<dynamic>> getServices() async {
    final client = await this.client;
    return await client
        .from('services')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false);
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToOrderMessages(
      String orderId, void Function(Map<String, dynamic>) callback) {
    final channel =
        syncClient.channel('order_messages_$orderId').onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'order_messages',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'order_id',
                value: orderId,
              ),
              callback: (PostgresChangePayload payload) => callback(payload.newRecord),
            );

    channel.subscribe();
    return channel;
  }

  // Check if user is authenticated
  bool get isAuthenticated => syncClient.auth.currentUser != null;

  // Get current user
  User? get currentUser => syncClient.auth.currentUser;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => syncClient.auth.onAuthStateChange;
}