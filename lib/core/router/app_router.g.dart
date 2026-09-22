// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $mainShellRouteData,
  $findPropertyRoute,
  $applyPropertyRoute,
  $propertyDetailRoute,
];

RouteBase get $mainShellRouteData => StatefulShellRouteData.$route(
  factory: $MainShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/property',
          hasOverriddenOnExit: false,
          factory: $PropertyListRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/map',
          hasOverriddenOnExit: false,
          factory: $MapRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainShellRouteDataExtension on MainShellRouteData {
  static MainShellRouteData _fromState(GoRouterState state) =>
      const MainShellRouteData();
}

mixin $PropertyListRoute on GoRouteData {
  static PropertyListRoute _fromState(GoRouterState state) =>
      const PropertyListRoute();

  @override
  String get location => GoRouteData.$location('/property');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MapRoute on GoRouteData {
  static MapRoute _fromState(GoRouterState state) => const MapRoute();

  @override
  String get location => GoRouteData.$location('/map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $findPropertyRoute => GoRouteData.$route(
  path: '/find-property',
  hasOverriddenOnExit: false,
  factory: $FindPropertyRoute._fromState,
);

mixin $FindPropertyRoute on GoRouteData {
  static FindPropertyRoute _fromState(GoRouterState state) =>
      const FindPropertyRoute();

  @override
  String get location => GoRouteData.$location('/find-property');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $applyPropertyRoute => GoRouteData.$route(
  path: '/apply-property',
  hasOverriddenOnExit: false,
  factory: $ApplyPropertyRoute._fromState,
);

mixin $ApplyPropertyRoute on GoRouteData {
  static ApplyPropertyRoute _fromState(GoRouterState state) =>
      const ApplyPropertyRoute();

  @override
  String get location => GoRouteData.$location('/apply-property');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $propertyDetailRoute => GoRouteData.$route(
  path: '/property/:id',
  hasOverriddenOnExit: false,
  factory: $PropertyDetailRoute._fromState,
);

mixin $PropertyDetailRoute on GoRouteData {
  static PropertyDetailRoute _fromState(GoRouterState state) =>
      PropertyDetailRoute(id: int.parse(state.pathParameters['id']!));

  PropertyDetailRoute get _self => this as PropertyDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/property/${Uri.encodeComponent(_self.id.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
