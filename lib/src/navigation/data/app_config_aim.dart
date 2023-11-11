import 'package:equatable/equatable.dart';

abstract class IAppConfigAim<T> extends Equatable {
  const IAppConfigAim();

  //Uri? get uri;

  /// Base route
  String get route;
  T get args;

  IAppConfigAim<T> copyWith({
    Uri? uri,
    String? route,
    T? args,
  });
}

class AppConfigAim<T> extends IAppConfigAim<T> {
  @override
  final Uri? uri;

  @override
  final String route;
  @override
  final T args;

  const AppConfigAim(
    this.uri,
    this.route, {
    required this.args,
  });

  AppConfigAim.uri(
    String path,
    this.route, {
    required this.args,
  }) : uri = Uri(path: '/$path');

  const AppConfigAim.route(
    this.route, {
    required this.args,
    this.uri,
  });

  @override
  String toString() {
    return 'AppConfigAim: { route: $route, uriPath : ${uri?.path}, args : $args}';
  }

  @override
  List<Object?> get props => [route, uri?.path, args];

  @override
  IAppConfigAim<T> copyWith({Uri? uri, String? route, T? args}) {
    return AppConfigAim(
      uri ?? this.uri,
      route ?? this.route,
      //internalChange: internalChange ?? this.internalChange,
      args: args ?? this.args,
    );
  }
}

class AppConfigMapAim extends IAppConfigAim<Map<String, String?>?> {
  @override
  final Uri? uri;

  @override
  final String route;
  @override
  final Map<String, String?>? args;
  final bool internalChange;

  const AppConfigMapAim(
    this.uri,
    this.route, {
    this.internalChange = false,
    this.args,
  });

  AppConfigMapAim.uri(
    String path,
    this.route, {
    this.internalChange = false,
    this.args,
  }) : uri = Uri(path: '/$path');

  const AppConfigMapAim.route(
    this.route, {
    this.uri,
    this.args,
    this.internalChange = false,
  });

  @override
  String toString() {
    return 'AppConfigAim: { route: $route, uriPath : ${uri?.path}, args : $args}';
  }

  @override
  List<Object?> get props => [route, uri?.path, internalChange, args];

  @override
  IAppConfigAim<Map<String, String?>?> copyWith({Uri? uri, String? route, Map<String, String?>? args}) {
    return AppConfigMapAim(
      uri ?? this.uri,
      route ?? this.route,
      //internalChange: internalChange ?? this.internalChange,
      args: args ?? this.args,
    );
  }
}
