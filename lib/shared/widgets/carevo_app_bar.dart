import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class CarevoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CarevoAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.backgroundColor = AppColors.primary,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      leading: leading,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                )
              : null),
      actions: actions,
    );
  }
}
