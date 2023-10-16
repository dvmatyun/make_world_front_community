import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/feature/shaders/presentation/shader_page.dart';
import 'package:make_world_front_community/src/feature/splash/domain/services/app_base_service.dart';
import 'package:make_world_front_community/src/feature/splash/presentation/pages/splash_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';

class MirrorRouterDelegate extends RouterDelegate<RouteInformation> with ChangeNotifier {
  RouteInformation? latestRoute;
  Iterable<Page<dynamic>> get _pagesIterable sync* {
    yield const MaterialPage(
      key: ValueKey('LoginPage'),
      name: 'LoginPage',
      child: SplashPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('BookRouterDelegate building...');
    return Navigator(
      observers: const [],
      pages: _pagesIterable.toList(),
      reportsRouteUpdateToEngine: false,
      onGenerateInitialRoutes: (ns, s) {
        print(' > onGenerateInitialRoutes: $s');
        return [];
      },
      onPopPage: (route, result) {
        print(' > on pop page: route=$route, result=$result');
        return true;
      },
    );
  }

  @override
  Future<void> setInitialRoutePath(RouteInformation configuration) {
    print(' > MirrorRouterDelegate setInitialRoutePath ${configuration.location}');
    latestRoute = configuration;
    return super.setInitialRoutePath(configuration);
  }

  @override
  Future<bool> popRoute() {
    return SynchronousFuture<bool>(false);
  }

  @override
  Future<void> setNewRoutePath(RouteInformation configuration) async {
    print(' > MirrorRouterDelegate setRestoredRoutePath ${configuration.location}');
  }
}

class MyRouterDelegate extends RouterDelegate<AppConfigAim> with ChangeNotifier {
  final IAppBaseService _baseService;
  MyRouterDelegate(IAppBaseService baseService) : _baseService = baseService {
    _init();
  }

  Future<void> _init() async {
    await _baseService.init();
    currentState = currentState.copyWith(internalChange: true);
    notifyListeners();
  }

  static MyRouterDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouterDelegate, 'Delegate type must match');
    return delegate as MyRouterDelegate;
  }

  AppConfigAim currentState = AppConfigAim.custom(LoginPage.routeName);
  final navigatorObserver = NavigatorObserver();

  AppConfigAim? previousState;
  // for pop on User Page, to possibly go back to a specific book

  @override
  AppConfigAim get currentConfiguration {
    return currentState;
  }

  Iterable<Page<dynamic>> get _pagesIterable sync* {
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
  Future<void> setNewRoutePath(AppConfigAim newState) async {
    print(' > setRestoredRoutePath ${newState.uri}');
    if (newState == currentState) return SynchronousFuture(null);

    currentState = newState;
    notifyListeners();

    return SynchronousFuture(null);
  }

  @override
  Future<void> setRestoredRoutePath(AppConfigAim configuration) {
    print(' > setRestoredRoutePath $configuration');
    return super.setRestoredRoutePath(configuration);
  }

  @override
  Future<void> setInitialRoutePath(AppConfigAim configuration) {
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
