import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/app_colors.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 14,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) => _onNavTap(context, i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_car_wash_outlined),
                activeIcon: Icon(Icons.local_car_wash_rounded),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long_rounded),
                label: 'Orders',
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _indexFromLocation(String location) {
    if (location.startsWith('/services')) return 1;
    if (location.startsWith('/orders')) return 2;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/services');
      case 2:
        context.go('/orders');
    }
  }
}
