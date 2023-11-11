import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/feature/shaders/presentation/shader_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';

class MirrorInfoPraser extends RouteInformationParser<RouteInformation> {
  @override
  Future<RouteInformation> parseRouteInformation(RouteInformation routeInformation) async {
    return routeInformation;
  }

  @override
  RouteInformation? restoreRouteInformation(RouteInformation configuration) {
    return configuration;
  }
}

abstract class IRouteInformationParserAim<T> extends RouteInformationParser<IAppConfigAim<T>> {}

class RouteInformationParserAim extends IRouteInformationParserAim<Map<String, String?>> {
  String? _origin;
  @override
  Future<AppConfigAim> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    print(' > parseRouteInformation [ri: ${routeInformation.location} / ${routeInformation.state}]'
        ' : ${uri.pathSegments.join('/')}');
    _origin = uri.host;
    if (uri.pathSegments.isNotEmpty) {
      switch (uri.pathSegments[0]) {
        case HomePage.routeName:
        case LoginPage.routeName:
        case ShaderPage.routeName:
          return AppConfigAim(uri, uri.pathSegments[0]);
        default:
          break;
      }
    }
    return AppConfigAim(uri, '');
    /*
    // Handle '/' and '/book'
    if (uri.pathSegments.isEmpty ||
        (uri.pathSegments.length == 1 && uri.pathSegments[0] == AppConfigAim.book().uri.pathSegments[0])) {
      return AppConfigAim.book();
    }

    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == AppConfigAim.user().uri.pathSegments[0]) {
      return AppConfigAim.user();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == AppConfigAim.book().uri.pathSegments[0]) {
        final remaining = uri.pathSegments[1];
        final id = int.tryParse(remaining);
        if (id == null) return AppConfigAim.unknown();
        return AppConfigAim.bookDetail(id);
      }
    }
    */

    // Handle unknown routes
    //return AppConfigAim.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(IAppConfigAim<Map<String, String?>> configuration) {
    print(' > restoreRouteInformation : ${configuration.uri?.path}');
    //if (_origin == null && configuration.uri == null) {
    //  print(' > restoreRouteInformation : ORIGIN null result');
    //  return const RouteInformation(location: '/');
    //}
    final uri = configuration.uri;
    if (uri == null) {
      return RouteInformation(location: '/${configuration.route}');
    }

    if (uri.path.split('').every((e) => e == '/' || e == ' ')) {
      print(' > restoreRouteInformation : null result');
      return const RouteInformation(location: '/');
    }
    print(' > restoreRouteInformation : ${uri.path} result');
    return RouteInformation(location: uri.path);
    /*
    if (path.isUnknown) {
      return RouteInformation(location: AppConfigAim.unknown().uri.path);
    }
    if (path.isBookSection) {
      return RouteInformation(location: AppConfigAim.book().uri.path);
    }
    if (path.isBookDetailSection) {
      return RouteInformation(location: AppConfigAim.bookDetail(path.id).uri.path);
    }
    if (path.isUserSection) {
      return RouteInformation(location: AppConfigAim.user().uri.path);
    }
    return null;
    */
  }
}
