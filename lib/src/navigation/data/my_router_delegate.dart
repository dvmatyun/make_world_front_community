import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/page_wrapper_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/page_aim.dart';

typedef RouteBuilderAim<T> = IPageAim Function(IAppConfigAim<T> args);

abstract class IRouterDelegateAim<T> extends RouterDelegate<IAppConfigAim<T>> {
  Map<String, RouteBuilderAim<T>> get routesAim;

  /// This page is shown if route is unknown
  RouteBuilderAim<T?> get fallbackRoute;

  /// This page is shown when app is loading
  RouteBuilderAim<T?> get splashScreenRoute;
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

  static RouterDelegateAim of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is RouterDelegateAim, 'Delegate type must match');
    return delegate as RouterDelegateAim;
  }

  IAppConfigAim<Map<String, String?>?> currentState = const AppConfigMapAim.route(LoginPage.routeName);
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
    /*
    if (!_baseService.isLoaded) {
      yield const MaterialPage(
        key: ValueKey('SplashPage'),
        name: 'SplashPage',
        child: SplashPage(),
      );
      return;
    }
    if (currentState.uri.pathSegments.isEmpty) {
      yield const MaterialPage(
        key: ValueKey('LoginPage'),
        name: 'LoginPage',
        child: LoginPage(),
      );
      return;
    }

    switch (currentState.uri.pathSegments[0]) {
      case HomePage.routeName:
        yield const MaterialPage(
          key: ValueKey('HomePage'),
          name: 'HomePage',
          child: HomePage(),
        );
      case ShaderPage.routeName:
        yield const MaterialPage(
          key: ValueKey('ShaderPage'),
          name: 'ShaderPage',
          child: ShaderPage(),
        );
      case LoginPage.routeName:
      default:
        yield const MaterialPage(
          key: ValueKey('LoginPage'),
          name: 'LoginPage',
          child: LoginPage(),
        );
    }
    */
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
        /*
        if (!route.didPop(result)) {
          return false;
        } else if (currentState.uri.pathSegments[0] == AppConfig.book().uri.pathSegments[0] &&
            currentState.id != null) {
          currentState = AppConfig.book();
        } else if (currentState.uri.path == AppConfig.user().uri.path) {
          currentState = previousState!;
          previousState = null;
        } else {
          currentState = AppConfig.unknown();
        }
        notifyListeners();
        */
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(IAppConfigAim<Map<String, String?>?> newState) async {
    print(' > setRestoredRoutePath route=${newState.route}, args=${newState.args} ');
    if (newState == currentState) return SynchronousFuture(null);

    currentState = newState;
    notifyListeners();

    return SynchronousFuture(null);
  }

  @override
  Future<void> setRestoredRoutePath(IAppConfigAim<Map<String, String?>?> configuration) {
    print(' > setRestoredRoutePath $configuration');
    return super.setRestoredRoutePath(configuration);
  }

  @override
  Future<void> setInitialRoutePath(IAppConfigAim<Map<String, String?>?> configuration) {
    print(' > setInitialRoutePath $configuration');
    return super.setInitialRoutePath(configuration);
  }

  /* use in button:
  Router.navigate(context, () {
                        (Router.of(context).routerDelegate as MyRouterDelegate).handleBookTapped(book);
                      });

  */

  /*
  void handleBookTapped(Book book) {
    currentState = AppConfig.bookDetail(books.indexOf(book));
    //notifyListeners();
    setNewRoutePath(currentState);
  }

  void handleUserTapped(void nulll) {
    previousState = currentState;
    currentState = AppConfig.user();
    notifyListeners();
  }

  void _notifyListeners(void nothing) {
    notifyListeners();
  }
  */

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
