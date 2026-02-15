import 'package:supabase/supabase.dart';
import '../lib/config/supabase_config.dart';

void main() async {
  print('Testing Supabase Connection...');
  print('URL: ${SupabaseConfig.url}');
  
  try {
    // Basic format check
    final uri = Uri.parse('https://' + SupabaseConfig.url); // Use valid scheme
    print('URL parse successful: $uri');
    
    // Attempt initialization (mock or real if possible in pure Dart script?)
    // Supabase.initialize requires Flutter bindings usually.
    // We can use SupabaseClient directly for pure Dart test.
    
    final client = SupabaseClient(
      'https://${SupabaseConfig.url}', // Ensure protocol is present
      SupabaseConfig.anonKey,
    );
    
    print('SupabaseClient initialized successfully.');
    
    // Try a simple health check or just check if client is created without error.
    // Without a known table, we can't query much, but we can check auth state (which should be empty).
    print('Current Session: ${client.auth.currentSession}');
    print('Connection test passed (Client instantiated).');
    
  } catch (e) {
    print('Connection test failed: $e');
  }
}
