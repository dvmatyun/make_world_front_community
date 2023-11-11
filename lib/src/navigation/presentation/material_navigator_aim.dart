import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_route_information_parser.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';
import 'package:make_world_front_community/src/navigation/data/route_info_provider_aim.dart';

/// {@template material_navigator_aim}
/// MaterialNavigatorAim widget
/// {@endtemplate}
class MaterialNavigatorAim extends StatefulWidget {
  /// {@macro material_navigator_aim}
  const MaterialNavigatorAim({
    required this.routesAim,
    required this.fallbackRoute,
    required this.splashScreenRoute,
    this.title = 'Flutter Demo',
    super.key,
  });

  final Map<String, RouteBuilderAim<Map<String, String?>>> routesAim;
  final RouteBuilderAim<Map<String, String?>?> fallbackRoute;
  final RouteBuilderAim<Map<String, String?>?> splashScreenRoute;
  final String title;

  @override
  State<MaterialNavigatorAim> createState() => _MaterialNavigatorAimState();
}

/// State for widget MaterialNavigatorAim
class _MaterialNavigatorAimState extends State<MaterialNavigatorAim> {
  String _latestRoute = '/';
  bool _navigatorInitialized = false;
  late final IRouterDelegateAim<Map<String, String?>> routerDelegate = RouterDelegateAim(
    routesAim: widget.routesAim,
    fallbackRoute: widget.fallbackRoute,
  );
  final IRouteInformationParserAim<Map<String, String?>> routeInformationParser = RouteInformationParserAim();
  late final RouterInfoProviderAim routeInfoProvider;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  Future<void> _initNavigation() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    routeInfoProvider = RouterInfoProviderAim(
      initialRouteInformation: RouteInformation(
        location: _latestRoute,
      ),
    );

    if (mounted) {
      setState(() {
        _navigatorInitialized = true;
      });
    }
  }

  @override
  void didUpdateWidget(MaterialNavigatorAim oldWidget) {
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
  Widget build(BuildContext context) {
    if (!_navigatorInitialized) {
      return MaterialApp(
        title: widget.title,
        onGenerateRoute: (RouteSettings settings) {
          // print current route for clarity.
          print('>>> ${settings.name} <<<');
          _latestRoute = settings.name ?? '/';
          final splash = widget.splashScreenRoute(const AppConfigAim.route(''));

          return MaterialPageRoute(
            builder: (context) => splash.child,
          );
        },
        initialRoute: '/splash',
      );
    }

    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
      routeInformationProvider: routeInfoProvider,
      title: widget.title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
