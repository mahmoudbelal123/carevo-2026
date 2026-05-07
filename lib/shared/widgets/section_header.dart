import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onActionTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        if (action != null)
          TextButton(
            onTap: onActionTap,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
