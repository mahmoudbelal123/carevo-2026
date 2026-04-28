import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_client.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../shared/models/service_model.dart';

class ServiceRepository {
  const ServiceRepository();

  Future<List<ServiceModel>> fetchServices() async {
    try {
      final raw = await supabase
          .from('services')
          .select()
          .eq('is_active', true)
          .order('sort_order');
      // Parse off main thread for large lists
      return await compute(_parseServices, raw);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }

  static List<ServiceModel> _parseServices(List<dynamic> raw) {
    return raw
        .cast<Map<String, dynamic>>()
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  }
}

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (_) => const ServiceRepository(),
);

final servicesProvider = FutureProvider.autoDispose<List<ServiceModel>>((ref) {
  return ref.watch(serviceRepositoryProvider).fetchServices();
});
