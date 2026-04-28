import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_config.dart' as constants;
import '../../../../core/api/supabase_client.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/carevo_app_bar.dart';
import '../../data/repositories/config_repository.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  XFile? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (image == null) return;

    // Validate file size before accepting
    final file = File(image.path);
    final bytes = await file.length();
    if (bytes > constants.AppConfig.maxPaymentProofSizeBytes) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image too large. Maximum 5 MB.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _selectedImage = image);
  }

  Future<void> _submitPaymentConfirmation() async {
    setState(() => _isUploading = true);
    try {
      String? proofUrl;

      if (_selectedImage != null) {
        // Upload to Supabase Storage off main thread (File I/O)
        final bytes = await File(_selectedImage!.path).readAsBytes();
        final ext = _selectedImage!.path.split('.').last;
        final path = 'payment-proofs/${widget.orderId}.$ext';

        await supabase.storage
            .from('payment-proofs')
            .uploadBinary(path, bytes,
                fileOptions: FileOptions(
                  contentType: 'image/$ext',
                  upsert: true,
                ));

        proofUrl = supabase.storage
            .from('payment-proofs')
            .getPublicUrl(path);
      }

      // Update order payment status
      await supabase.from('orders').update({
        'payment_status': 'pending_verification',
        if (proofUrl != null) 'payment_proof_url': proofUrl,
      }).eq('id', widget.orderId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment submitted! We will verify and confirm.'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
      context.pushReplacement('/orders');
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.error,
        ),
      );
    } on Object catch (e) {
      final mapped = mapSupabaseError(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mapped.message),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _openInstapayLink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(configProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CarevoAppBar(title: 'Payment'),
      body: configAsync.when(
        data: (config) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accentSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withAlpha(60)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.payment,
                          color: AppColors.accent, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pay via InstaPay',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Send payment to the number or link below',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── InstaPay Number ──
              if (config.instapayNumber.isNotEmpty) ...[
                _InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'InstaPay Number',
                  value: config.instapayNumber,
                  onTap: () => _openInstapayLink(
                    'tel:${config.instapayNumber}',
                  ),
                  actionLabel: 'Copy',
                ),
                const SizedBox(height: 12),
              ],

              // ── InstaPay Link ──
              if (config.instapayLink.isNotEmpty) ...[
                _InfoTile(
                  icon: Icons.link_outlined,
                  label: 'Pay via Link',
                  value: config.instapayLink,
                  onTap: () => _openInstapayLink(config.instapayLink),
                  actionLabel: 'Open',
                  actionColor: AppColors.primary,
                ),
                const SizedBox(height: 12),
              ],

              // ── Payment Instructions ──
              if (config.paymentInstructions.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 18, color: AppColors.info),
                          const SizedBox(width: 8),
                          Text(
                            'Instructions',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        config.paymentInstructions,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Upload proof (optional) ──
              Text('Upload Receipt (optional)',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedImage != null
                          ? AppColors.primary
                          : AppColors.border,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_upload_outlined,
                                size: 32, color: AppColors.textMuted),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to select image',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Confirm button ──
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _submitPaymentConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'I Have Paid',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const AppLoading(),
        error: (e, _) => AppError(
          message: e.toString(),
          onRetry: () => ref.invalidate(configProvider),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    required this.actionLabel,
    this.actionColor = AppColors.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final String actionLabel;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(foregroundColor: actionColor),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
