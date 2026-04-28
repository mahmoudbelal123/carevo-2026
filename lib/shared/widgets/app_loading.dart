import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0x80FFFFFF),
      child: AppLoading(),
    );
  }
}
