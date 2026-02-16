import 'package:dynasty_app/config/supabase_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Supabase config has valid URL and key', () {
    // Verify URL format
    expect(SupabaseConfig.url, isNotEmpty);
    expect(SupabaseConfig.url, contains('supabase.co'));

    // Verify anon key is present
    expect(SupabaseConfig.anonKey, isNotEmpty);
    expect(SupabaseConfig.anonKey.length, greaterThan(100));

    // Verify URL is parseable
    final uri = Uri.parse(SupabaseConfig.url);
    expect(uri.host, isNotEmpty);
  });
}
