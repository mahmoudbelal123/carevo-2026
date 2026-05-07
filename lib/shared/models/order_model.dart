import 'package:json_annotation/json_annotation.dart';

enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('on_the_way')
  onTheWay,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum PaymentStatus {
  @JsonValue('unpaid')
  unpaid,
  @JsonValue('pending_verification')
  pendingVerification,
  @JsonValue('paid')
  paid,
  @JsonValue('refunded')
  refunded,
}

class OrderStatusLog {
  final String id;
  final String orderId;
  final String status;
  final String note;
  final String? changedBy;
  final DateTime createdAt;

  const OrderStatusLog({
    required this.id,
    required this.orderId,
    required this.status,
    this.note = '',
    this.changedBy,
    required this.createdAt,
  });

  factory OrderStatusLog.fromJson(Map<String, dynamic> json) {
    return OrderStatusLog(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      status: json['status'] as String,
      note: json['note'] as String? ?? '',
      changedBy: json['changed_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'status': status,
        'note': note,
        'changed_by': changedBy,
        'created_at': createdAt.toIso8601String(),
      };
}

class OrderModel {
  final String id;
  final String userId;
  final String serviceId;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String locationAddress;
  final double? locationLat;
  final double? locationLng;
  final DateTime scheduledTime;
  final double totalPrice;
  final String? paymentProofUrl;
  final String notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<OrderStatusLog>? statusLogs;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.unpaid,
    this.locationAddress = '',
    this.locationLat,
    this.locationLng,
    required this.scheduledTime,
    required this.totalPrice,
    this.paymentProofUrl,
    this.notes = '',
    required this.createdAt,
    this.updatedAt,
    this.statusLogs,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      status: _parseOrderStatus(json['status'] as String),
      paymentStatus: _parsePaymentStatus(json['payment_status'] as String),
      locationAddress: json['location_address'] as String? ?? '',
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      paymentProofUrl: json['payment_proof_url'] as String?,
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      statusLogs: (json['statusLogs'] as List<dynamic>?)
          ?.map((e) => OrderStatusLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static OrderStatus _parseOrderStatus(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status || e.toString().split('.').last == status,
      orElse: () => OrderStatus.pending,
    );
  }

  static PaymentStatus _parsePaymentStatus(String status) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == status || e.toString().split('.').last == status,
      orElse: () => PaymentStatus.unpaid,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'service_id': serviceId,
        'status': status.name,
        'payment_status': paymentStatus.name,
        'location_address': locationAddress,
        'location_lat': locationLat,
        'location_lng': locationLng,
        'scheduled_time': scheduledTime.toIso8601String(),
        'total_price': totalPrice,
        'payment_proof_url': paymentProofUrl,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
