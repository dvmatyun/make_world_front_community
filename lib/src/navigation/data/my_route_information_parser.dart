import 'package:flutter/material.dart';
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

abstract class IRouteInformationParserAim<T> extends RouteInformationParser<IAppConfigAim<T>> {
  const IRouteInformationParserAim() : super();
}

class RouteInformationParserAim extends IRouteInformationParserAim<Map<String, String?>?> {
  const RouteInformationParserAim();

  @override
  Future<AppConfigMapAim> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.tryParse(routeInformation.location ?? '');
    final route = uri?.path ?? '/';
    final mapArgsQuery = uri?.queryParametersAll.map((key, value) => MapEntry(key, value.join(',')));

    print(' > parser parse route: $route / args: $mapArgsQuery');
    return AppConfigMapAim(route, args: mapArgsQuery);
  }

  @override
  RouteInformation? restoreRouteInformation(IAppConfigAim<Map<String, String?>?> configuration) {
    final uri = Uri.http('', configuration.route, configuration.args);
    final location = uri.query.isEmpty ? uri.path : '${uri.path}?${uri.query}';
    print(' > parser serialize route: $location');
    return RouteInformation(location: location);
  }
}
