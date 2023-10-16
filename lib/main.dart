import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/splash/data/services/app_base_service_impl.dart';
import 'package:make_world_front_community/src/feature/splash/domain/services/app_base_service.dart';
import 'package:make_world_front_community/src/navigation/data/my_route_information_parser.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';
import 'package:make_world_front_community/src/navigation/data/route_info_provider_aim.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// {@template main}
/// RootApp widget
/// {@endtemplate}
class RootApp extends StatefulWidget {
  /// {@macro main}
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

/// State for widget RootApp
class _RootAppState extends State<RootApp> {
  //
  final routerDelegate = MirrorRouterDelegate();
  final routeInformationParser = MirrorInfoPraser();
  String? initialRoute;
  //
  final IAppBaseService _appBaseService = AppBaseServiceImpl();
  bool isLoaded = false;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _appBaseService.init();
    isLoaded = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    print(' > didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant RootApp oldWidget) {
    print(' > didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    //if (!isLoaded) {
    //  return MaterialApp.router(
    //    routerDelegate: routerDelegate,
    //    routeInformationParser: routeInformationParser,
    //    title: 'Flutter Demo',
    //    theme: ThemeData(
    //      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //      useMaterial3: true,
    //    ),
    //  );
    //}
    return MyApp(initialRoute: routerDelegate.latestRoute?.location);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    this.initialRoute,
    super.key,
  });

  final String? initialRoute;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final IAppBaseService _appBaseService = AppBaseServiceImpl();
  late final routerDelegate = MyRouterDelegate(_appBaseService);
  final routeInformationParser = MyRouteInformationParser();
  late final routeInfoProvider = RouterInfoProviderAim(
    initialRouteInformation: RouteInformation(
      location: widget.initialRoute,
    ),
  );

  @override
  void initState() {
    super.initState();
    print(' > passed initial route: ${widget.initialRoute}');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
      routeInformationProvider: routeInfoProvider,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
