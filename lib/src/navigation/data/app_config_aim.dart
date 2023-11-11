import 'package:equatable/equatable.dart';

abstract class IAppConfigAim<T> extends Equatable {
  const IAppConfigAim();

  Uri? get uri;

  /// Base route
  String get route;
  T get args;

  IAppConfigAim<T> copyWith({
    Uri? uri,
    String? route,
    T? args,
  });
}

class AppConfigAim extends IAppConfigAim<Map<String, String?>> {
  @override
  final Uri? uri;

  @override
  final String route;
  @override
  final Map<String, String?> args;
  final bool internalChange;

  const AppConfigAim(
    this.uri,
    this.route, {
    this.internalChange = false,
    this.args = const {},
  });

  AppConfigAim.uri(
    String path,
    this.route, {
    this.internalChange = false,
    this.args = const {},
  }) : uri = Uri(path: '/$path');

  const AppConfigAim.route(
    this.route, {
    this.uri,
    this.args = const {},
    this.internalChange = false,
  });

  @override
  String toString() {
    return 'AppConfigAim: { route: $route, uriPath : ${uri?.path}, args : $args}';
  }

  @override
  List<Object?> get props => [route, uri?.path, internalChange, args];

  @override
  IAppConfigAim<Map<String, String?>> copyWith({Uri? uri, String? route, Map<String, String?>? args}) {
    return AppConfigAim(
      uri ?? this.uri,
      route ?? this.route,
      //internalChange: internalChange ?? this.internalChange,
      args: args ?? this.args,
    );
  }
}
