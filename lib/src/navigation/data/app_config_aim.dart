import 'package:equatable/equatable.dart';
import 'package:make_world_front_community/src/navigation/data/router_delegate_aim.dart';

abstract class IIdAim {
  String get id;
}

abstract class IAppConfigAim<T> extends Equatable implements IIdAim {
  const IAppConfigAim();

  @override
  String get id => route;

  /// Base route
  String get route;
  T? get args;

  IAppConfigAim<T> copyWith({
    String? route,
    T? args,
    bool removeArgs = false,
  });

  /// Should add to state, preserving old state args
  IAppConfigAim<T> addToState({required T args});

  /// Should remove part of state, depending on args
  IAppConfigAim<T> removeFromState({required T args});
}

abstract class AppConfigAim<T> extends IAppConfigAim<T> {
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
  });

  /// Should add to state, preserving old state args
  @override
  IAppConfigAim<T> addToState({required T args});

  /// Should remove part of state, depending on args
  @override
  IAppConfigAim<T> removeFromState({required T args});
}

class AppConfigMapAim extends IAppConfigAim<MapString> {
  @override
  final String route;
  @override
  final MapString args;
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
  IAppConfigAim<MapString> copyWith({
    String? route,
    MapString args,
    bool removeArgs = false,
  }) {
    return AppConfigMapAim(
      route ?? this.route,
      args: removeArgs ? null : (args ?? this.args),
    );
  }

  /// Should add to state, preserving old state args
  @override
  IAppConfigAim<MapString> addToState({MapString? args}) {
    final newState = <String, String?>{};
    final curArgs = this.args;
    if (curArgs != null) {
      newState.addAll(curArgs);
    }
    if (args != null) {
      newState.addAll(args);
    }
    return copyWith(args: newState);
  }

  /// Should remove part of state, depending on args
  @override
  IAppConfigAim<MapString> removeFromState({required MapString? args}) {
    final newState = <String, String?>{};
    final curArgs = this.args;
    if (curArgs != null) {
      newState.addAll(curArgs);
    }
    if (args != null) {
      newState.removeWhere((key, value) => args.containsKey(key));
    }
    return copyWith(args: newState);
  }
}
