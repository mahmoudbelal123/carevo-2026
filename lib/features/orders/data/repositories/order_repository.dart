import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_client.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../shared/models/order_model.dart';

class OrderRepository {
  const OrderRepository();

  Future<List<OrderModel>> fetchOrders({
    int page = 0,
    OrderStatus? statusFilter,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw const AuthException();

      var query = supabase
          .from('orders')
          .select('*, order_status_logs(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(
            page * AppConfig.orderPageSize,
            (page + 1) * AppConfig.orderPageSize - 1,
          );

      if (statusFilter != null) {
        query = query.eq('status', statusFilter.name);
      }

      final raw = await query;
      return await compute(_parseOrders, raw);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }

  Future<OrderModel> fetchOrderById(String orderId) async {
    try {
      final data = await supabase
          .from('orders')
          .select('*, order_status_logs(*)')
          .eq('id', orderId)
          .single();
      return OrderModel.fromJson(_normalizeOrder(data));
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }

  static List<OrderModel> _parseOrders(List<dynamic> raw) {
    return raw
        .cast<Map<String, dynamic>>()
        .map((e) => OrderModel.fromJson(_normalizeOrder(e)))
        .toList();
  }

  static Map<String, dynamic> _normalizeOrder(Map<String, dynamic> data) {
    // Rename joined table key to match model field
    final result = Map<String, dynamic>.from(data);
    if (result.containsKey('order_status_logs')) {
      result['statusLogs'] = result.remove('order_status_logs');
    }
    return result;
  }
}

final orderRepositoryProvider = Provider<OrderRepository>(
  (_) => const OrderRepository(),
);

final ordersProvider = FutureProvider.autoDispose<List<OrderModel>>((ref) {
  return ref.watch(orderRepositoryProvider).fetchOrders();
});

final orderDetailProvider =
    FutureProvider.autoDispose.family<OrderModel, String>((ref, orderId) {
  return ref.watch(orderRepositoryProvider).fetchOrderById(orderId);
});
