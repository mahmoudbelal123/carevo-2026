import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../shared/models/order_model.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/carevo_app_bar.dart';
import '../../../../shared/widgets/order_status_chip.dart';
import '../../data/repositories/order_repository.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CarevoAppBar(title: 'Order Details'),
      body: orderAsync.when(
        data: (order) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Status card ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    OrderStatusChip(status: order.status),
                    const SizedBox(height: 12),
                    Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM d, yyyy').format(order.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Details ──
              _Section(
                title: 'Booking Details',
                children: [
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: order.locationAddress.isNotEmpty
                        ? order.locationAddress
                        : '—',
                  ),
                  _DetailRow(
                    icon: Icons.schedule_outlined,
                    label: 'Scheduled',
                    value: DateFormat('MMM d, yyyy • h:mm a')
                        .format(order.scheduledTime),
                  ),
                  _DetailRow(
                    icon: Icons.payments_outlined,
                    label: 'Total',
                    value: 'EGP ${order.totalPrice.toStringAsFixed(0)}',
                    valueColor: AppColors.primary,
                  ),
                  if (order.notes.isNotEmpty)
                    _DetailRow(
                      icon: Icons.notes_outlined,
                      label: 'Notes',
                      value: order.notes,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Payment ──
              _Section(
                title: 'Payment',
                children: [
                  _DetailRow(
                    icon: Icons.verified_outlined,
                    label: 'Payment Status',
                    value: _paymentLabel(order.paymentStatus),
                    valueColor: _paymentColor(order.paymentStatus),
                  ),
                  if (order.paymentProofUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order.paymentProofUrl!,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Status timeline ──
              if (order.statusLogs != null && order.statusLogs!.isNotEmpty) ...[
                _Section(
                  title: 'Status Timeline',
                  children: [
                    _StatusTimeline(logs: order.statusLogs!),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // ── Pay now button if unpaid ──
              if (order.paymentStatus == PaymentStatus.unpaid)
                ElevatedButton(
                  onPressed: () => context.push('/payment/${order.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const AppLoading(),
        error: (e, _) => AppError(
          message: e.toString(),
          onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
        ),
      ),
    );
  }

  String _paymentLabel(PaymentStatus s) => switch (s) {
        PaymentStatus.unpaid => 'Unpaid',
        PaymentStatus.pendingVerification => 'Pending Verification',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.refunded => 'Refunded',
      };

  Color _paymentColor(PaymentStatus s) => switch (s) {
        PaymentStatus.unpaid => AppColors.error,
        PaymentStatus.pendingVerification => AppColors.warning,
        PaymentStatus.paid => AppColors.success,
        PaymentStatus.refunded => AppColors.info,
      };
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight: valueColor != null ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.logs});
  final List<OrderStatusLog> logs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: List.generate(logs.length, (i) {
        final log = logs[i];
        final isLast = i == logs.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLast ? AppColors.primary : AppColors.textDisabled,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.divider,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.status.replaceAll('_', ' ').toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isLast ? AppColors.primary : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (log.note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(log.note, style: theme.textTheme.bodySmall),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM d • h:mm a').format(log.createdAt),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
