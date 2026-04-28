import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/supabase_client.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../shared/models/order_model.dart';
import '../../../../shared/models/service_model.dart';

class BookingState {
  const BookingState({
    this.selectedService,
    this.scheduledTime,
    this.locationAddress = '',
    this.notes = '',
    this.isSubmitting = false,
    this.error,
    this.createdOrderId,
  });

  final ServiceModel? selectedService;
  final DateTime? scheduledTime;
  final String locationAddress;
  final String notes;
  final bool isSubmitting;
  final String? error;
  final String? createdOrderId;

  double get totalPrice => selectedService?.price ?? 0.0;

  bool get canSubmit =>
      selectedService != null &&
      scheduledTime != null &&
      locationAddress.isNotEmpty &&
      !isSubmitting;

  BookingState copyWith({
    ServiceModel? selectedService,
    DateTime? scheduledTime,
    String? locationAddress,
    String? notes,
    bool? isSubmitting,
    String? error,
    String? createdOrderId,
  }) {
    return BookingState(
      selectedService: selectedService ?? this.selectedService,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      locationAddress: locationAddress ?? this.locationAddress,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      createdOrderId: createdOrderId ?? this.createdOrderId,
    );
  }
}

class BookingNotifier extends AutoDisposeNotifier<BookingState> {
  @override
  BookingState build() => const BookingState();

  void selectService(ServiceModel service) {
    state = state.copyWith(selectedService: service);
  }

  void setScheduledTime(DateTime time) {
    state = state.copyWith(scheduledTime: time);
  }

  void setLocation(String address) {
    state = state.copyWith(locationAddress: address);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  Future<void> submitOrder() async {
    if (!state.canSubmit) return;
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw const AuthException('Not authenticated.');

      final row = await supabase
          .from('orders')
          .insert({
            'user_id': userId,
            'service_id': state.selectedService!.id,
            'status': 'pending',
            'payment_status': 'unpaid',
            'location_address': state.locationAddress,
            'scheduled_time': state.scheduledTime!.toIso8601String(),
            'total_price': state.totalPrice,
            'notes': state.notes,
          })
          .select('id')
          .single();

      final orderId = row['id'] as String;

      // Log the initial status
      await supabase.from('order_status_logs').insert({
        'order_id': orderId,
        'status': 'pending',
        'note': 'Order placed',
        'changed_by': userId,
      });

      state = state.copyWith(
        isSubmitting: false,
        createdOrderId: orderId,
      );
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.message);
    } on Object catch (e) {
      final mapped = mapSupabaseError(e);
      state = state.copyWith(isSubmitting: false, error: mapped.message);
    }
  }
}

final bookingProvider =
    AutoDisposeNotifierProvider<BookingNotifier, BookingState>(
  BookingNotifier.new,
);
