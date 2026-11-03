import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../backend/auth/auth_repository.dart';
import '../features/calendar/presentation/calendar_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/projects/presentation/projects_page.dart';
import '../features/tasks/presentation/tasks_page.dart';
import 'pages/profile_page.dart';

class ProductivityShell extends StatelessWidget {
  const ProductivityShell({required this.authRepository, super.key});

  final AuthRepository authRepository;

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              _NavigationScaffold(authRepository: authRepository, child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomePage()),
            GoRoute(path: '/tasks', builder: (_, _) => const TasksPage()),
            GoRoute(path: '/calendar', builder: (_, _) => const CalendarPage()),
            GoRoute(path: '/projects', builder: (_, _) => const ProjectsPage()),
            GoRoute(
              path: '/profile',
              builder: (_, _) => ProfilePage(authRepository: authRepository),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router());
  }
}

class _NavigationScaffold extends StatelessWidget {
  const _NavigationScaffold({
    required this.authRepository,
    required this.child,
  });

  final AuthRepository authRepository;
  final Widget child;

  static const destinations = [
    ('Home', Icons.home_outlined, '/home'),
    ('Tasks', Icons.checklist_outlined, '/tasks'),
    ('Calendar', Icons.calendar_month_outlined, '/calendar'),
    ('Projects', Icons.folder_outlined, '/projects'),
    ('Profile', Icons.person_outline, '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = destinations.indexWhere(
      (destination) => destination.$3 == location,
    );
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (index) {
          context.go(destinations[index].$3);
        },
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.$2),
              label: destination.$1,
            ),
        ],
      ),
    );
  }
}
