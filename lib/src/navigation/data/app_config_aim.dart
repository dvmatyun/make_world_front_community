import 'package:equatable/equatable.dart';

abstract class IAppConfigAim<T> extends Equatable {
  const IAppConfigAim();

  /// Base route
  String get route;
  T? get args;

  IAppConfigAim<T> copyWith({
    String? route,
    T? args,
    bool removeArgs = false,
  });
}

class AppConfigAim<T> extends IAppConfigAim<T> {
  @override
  final String route;
  @override
  final T? args;

  const AppConfigAim(
    this.route, {
    required this.args,
  });

  const AppConfigAim.route(
    this.route, {
    required this.args,
  });

  @override
  String toString() {
    return 'AppConfigAim: { route: $route, args : $args}';
  }

  @override
  List<Object?> get props => [route, args];

  @override
  IAppConfigAim<T> copyWith({
    String? route,
    T? args,
    bool removeArgs = false,
  }) {
    return AppConfigAim(
      route ?? this.route,
      args: removeArgs ? null : (args ?? this.args),
    );
  }
}

class AppConfigMapAim extends IAppConfigAim<Map<String, String?>?> {
  @override
  final String route;
  @override
  final Map<String, String?>? args;
  final bool internalChange;

  const AppConfigMapAim(
    this.route, {
    this.internalChange = false,
    this.args,
  });

  const AppConfigMapAim.route(
    this.route, {
    this.args,
    this.internalChange = false,
  });

  @override
  String toString() {
    return 'AppConfigAim: { route: $route, args : $args}';
  }

  @override
  List<Object?> get props => [route, internalChange, args];

  @override
  IAppConfigAim<Map<String, String?>?> copyWith({
    String? route,
    Map<String, String?>? args,
    bool removeArgs = false,
  }) {
    return AppConfigMapAim(
      route ?? this.route,
      args: removeArgs ? null : (args ?? this.args),
    );
  }
}
