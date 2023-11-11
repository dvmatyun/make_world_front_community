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
  /// Load the application and suggest some route (optional)
  Future<IAppConfigAim<T?>?> initialAppLoader();

  /// Decide which route to use as initial route (one is provided by [initialAppLoader]
  /// and other is provided by platform (URL for example))
  Future<IAppConfigAim<T?>> chooseInitialRoute({
    required IAppConfigAim<T?> platformInitialRoute,
    required IAppConfigAim<T?>? appLoaderRoute,
  });
}

class CustomRouteHandlerBaseAim<T> implements ICustomRouteHandlerAim<T> {
  final String _homeRoute;
  final String _splashScreenRoute;
  const CustomRouteHandlerBaseAim({
    String homeRoute = '/home',
    String splashScreenRoute = '/splash',
  })  : _homeRoute = homeRoute,
        _splashScreenRoute = splashScreenRoute;

  @override
  Future<IAppConfigAim<T?>?> initialAppLoader() async {
    return AppConfigAim.route(_homeRoute, args: null);
  }

  @override
  Future<IAppConfigAim<T?>> chooseInitialRoute({
    required IAppConfigAim<T?> platformInitialRoute,
    required IAppConfigAim<T?>? appLoaderRoute,
  }) async {
    final splashClear = _splashScreenRoute.replaceAll('/', '');
    final platformClear = platformInitialRoute.route.replaceAll('/', '');
    if (['', splashClear].contains(platformClear)) {
      return appLoaderRoute ?? platformInitialRoute;
    }
    return platformInitialRoute;
  }
}
