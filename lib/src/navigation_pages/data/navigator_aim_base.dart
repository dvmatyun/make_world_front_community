import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/material_app_config_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/navigator_aim.dart';

class NavigatorAimBase<T> implements INavigatorBaseAim<T> {
  const NavigatorAimBase({
    required this.config,
  });

  @override
  final MaterialAppNavigatorConfigAim<T> config;

  IAppConfigAim<T?> get currentRoute => config.routerDelegate.typedConfig;

  @override
  void changeState(BuildContext context, T? args) {
    final delegate = config.routerDelegate;
    final newRoute = currentRoute.copyWith(args: args, removeArgs: args == null);
    Router.neglect(context, () {
      delegate.setNewRoutePath(
        newRoute,
      );
    });
  }

  @override
  void addToState(BuildContext context, T args) {
    final delegate = config.routerDelegate;
    final newRoute = currentRoute.addToState(args: args);
    Router.neglect(context, () {
      delegate.setNewRoutePath(
        newRoute,
      );
    });
  }

  @override
  void removeFromState(BuildContext context, T args) {
    final delegate = config.routerDelegate;
    final newRoute = currentRoute.removeFromState(args: args);
    Router.neglect(context, () {
      delegate.setNewRoutePath(
        newRoute,
      );
    });
  }

  @override
  Future<void> navigate(BuildContext context, IAppConfigAim<T?> route) async {
    final delegate = config.routerDelegate;
    Router.navigate(context, () {
      delegate.setNewRoutePath(route);
    });
  }

  @override
  Future<void> pushNamed(BuildContext context, String route, {T? args}) async {
    // ignore: unnecessary_cast
    final routeFactory = config.routeFactory as RouteConfigAimFactory<T>;
    final appConfig = routeFactory(route, args);
    if (appConfig == null) {
      return;
    }
    await navigate(context, appConfig);
  }
}
