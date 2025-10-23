import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_screen.dart';

final dashboardRoutes = [
  GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
];

/// Routes for Dashboard feature.
/// - Defines '/' root route to DashboardScreen.
/// Future: add '/settings' or other dashboard-related paths.