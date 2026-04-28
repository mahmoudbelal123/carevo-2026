import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus {
  @JsonValue('pending') pending,
  @JsonValue('confirmed') confirmed,
  @JsonValue('on_the_way') onTheWay,
  @JsonValue('in_progress') inProgress,
  @JsonValue('completed') completed,
  @JsonValue('cancelled') cancelled,
}

enum PaymentStatus {
  @JsonValue('unpaid') unpaid,
  @JsonValue('pending_verification') pendingVerification,
  @JsonValue('paid') paid,
  @JsonValue('refunded') refunded,
}

@freezed
class OrderStatusLog with _$OrderStatusLog {
  const factory OrderStatusLog({
    required String id,
    required String orderId,
    required String status,
    @Default('') String note,
    String? changedBy,
    required DateTime createdAt,
  }) = _OrderStatusLog;

  factory OrderStatusLog.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusLogFromJson(json);
}

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String userId,
    required String serviceId,
    @Default(OrderStatus.pending) OrderStatus status,
    @Default(PaymentStatus.unpaid) PaymentStatus paymentStatus,
    @Default('') String locationAddress,
    double? locationLat,
    double? locationLng,
    required DateTime scheduledTime,
    required double totalPrice,
    String? paymentProofUrl,
    @Default('') String notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    List<OrderStatusLog>? statusLogs,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
