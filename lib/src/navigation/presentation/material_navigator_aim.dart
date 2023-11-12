import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/route_info_provider_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/data/navigator_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/imperative_page_builder_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/material_app_config_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/navigator_aim.dart';

/// {@template material_navigator_aim}
/// MaterialNavigatorAim widget
/// {@endtemplate}
class MaterialNavigatorAim<T> extends StatefulWidget {
  /// {@macro material_navigator_aim}
  MaterialNavigatorAim({
    required this.navigatorConfig,
    IImperativePageBuilderAim<T>? imperativePageBuilder,
    this.title = 'Flutter Demo',
    super.key,
  }) : navigator = NavigatorAimImpl(
          config: navigatorConfig,
          imperativePageBuilder: imperativePageBuilder,
        );

  final MaterialAppNavigatorConfigAim<T> navigatorConfig;
  final NavigatorAim navigator;

  final String title;

  @internal
  static _MaterialNavigatorAimState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_MaterialNavigatorAimState>();

  @override
  State<MaterialNavigatorAim<T>> createState() => _MaterialNavigatorAimState<T>();
}

/// State for widget MaterialNavigatorAim
class _MaterialNavigatorAimState<T> extends State<MaterialNavigatorAim<T>> {
  NavigatorAim get navigator => widget.navigator;

  late final MaterialAppNavigatorConfigAim<T> navigatorConfig = widget.navigatorConfig;

  RouteInformation _latestRoute = const RouteInformation(location: '/', state: null);
  bool _navigatorInitialized = false;

  late final RouterInfoProviderAim routeInfoProvider;

  /* #region Lifecycle */

  @override
  void initState() {
    super.initState();
    _initNavigation();
  }

  @override
  void dispose() {
    navigatorConfig.routerDelegate.close();
    super.dispose();
  }

  Future<void> _initNavigation() async {
    final routeHandler = widget.navigatorConfig.customRouteHandler;
    final rootRoute = await routeHandler.rootRouteLoader();
    final initialRouteTask = routeHandler.initialAppLoader(rootRoute: rootRoute);
    final tasks = <Future>[
      Future<void>.delayed(const Duration(milliseconds: 100)),
      initialRouteTask,
    ];

    await Future.wait(tasks);
    final initialRouteApp = await initialRouteTask;
    final platformRoute = await widget.navigatorConfig.routeInformationParser.parseRouteInformation(_latestRoute);
    final chosenRoute = await routeHandler.chooseInitialRoute(
      appLoaderRoute: initialRouteApp,
      platformInitialRoute: platformRoute,
      rootRoute: rootRoute,
    );

    RouteInformation? rootInfo;
    if (rootRoute != null) {
      rootInfo = widget.navigatorConfig.routeInformationParser.restoreRouteInformation(rootRoute);
    }

    RouteInformation? chosenRouteInfo;
    if (chosenRoute != null) {
      chosenRouteInfo = widget.navigatorConfig.routeInformationParser.restoreRouteInformation(chosenRoute);
    }

    routeInfoProvider = RouterInfoProviderAim(
      initialRouteInformation: chosenRouteInfo ?? rootInfo ?? _latestRoute,
    );

    if (mounted) {
      setState(() {
        _navigatorInitialized = true;
      });
    }
  }

  /* #endregion */

  late final _splash = widget.navigatorConfig.routerDelegate.splashScreenRoute(navigatorConfig.routeFactory('', null)!);
  @override
  Widget build(BuildContext context) {
    if (!_navigatorInitialized) {
      return MaterialApp(
        title: widget.title,
        onGenerateRoute: (RouteSettings settings) {
          // print current route for clarity.
          print('>>> ${settings.name} <<<');
          _latestRoute = RouteInformation(location: settings.name ?? '/', state: null);

          return MaterialPageRoute(
            builder: (context) => _splash.child,
          );
        },
      );
    }

    return MaterialApp.router(
      routerDelegate: widget.navigatorConfig.routerDelegate,
      routeInformationParser: widget.navigatorConfig.routeInformationParser,
      routeInformationProvider: routeInfoProvider,
      title: widget.title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

/// {@template material_navigator_aim}
/// _RootAimWidget widget
/// {@endtemplate}
class _RootAimWidget extends StatefulWidget {
  /// {@macro material_navigator_aim}
  const _RootAimWidget({required this.nestedRoute, required this.child});

  final IAppConfigAim? nestedRoute;
  final Widget? child;

  @override
  State<_RootAimWidget> createState() => __RootAimWidgetState();
}

/// State for widget _RootAimWidget
class __RootAimWidgetState extends State<_RootAimWidget> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _pushNestedRoute();
  }

  Future<void> _pushNestedRoute() async {
    final route = widget.nestedRoute;
    if (route == null) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 1));
    final navigator = NavigatorAim.of(context);
    // ignore: cascade_invocations
    navigator.navigate(context, route);
  }

  @override
  void didUpdateWidget(_RootAimWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => widget.child ?? const Placeholder();
}
