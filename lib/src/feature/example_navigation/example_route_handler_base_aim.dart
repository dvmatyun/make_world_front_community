import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/material_app_config_aim.dart';

class ExampleRoutehandlerBaseAim<T> extends CustomRouteHandlerBaseAim<T> {
  ExampleRoutehandlerBaseAim({
    required this.userService,
    required super.routeFactory,
    String loginRoute = '/login',
    super.homeRoute,
    super.splashScreenRoute,
  }) : _loginRoute = loginRoute;
  final ExampleUserManageService userService;
  final String _loginRoute;

  @override
  Future<IAppConfigAim<T?>?> rootRouteLoader() async {
    final isUserLoggedIn = await userService.isUserLoggedIn();
    if (isUserLoggedIn) {
      return routeFactory(_loginRoute, null);
    } else {
      return routeFactory(homeRoute, null);
    }
  }

  @override
  Future<IAppConfigAim<T?>?> initialAppLoader({required IAppConfigAim<T?>? rootRoute}) async {
    final isUserLoggedIn = await userService.isUserLoggedIn();
    if (isUserLoggedIn) {
      return routeFactory(_loginRoute, null);
    } else {
      return routeFactory(homeRoute, null);
    }
  }

  @override
  Future<IAppConfigAim<T?>?> chooseInitialRoute({
    required IAppConfigAim<T?> platformInitialRoute,
    required IAppConfigAim<T?>? appLoaderRoute,
    required IAppConfigAim<T?>? rootRoute,
  }) async {
    final route = await super.chooseInitialRoute(
      platformInitialRoute: platformInitialRoute,
      appLoaderRoute: appLoaderRoute,
      rootRoute: rootRoute,
    );
    final isUserLoggedIn = await userService.isUserLoggedIn();
    if (isUserLoggedIn) {
      return route;
    } else {
      return appLoaderRoute ?? rootRoute;
    }
  }
}

final $exampleUserService = ExampleUserManageService();

class ExampleUserManageService {
  bool? _isLogged;

  Future<bool> isUserLoggedIn() async {
    return _isLogged ?? await _checkIsUserLogged();
  }

  Future<bool> _checkIsUserLogged() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return _isLogged ??= false;
  }

  Future<void> login(String username, String password) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    _isLogged = true;
  }

  Future<void> logout() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _isLogged = false;
  }
}
