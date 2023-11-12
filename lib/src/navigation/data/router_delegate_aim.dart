import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/page_wrapper_aim.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/page_aim.dart';

typedef RouteBuilderAim<T> = IPageAim Function(IAppConfigAim<T> args);
typedef MapString = Map<String, String?>?;

abstract class IRouterDelegateAim<T> extends RouterDelegate<IAppConfigAim<Object?>> {
  Map<String, RouteBuilderAim<T?>> get routesAim;

  /// This page is shown if route is unknown
  RouteBuilderAim<T?> get fallbackRoute;

  /// This page is shown when app is loading
  RouteBuilderAim<T?> get splashScreenRoute;

  /// used for "untyped" navigator
  IAppConfigAim<T?> typeConfig(IAppConfigAim<Object?> source);

  IAppConfigAim<T?> get typedConfig;

  Stream<IAppConfigAim<T?>> get routesStream;

  void close();
}

//Map<String, String?>
class RouterDelegateAim extends IRouterDelegateAim<MapString> with ChangeNotifier {
  RouterDelegateAim({
    required this.routesAim,
    required this.fallbackRoute,
    required this.splashScreenRoute,
  });

  @override
  final Map<String, RouteBuilderAim<MapString>> routesAim;
  @override
  final RouteBuilderAim<MapString> fallbackRoute;
  @override
  final RouteBuilderAim<MapString> splashScreenRoute;

  final _routesSc = StreamController<IAppConfigAim<MapString>>.broadcast();
  @override
  Stream<IAppConfigAim<MapString>> get routesStream => _routesSc.stream;

  @override
  void close() {
    _routesSc.close();
  }

  IAppConfigAim<MapString> _currentState = const AppConfigMapAim.route('/');
  void _reportNewState(IAppConfigAim<MapString> newState) {
    _currentState = newState;
    _routesSc.add(newState);
    notifyListeners();
    print(' > setRestoredRoutePath route=${newState.route}, args=${newState.args} ');
  }

  @override
  IAppConfigAim<MapString> get currentConfiguration {
    return _currentState;
  }

  @override
  IAppConfigAim<MapString> get typedConfig => _currentState;

  final navigatorObserver = NavigatorObserver();

  IAppConfigAim<Map<String, String?>>? previousState;
  // for pop on User Page, to possibly go back to a specific book

  Iterable<Page<dynamic>> get _pagesIterable sync* {
    final state = _currentState;
    final routeName = state.route;
    final routeBuilder = routesAim[routeName] ?? fallbackRoute;

    final childPage = routeBuilder(state);
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
    return Navigator(
      observers: [navigatorObserver],
      //transitionDelegate: AnimationTransitionDelegate(),
      pages: _pagesIterable.toList(),
      reportsRouteUpdateToEngine: false,

      onGenerateInitialRoutes: (ns, s) {
        print(' > on generate initial routes: ns=$ns, s=$s');
        return [];
      },
      onPopPage: (route, result) {
        print(' > on pop page: route=$route, result=$result');
        return true;
      },
    );
  }

  // Make separate object for this and for web just ignore it.
  final List<IAppConfigAim<Object?>> _history = [];
  void _addToHistory(IAppConfigAim<Object?> config) {
    if (config.route == _history.lastOrNull?.route) {
      return;
    }
    _history.add(config);
  }

  IAppConfigAim<Object?>? _removeFromHistory() {
    if (_history.isEmpty) {
      return null;
    }
    final config = _history.removeLast();
    return config;
  }

  @override
  Future<void> setNewRoutePath(IAppConfigAim<Object?> configuration, {bool isPop = false}) async {
    final config = typeConfig(configuration);

    if (config == _currentState) return SynchronousFuture(null);

    if (!isPop) {
      if (config.route != _currentState.route) {
        _addToHistory(config);
      } else {
        if (_history.isNotEmpty) {
          _removeFromHistory();
        }
        _addToHistory(config);
      }
    }
    _reportNewState(config);

    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() {
    print(' > pop route');
    if (_history.isNotEmpty) {
      _removeFromHistory();
    }
    if (_history.isNotEmpty) {
      final route = _history.last;
      setNewRoutePath(route);
      return SynchronousFuture<bool>(true);
    }

    final navigator = navigatorObserver.navigator;
    if (navigator == null) {
      return SynchronousFuture<bool>(false);
    }
    return navigator.maybePop();
  }

  @override
  IAppConfigAim<MapString> typeConfig(IAppConfigAim<Object?> source) {
    final args = source.args is MapString ? source.args as MapString : null;
    final config = AppConfigMapAim(source.route, args: args);
    return config;
  }

  @override
  Future<void> setRestoredRoutePath(IAppConfigAim<Object?> configuration) {
    final config = typeConfig(configuration);
    return super.setRestoredRoutePath(config);
  }

  @override
  Future<void> setInitialRoutePath(IAppConfigAim<Object?> configuration) {
    final config = typeConfig(configuration);
    return super.setInitialRoutePath(config);
  }
}
