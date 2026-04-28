import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/widgets/carevo_app_bar.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key, required this.service});
  final ServiceModel service;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingProvider.notifier).selectService(widget.service);
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(hours: 2)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (time == null || !mounted) return;

    final combined = DateTime(
      date.year, date.month, date.day, time.hour, time.minute,
    );
    ref.read(bookingProvider.notifier).setScheduledTime(combined);
  }

  Future<void> _submit() async {
    await ref.read(bookingProvider.notifier).submitOrder();
    if (!mounted) return;
    final state = ref.read(bookingProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (state.createdOrderId != null) {
      context.pushReplacement('/payment/${state.createdOrderId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CarevoAppBar(title: 'Book a Wash'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Service summary card ──
            _ServiceSummaryCard(service: widget.service),
            const SizedBox(height: 24),

            // ── Date & Time ──
            Text('Schedule', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDateTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      bookingState.scheduledTime != null
                          ? DateFormat('EEE, MMM d • h:mm a')
                              .format(bookingState.scheduledTime!)
                          : 'Select date and time',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: bookingState.scheduledTime != null
                            ? AppColors.textDark
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Location ──
            Text('Location', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Enter your full address',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Icon(Icons.location_on_outlined),
                ),
              ),
              onChanged: (v) =>
                  ref.read(bookingProvider.notifier).setLocation(v),
            ),
            const SizedBox(height: 20),

            // ── Notes (optional) ──
            Text('Notes (optional)', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Any special instructions...',
              ),
              onChanged: (v) =>
                  ref.read(bookingProvider.notifier).setNotes(v),
            ),
            const SizedBox(height: 32),

            // ── Price summary ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: theme.textTheme.titleMedium),
                  Text(
                    'EGP ${bookingState.totalPrice.toStringAsFixed(0)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Submit ──
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: bookingState.canSubmit ? _submit : null,
                child: bookingState.isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Confirm Booking'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ServiceSummaryCard extends StatelessWidget {
  const _ServiceSummaryCard({required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_car_wash,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(
                      '${service.durationMinutes} min',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            'EGP ${service.price.toStringAsFixed(0)}',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
