import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_client.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../shared/models/offer_model.dart';

class OfferRepository {
  const OfferRepository();

  Future<List<OfferModel>> fetchOffers() async {
    try {
      final raw = await supabase
          .from('offers')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);
      return await compute(_parseOffers, raw);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }

  static List<OfferModel> _parseOffers(List<dynamic> raw) {
    return raw
        .cast<Map<String, dynamic>>()
        .map((e) => OfferModel.fromJson(e))
        .toList();
  }
}

final offerRepositoryProvider = Provider<OfferRepository>(
  (_) => const OfferRepository(),
);

final offersProvider = FutureProvider.autoDispose<List<OfferModel>>((ref) {
  return ref.watch(offerRepositoryProvider).fetchOffers();
});
