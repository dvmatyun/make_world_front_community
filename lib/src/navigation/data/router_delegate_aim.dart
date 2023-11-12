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
    //
    final history = _pagesHistory.history.where((x) => x.state.route != routeName).map((e) => e.page).toList();
    print(' > pages history: ${history.map((e) => e.name).join(',')} // $routeName');
    yield* history;
    //

    yield MaterialPage(
      key: ValueKey(childPage.key),
      name: childPage.nameUi,
      child: PageWrapperAim(
        metaName: childPage.nameUi,
        child: childPage.child,
      ),
    );
  }

  Page<dynamic> _buildPage(IAppConfigAim<MapString> config) {
    final state = config;
    final routeName = state.route;
    final routeBuilder = routesAim[routeName] ?? fallbackRoute;
    final childPage = routeBuilder(state);
    return MaterialPage(
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
    //Navigator.of(context).pushNamed('test');
    //Navigator.of(context).pop();
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
        _onPopPageLock();
        print(' > on pop page: _popLock = $_popLock / $_onPopPageLockValue');
        if (_popLock || _onPopPageLockValue) return false;

        print(' > on pop page: route=$route, result=$result');
        // let the OS handle the back press if there was nothing to pop
        if (!route.didPop(result)) return false;

        print(' > on pop page: _pagesHistory.history');
        if (_pagesHistory.history.isEmpty) return false;
        popRoute();
        return false;
      },
    );
  }

  bool _onPopPageLockValue = false;
  Future<void> _onPopPageLock() async {
    if (_onPopPageLockValue) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 1));
    _onPopPageLockValue = true;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _onPopPageLockValue = false;
  }

  // Make separate object for this and for web just ignore it.
  /*
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
  */

  final _pagesHistory = RoutesHistoryAim<PageWithRouteAim>();

  @override
  Future<void> setNewRoutePath(IAppConfigAim<Object?> configuration, {bool isPop = false}) async {
    final config = typeConfig(configuration);
    print(' > setNewRoutePath');
    if (config == _currentState) return SynchronousFuture(null);

    if (!isPop) {
      if (config.route != _currentState.route) {
        final page = _buildPage(config);
        final pageAim = PageWithRouteAim(page: page, state: config);
        _pagesHistory.addToHistory(pageAim);
      } else {
        /*
        TODO: worth updating attrs?
        _pagesHistory
          ..removeFromHistory()
          ..addToHistory(config);
        */
      }
    }
    _reportNewState(config);

    return SynchronousFuture(null);
  }

  bool _popLock = false;
  @override
  Future<bool> popRoute() async {
    print(' > pop route');

    try {
      while (_popLock) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      _popLock = true;
      _pagesHistory.removeFromHistory();

      final pageAim = _pagesHistory.lastOrNull;
      if (pageAim != null) {
        await setNewRoutePath(pageAim.state);
        return SynchronousFuture<bool>(true);
      }

      final navigator = navigatorObserver.navigator;
      if (navigator == null) {
        return SynchronousFuture<bool>(false);
      }
      return navigator.maybePop();
    } finally {
      _popLock = false;
    }
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

class RoutesHistoryAim<T extends IIdAim> {
  Iterable<T> get history => _history;

  final List<T> _history = [];
  void addToHistory(T config) {
    if (config.id == _history.lastOrNull?.id) {
      return;
    }
    _history
      ..removeWhere((e) => e.id == config.id)
      ..add(config);
  }

  T? removeFromHistory() {
    if (_history.isEmpty) {
      return null;
    }
    final config = _history.removeLast();
    return config;
  }

  T? get lastOrNull => _history.lastOrNull;
}

class PageWithRouteAim implements IIdAim {
  @override
  String get id => state.id;

  final Page<dynamic> page;
  final IAppConfigAim<MapString> state;

  const PageWithRouteAim({
    required this.page,
    required this.state,
  });
}
