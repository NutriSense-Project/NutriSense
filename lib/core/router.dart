import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/daily_input/screens/daily_input_screen.dart';
import '../features/calendar/screens/calendar_screen.dart';
import '../features/stats/screens/stats_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import 'theme/theme_controller.dart';

final appRouter = GoRouter(
  initialLocation: '/daily',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNav(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/daily',
              builder: (context, state) {
                final dateStr = state.uri.queryParameters['date'];
                final selectedDate = dateStr != null ? DateTime.tryParse(dateStr) : null;
                return DailyInputScreen(selectedDate: selectedDate);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// Bottom Navigation with Theme Reactivity
class ScaffoldWithBottomNav extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNav({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'History'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}