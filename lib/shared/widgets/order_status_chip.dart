import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';
import '../models/order_model.dart';

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _labelAndColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  static (String, Color) _labelAndColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => ('Pending', AppColors.statusPending),
      OrderStatus.confirmed => ('Confirmed', AppColors.statusConfirmed),
      OrderStatus.onTheWay => ('On The Way', AppColors.statusOnTheWay),
      OrderStatus.inProgress => ('In Progress', AppColors.statusInProgress),
      OrderStatus.completed => ('Completed', AppColors.statusCompleted),
      OrderStatus.cancelled => ('Cancelled', AppColors.statusCancelled),
    };
  }
}
