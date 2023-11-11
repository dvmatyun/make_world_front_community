import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/page_wrapper_aim.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/page_aim.dart';

typedef RouteBuilderAim<T> = IPageAim Function(IAppConfigAim<T> args);

abstract class IRouterDelegateAim<T> extends RouterDelegate<IAppConfigAim<Object?>> {
  Map<String, RouteBuilderAim<T?>> get routesAim;

  /// This page is shown if route is unknown
  RouteBuilderAim<T?> get fallbackRoute;

  /// This page is shown when app is loading
  RouteBuilderAim<T?> get splashScreenRoute;

  /// used for "untyped" navigator
  IAppConfigAim<T?> typeConfig(IAppConfigAim<Object?> source);

  IAppConfigAim<T?> get typedConfig;
}

//Map<String, String?>
class RouterDelegateAim extends IRouterDelegateAim<Map<String, String?>?> with ChangeNotifier {
  RouterDelegateAim({
    required this.routesAim,
    required this.fallbackRoute,
    required this.splashScreenRoute,
  });

  @override
  final Map<String, RouteBuilderAim<Map<String, String?>?>> routesAim;
  @override
  final RouteBuilderAim<Map<String, String?>?> fallbackRoute;
  @override
  final RouteBuilderAim<Map<String, String?>?> splashScreenRoute;

  /*
  static RouterDelegateAim of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is RouterDelegateAim, 'Delegate type must match');
    return delegate as RouterDelegateAim;
  }
  */

  IAppConfigAim<Map<String, String?>?> currentState = const AppConfigMapAim.route('/');
  @override
  IAppConfigAim<Map<String, String?>?> get typedConfig => currentState;

  final navigatorObserver = NavigatorObserver();

  IAppConfigAim<Map<String, String?>>? previousState;
  // for pop on User Page, to possibly go back to a specific book

  @override
  IAppConfigAim<Map<String, String?>?> get currentConfiguration {
    return currentState;
  }

  Iterable<Page<dynamic>> get _pagesIterable sync* {
    final state = currentState;
    final routeName = state.route;
    final routeBuilder = routesAim[routeName] ?? fallbackRoute;

    final childPage = routeBuilder(state);
    print(' > _pagesIterable (route name: $routeName) page: ${childPage.nameUi}');
    yield MaterialPage(
      key: ValueKey(childPage.key),
      name: childPage.nameUi,
      child: PageWrapperAim(
        metaName: childPage.nameUi,
        child: childPage.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('BookRouterDelegate building...');
    print(currentState);
    return Navigator(
      observers: [navigatorObserver],
      //transitionDelegate: AnimationTransitionDelegate(),
      pages: _pagesIterable.toList(),
      reportsRouteUpdateToEngine: false,
      onGenerateInitialRoutes: (ns, s) {
        return [];
      },
      onPopPage: (route, result) {
        print(' > on pop page: route=$route, result=$result');
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(IAppConfigAim<Object?> configuration) async {
    final config = typeConfig(configuration);
    print(' > setRestoredRoutePath route=${config.route}, args=${config.args} ');
    if (config == currentState) return SynchronousFuture(null);

    currentState = config;
    notifyListeners();

    return SynchronousFuture(null);
  }

  @override
  IAppConfigAim<Map<String, String?>?> typeConfig(IAppConfigAim<Object?> source) {
    final args = source.args is Map<String, String?>? ? source.args as Map<String, String?>? : null;
    final config = AppConfigAim<Map<String, String?>?>(source.route, args: args);
    return config;
  }

  @override
  Future<void> setRestoredRoutePath(IAppConfigAim<Object?> configuration) {
    final config = typeConfig(configuration);
    print(' > setRestoredRoutePath $config');
    return super.setRestoredRoutePath(config);
  }

  @override
  Future<void> setInitialRoutePath(IAppConfigAim<Object?> configuration) {
    final config = typeConfig(configuration);
    print(' > setInitialRoutePath $config');
    return super.setInitialRoutePath(config);
  }

  @override
  Future<bool> popRoute() {
    print(' > pop route');
    final navigator = navigatorObserver.navigator; // navigatorKey.currentState;
    if (navigator == null) {
      return SynchronousFuture<bool>(false);
    }
    return navigator.maybePop();
  }
}
