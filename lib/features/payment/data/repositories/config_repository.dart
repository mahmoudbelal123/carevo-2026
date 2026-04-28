import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_client.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../shared/models/config_model.dart';

class ConfigRepository {
  const ConfigRepository();

  Future<AppConfig> fetchConfig() async {
    try {
      final raw = await supabase.from('config').select();
      final entries = (raw as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((e) => ConfigEntry.fromJson(e))
          .toList();
      return AppConfig.fromEntries(entries);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }
}

final configRepositoryProvider = Provider<ConfigRepository>(
  (_) => const ConfigRepository(),
);

// keepAlive = true so config is fetched once per session and stays in memory
final configProvider = FutureProvider<AppConfig>((ref) {
  return ref.watch(configRepositoryProvider).fetchConfig();
});
