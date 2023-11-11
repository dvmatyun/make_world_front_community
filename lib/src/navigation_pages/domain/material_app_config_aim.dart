import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_route_information_parser.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';

class MaterialAppNavigatorConfigAim<T> {
  const MaterialAppNavigatorConfigAim({
    required this.customRouteHandler,
    required this.routerDelegate,
    required this.routeInformationParser,
  });

  /// Handle initial route
  final ICustomRouteHandlerAim<T> customRouteHandler;

  /// Build navigation tree from route
  final IRouterDelegateAim<T> routerDelegate;

  /// Parse route to URL and back to logical object of route
  final IRouteInformationParserAim<T?> routeInformationParser;
}

abstract class ICustomRouteHandlerAim<T> {
  ICustomRouteHandlerAim();

  /// Load the optional root route
  /// Can be "Log in" page or "Home" page.
  Future<IAppConfigAim<T?>?> rootRouteLoader();

  /// Load the application and suggest some route (optional)
  Future<IAppConfigAim<T?>?> initialAppLoader({required IAppConfigAim<T?>? rootRoute});

  /// Decide which route to use as initial route (one is provided by [initialAppLoader]
  /// and other is provided by platform (URL for example))
  /// One of the routes will be ignored.
  /// You must not return [rootRoute].
  Future<IAppConfigAim<T?>?> chooseInitialRoute({
    required IAppConfigAim<T?> platformInitialRoute,
    required IAppConfigAim<T?>? appLoaderRoute,
    required IAppConfigAim<T?>? rootRoute,
  }) async {
    _initialPlatformRoute = platformInitialRoute;
    final route = appLoaderRoute ?? platformInitialRoute;
    if (route.route == rootRoute?.route) {
      return null;
    }
    return route;
  }

  IAppConfigAim<T?>? _initialPlatformRoute;

  /// Initial platform route that may contain some info from deeplink (like registration code)
  IAppConfigAim<T?>? get initialPlatformRoute => _initialPlatformRoute;
}

class CustomRouteHandlerBaseAim<T> extends ICustomRouteHandlerAim<T> {
  final String _homeRoute;
  final String _splashScreenRoute;
  CustomRouteHandlerBaseAim({
    String homeRoute = '/home',
    String splashScreenRoute = '/splash',
  })  : _homeRoute = homeRoute,
        _splashScreenRoute = splashScreenRoute;

  @override
  Future<IAppConfigAim<T?>?> rootRouteLoader() async {
    return AppConfigAim.route(_homeRoute, args: null);
  }

  @override
  Future<IAppConfigAim<T?>?> initialAppLoader({required IAppConfigAim<T?>? rootRoute}) async {
    if (rootRoute?.route == _homeRoute) {
      return null;
    }
    return AppConfigAim.route(_homeRoute, args: null);
  }

  @override
  Future<IAppConfigAim<T?>?> chooseInitialRoute({
    required IAppConfigAim<T?> platformInitialRoute,
    required IAppConfigAim<T?>? appLoaderRoute,
    required IAppConfigAim<T?>? rootRoute,
  }) async {
    await super.chooseInitialRoute(
      platformInitialRoute: platformInitialRoute,
      appLoaderRoute: appLoaderRoute,
      rootRoute: rootRoute,
    );

    final splashClear = _splashScreenRoute.replaceAll('/', '');
    final platformClear = platformInitialRoute.route.replaceAll('/', '');
    if (['', splashClear].contains(platformClear)) {
      return appLoaderRoute ?? platformInitialRoute;
    }
    return platformInitialRoute;
  }
}
