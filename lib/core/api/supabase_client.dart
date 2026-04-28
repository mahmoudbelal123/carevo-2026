import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

// Single accessor for the shared Supabase client instance.
// Supabase.initialize() must be called in main() before this is used.
SupabaseClient get supabase => Supabase.instance.client;

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
}
