import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/carevo_app_bar.dart';
import '../../../../shared/widgets/service_card.dart';
import '../../../home/data/repositories/service_repository.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CarevoAppBar(title: l10n.t('services')),
      body: servicesAsync.when(
        data: (services) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(servicesProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: services.length,
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ServiceCard(
                service: services[i],
                onTap: () => context.push('/booking', extra: services[i]),
              ),
            ),
          ),
        ),
        loading: () => const AppLoading(),
        error: (e, _) => AppError(
          message: e.toString(),
          onRetry: () => ref.invalidate(servicesProvider),
        ),
      ),
    );
  }
}
