import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/route_info_provider_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/material_app_config_aim.dart';

/// {@template material_navigator_aim}
/// MaterialNavigatorAim widget
/// {@endtemplate}
class MaterialNavigatorAim<T> extends StatefulWidget {
  /// {@macro material_navigator_aim}
  const MaterialNavigatorAim({
    required this.navigatorConfig,
    this.title = 'Flutter Demo',
    super.key,
  });

  final MaterialAppNavigatorConfigAim<T> navigatorConfig;

  final String title;

  @override
  State<MaterialNavigatorAim<T>> createState() => _MaterialNavigatorAimState<T>();
}

/// State for widget MaterialNavigatorAim
class _MaterialNavigatorAimState<T> extends State<MaterialNavigatorAim<T>> {
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

  Future<void> _initNavigation() async {
    final routeHandler = widget.navigatorConfig.customRouteHandler;
    final initialRouteTask = routeHandler.initialAppLoader();
    final tasks = <Future>[
      Future<void>.delayed(const Duration(seconds: 1)),
      initialRouteTask,
    ];

    await Future.wait(tasks);
    final initialRouteApp = await initialRouteTask;
    final platformRoute = await widget.navigatorConfig.routeInformationParser.parseRouteInformation(_latestRoute);
    final chosenRoute = await routeHandler.chooseInitialRoute(
      appLoaderRoute: initialRouteApp,
      platformInitialRoute: platformRoute,
    );
    final chosenRouteInfo = widget.navigatorConfig.routeInformationParser.restoreRouteInformation(chosenRoute);

    routeInfoProvider = RouterInfoProviderAim(
      initialRouteInformation: chosenRouteInfo ?? _latestRoute,
    );

    if (mounted) {
      setState(() {
        _navigatorInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    if (!_navigatorInitialized) {
      return MaterialApp(
        title: widget.title,
        onGenerateRoute: (RouteSettings settings) {
          // print current route for clarity.
          print('>>> ${settings.name} <<<');
          _latestRoute = RouteInformation(location: settings.name ?? '/', state: null);
          final splash =
              widget.navigatorConfig.routerDelegate.splashScreenRoute(AppConfigAim<T?>.route('', args: null));

          return MaterialPageRoute(
            builder: (context) => splash.child,
          );
        },
        initialRoute: '/splash',
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
