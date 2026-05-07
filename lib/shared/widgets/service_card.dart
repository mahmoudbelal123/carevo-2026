import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, this.onTap});

  final ServiceModel service;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image - fixed height with bounded cache dims to save RAM
              SizedBox(
                height: 120,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: service.imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 400,
                  memCacheHeight: 240,
                  placeholder: (_, __) => const ColoredBox(
                    color: AppColors.surfaceVariant,
                    child: Center(
                      child: Icon(
                        Icons.local_car_wash,
                        color: AppColors.textDisabled,
                        size: 32,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => const ColoredBox(
                    color: AppColors.surfaceVariant,
                    child: Center(
                      child: Icon(
                        Icons.local_car_wash,
                        color: AppColors.textDisabled,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              // Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EGP ${service.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 13,
                                color: AppColors.textMedium,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${service.durationMinutes} min',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.textMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
