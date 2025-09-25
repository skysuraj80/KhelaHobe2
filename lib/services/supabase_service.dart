import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  // Initialize Supabase - call this in main()
  static Future<void> initialize() async {
    // Load credentials from env.json
    final envString = await rootBundle.loadString('assets/env.json');
    final env = json.decode(envString);

    final supabaseUrl = env['SUPABASE_URL'];
    final supabaseAnonKey = env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined in env.json.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  // Get Supabase client
  SupabaseClient get client => Supabase.instance.client;
}
