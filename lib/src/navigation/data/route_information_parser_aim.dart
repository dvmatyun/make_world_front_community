import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/router_delegate_aim.dart';

abstract class IRouteInformationParserAim<T> extends RouteInformationParser<IAppConfigAim<T>> {
  const IRouteInformationParserAim() : super();
}

class RouteInformationParserAim extends IRouteInformationParserAim<MapString> {
  const RouteInformationParserAim();

  @override
  Future<IAppConfigAim<MapString>> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.tryParse(routeInformation.location ?? '');
    final route = uri?.path ?? '/';
    final mapArgsQuery = uri?.queryParametersAll.map((key, value) => MapEntry(key, value.join(',')));
    //print(' > parser parse route: $route / args: $mapArgsQuery');
    return AppConfigMapAim(route, args: mapArgsQuery);
  }

  @override
  RouteInformation? restoreRouteInformation(IAppConfigAim<MapString> configuration) {
    final uri = Uri.http('', configuration.route, configuration.args);
    final location = uri.query.isEmpty ? uri.path : '${uri.path}?${uri.query}';
    //print(' > parser serialize route: $location .'); //StackTrake: ${StackTrace.current}
    return RouteInformation(location: location);
  }
}
