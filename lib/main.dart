import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/example_navigation/navigation_container_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_route_information_parser.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';
import 'package:make_world_front_community/src/navigation/presentation/material_navigator_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/material_app_config_aim.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final exampleRoutes = NavigationContainerAim();

  late final navConfig = MaterialAppNavigatorConfigAim<MapString>(
    customRouteHandler: CustomRouteHandlerBaseAim(),
    routerDelegate: RouterDelegateAim(
      routesAim: exampleRoutes.routesAim,
      fallbackRoute: exampleRoutes.fallbackRoute,
      splashScreenRoute: exampleRoutes.splashRoute,
    ),
    routeInformationParser: const RouteInformationParserAim(),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialNavigatorAim(
      navigatorConfig: navConfig,
      title: 'Flutter Demo',
    );
  }
}
