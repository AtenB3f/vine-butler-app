import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/main_shell.dart';
import 'package:vine_butler/features/apply_property/presentation/screens/apply_property_screen.dart';
import 'package:vine_butler/features/find_property/presentation/screens/find_property_screen.dart';
import 'package:vine_butler/features/home/presentation/screens/home_screen.dart';
import 'package:vine_butler/features/map/presentation/screens/map_screen.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_screen.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_list_screen.dart';

part 'app_router.g.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: $appRoutes,
);

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<PropertyBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<PropertyListRoute>(path: '/property'),
      ],
    ),
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRoute>(path: '/home'),
      ],
    ),
    TypedStatefulShellBranch<MapBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<MapRoute>(path: '/map'),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainShell(navigationShell: navigationShell);
  }
}

class PropertyBranchData extends StatefulShellBranchData {
  const PropertyBranchData();
}

class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

class MapBranchData extends StatefulShellBranchData {
  const MapBranchData();
}

class PropertyListRoute extends GoRouteData with $PropertyListRoute {
  const PropertyListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const PropertyListScreen();
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class MapRoute extends GoRouteData with $MapRoute {
  const MapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MapScreen();
}

@TypedGoRoute<FindPropertyRoute>(path: '/find-property')
class FindPropertyRoute extends GoRouteData with $FindPropertyRoute {
  const FindPropertyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const FindPropertyScreen();
}

@TypedGoRoute<ApplyPropertyRoute>(path: '/apply-property')
class ApplyPropertyRoute extends GoRouteData with $ApplyPropertyRoute {
  const ApplyPropertyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ApplyPropertyScreen();
}

@TypedGoRoute<PropertyDetailRoute>(path: '/property/:id')
class PropertyDetailRoute extends GoRouteData with $PropertyDetailRoute {
  const PropertyDetailRoute({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) => PropertyDetailScreen(id: id);
}
