import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation/data/my_route_information_parser.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';
import 'package:make_world_front_community/src/navigation/data/route_info_provider_aim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routerDelegate = MyRouterDelegate();
  final routeInformationParser = MyRouteInformationParser();
  final routeInfoProvider = RouterInfoProviderAim(initialRouteInformation: const RouteInformation(location: '/'));

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
      //child: const MyHomePage(title: 'Flutter Demo Home Page')
      /*
      home: Navigator(
        pages: const [
          MaterialPage(
            key:  ValueKey('ChatPage'),
            child:  ChatPage(title: 'Flutter Demo Home Page'),
          ),
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
      */
    );
  }
}
