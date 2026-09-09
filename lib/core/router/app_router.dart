import 'package:go_router/go_router.dart';
import 'package:vine_butler/features/map/presentation/screens/map_screen.dart';
import 'package:vine_butler/features/property/presentation/screens/property_screen.dart';
import 'package:vine_butler/features/home/home_screen.dart';
import 'package:vine_butler/shared/widgets/main_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/property',
              builder: (context, state) => const PropertyScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/map',
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
