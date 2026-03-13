import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/projects/screens/project_list_screen.dart';
import '../../features/projects/screens/project_detail_screen.dart';
import '../../features/layout/screens/layout_screen.dart';
import '../../features/simulation/screens/simulation_screen.dart';
import '../../features/electrical/screens/electrical_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/map/screens/map_screen.dart';
import '../widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProjectListScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => ProjectDetailScreen(
                  projectId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'layout',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => LayoutScreen(
                      projectId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'simulation',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => SimulationScreen(
                      projectId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'electrical',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ElectricalScreen(
                      projectId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'reports',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ReportsScreen(
                      projectId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'map',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => MapScreen(
                      projectId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
