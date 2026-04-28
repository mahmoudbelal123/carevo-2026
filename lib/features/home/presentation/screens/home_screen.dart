import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App bar with greeting ──
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            actions: [
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
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    profileAsync.when(
                      data: (p) => Text(
                        'Hello, ${p?.fullName.split(' ').first ?? 'there'} 👋',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Book a car wash at your doorstep',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
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
                            title: 'Special Offers',
                            action: 'See all',
                            onActionTap: () {},
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 140,
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
                    title: 'Our Services',
                    action: 'View all',
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
                    onTap: () => context.push(
                      '/booking',
                      extra: services[i],
                    ),
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
