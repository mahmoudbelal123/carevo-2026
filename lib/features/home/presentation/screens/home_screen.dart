import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/language_toggle_button.dart';
import '../../../../shared/widgets/offer_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/service_card.dart';
import '../../../home/data/repositories/offer_repository.dart';
import '../../../home/data/repositories/service_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final offersAsync = ref.watch(offersProvider);
    final profileAsync = ref.watch(profileProvider);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App bar with greeting ──
          SliverAppBar(
            expandedHeight: 190,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            actions: [
              const LanguageToggleButton(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person_outlined),
                onPressed: () => context.push('/profile'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    profileAsync.when(
                      data: (p) => Text(
                        '${l10n.t('hello')}, ${p?.fullName.split(' ').first ?? l10n.t('there')} 👋',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.t('bookAtDoorstep'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(28),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.workspace_premium_outlined,
                            size: 17,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.t('proCareEco'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Active Offers ──
                  offersAsync.when(
                    data: (offers) {
                      if (offers.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: l10n.t('specialOffers'),
                            action: l10n.t('seeAll'),
                            onActionTap: () {},
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 152,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: offers.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (_, i) =>
                                  OfferCard(offer: offers[i]),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  // ── Services ──
                  SectionHeader(
                    title: l10n.t('ourServices'),
                    action: l10n.t('viewAll'),
                    onActionTap: () => context.push('/services'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Services grid ──
          servicesAsync.when(
            data: (services) => SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => ServiceCard(
                    service: services[i],
                    onTap: () => context.push('/booking', extra: services[i]),
                  ),
                  childCount: services.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: AppLoading()),
            error: (e, _) => SliverToBoxAdapter(
              child: AppError(
                message: e.toString(),
                onRetry: () => ref.invalidate(servicesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
