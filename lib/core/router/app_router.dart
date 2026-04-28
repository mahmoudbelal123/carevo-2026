import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../shared/models/service_model.dart';
import '../shell/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authRepo.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (_, state) => _fadePage(const LoginScreen(), state),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (_, state) => _slidePage(const RegisterScreen(), state),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (_, state) => _fadePage(const HomeScreen(), state),
          ),
          GoRoute(
            path: '/services',
            pageBuilder: (_, state) =>
                _slidePage(const ServicesScreen(), state),
          ),
          GoRoute(
            path: '/orders',
            pageBuilder: (_, state) => _fadePage(const OrdersScreen(), state),
          ),
        ],
      ),
      GoRoute(
        path: '/booking',
        pageBuilder: (_, state) {
          final service = state.extra as ServiceModel;
          return _slidePage(BookingScreen(service: service), state);
        },
      ),
      GoRoute(
        path: '/payment/:orderId',
        pageBuilder: (_, state) {
          final orderId = state.pathParameters['orderId']!;
          return _slidePage(PaymentScreen(orderId: orderId), state);
        },
      ),
      GoRoute(
        path: '/orders/:orderId',
        pageBuilder: (_, state) {
          final orderId = state.pathParameters['orderId']!;
          return _slidePage(OrderDetailScreen(orderId: orderId), state);
        },
      ),
    ],
  );
});

CustomTransitionPage<void> _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

CustomTransitionPage<void> _slidePage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
