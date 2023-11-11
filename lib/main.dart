import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/example_navigation/navigation_container_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/feature/splash/presentation/pages/splash_page.dart';
import 'package:make_world_front_community/src/navigation/data/my_route_information_parser.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';
import 'package:make_world_front_community/src/navigation/data/route_info_provider_aim.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp(
      //initialRoute: SplashPage.routeName,
      ));
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
  late final exampleRoutes = NavigationContainerAim();
  late final routerDelegate = RouterDelegateAim(
    routesAim: exampleRoutes.routesAim,
    fallbackRoute: exampleRoutes.fallbackRoute,
  );
  final routeInformationParser = RouteInformationParserAim();
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
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        // print current route for clarity.
        print('>>> ${settings.name} <<<');

        switch (settings.name?.replaceFirst('/', '')) {
          case SplashPage.routeName:
            return MaterialPageRoute(
              builder: (context) => const SplashPage(),
              // settings omitted to hide route name
            );
          case LoginPage.routeName:
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
              settings: settings,
            );
          case HomePage.routeName:
            return MaterialPageRoute(
              builder: (context) => const HomePage(),
              settings: settings,
            );
          case '/':
            // don't generate route on start-up
            return null;
          default:
            return MaterialPageRoute(
              builder: (context) => const SplashPage(),
            );
        }
      },
      initialRoute: '/splash',
    );

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
