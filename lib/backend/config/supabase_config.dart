import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured =>
      url.isNotEmpty && publishableKey.isNotEmpty;

  static Future<void> initialize() {
    return Supabase.initialize(
      url: url,
      publishableKey: publishableKey,
    );
  }
}
