// This file makes up the components of the Dashboard Router,
// which defines the navigation for the Dashboard feature of the app.
// It includes the main route for the Dashboard Screen.

import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_screen.dart';

final dashboardRoutes = [
  GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
];

