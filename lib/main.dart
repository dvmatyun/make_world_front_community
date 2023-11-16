import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/example_navigation/example_route_handler_base_aim.dart';
import 'package:make_world_front_community/src/feature/example_navigation/navigation_container_aim.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/route_information_parser_aim.dart';
import 'package:make_world_front_community/src/navigation/data/router_delegate_aim.dart';
import 'package:make_world_front_community/src/navigation/presentation/material_navigator_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/data/imperative_page_builder_aim_impl.dart';
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
  late final exampleRoutes = ExampleNavigationContainerAim();

  late final navConfig = MaterialAppNavigatorConfigAim<MapString>(
    customRouteHandler: ExampleRoutehandlerBaseAim<MapString>(
      routeFactory: (route, args) => AppConfigMapAim.route(route, args: args),
      userService: $exampleUserService,
    ),
    routerDelegate: RouterDelegateAim(
        routesAim: exampleRoutes.routesAim,
        fallbackRoute: exampleRoutes.fallbackRoute,
        splashScreenRoute: exampleRoutes.splashRoute,
        routeGuard: (routeToCheck) async {
          final isLogged = await $exampleUserService.isUserLoggedIn();
          if (!isLogged) {
            return const AppConfigMapAim.route('/login');
          }
          return routeToCheck;
        }),
    routeInformationParser: const RouteInformationParserAim(),
    routeFactory: (route, args) {
      // ignore: unnecessary_cast
      final result = AppConfigMapAim.route(route, args: args) as IAppConfigAim<MapString>?;
      return result;
    },
    //TODO: Add guards to routes here
  );

  final imperitivePageBuilder = ExampleImperativePageBuilderAim();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialNavigatorAim(
      navigatorConfig: navConfig,
      imperativePageBuilder: imperitivePageBuilder,
      title: 'Flutter Demo',
    );
  }
}
