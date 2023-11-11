import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// See [PlatformRouteInformationProvider] for original class
/// The route information provider that propagates the platform route information changes.
///
/// This provider also reports the new route information from the [Router] widget
/// back to engine using message channel method, the
/// [SystemNavigator.routeInformationUpdated].
///
/// Each time [SystemNavigator.routeInformationUpdated] is called, the
/// [SystemNavigator.selectMultiEntryHistory] method is also called. This
/// overrides the initialization behavior of
/// [Navigator.reportsRouteUpdateToEngine].
class RouterInfoProviderAim extends RouteInformationProvider with WidgetsBindingObserver, ChangeNotifier {
  /// Create a platform route information provider.
  ///
  /// Use the [initialRouteInformation] to set the default route information for this
  /// provider.
  RouterInfoProviderAim({
    required RouteInformation initialRouteInformation,
  }) : _value = initialRouteInformation;

  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation,
      {RouteInformationReportingType type = RouteInformationReportingType.none}) {
    _handleInternal(routeInformation, type: type);
  }

  Future<void> _handleInternal(RouteInformation routeInformation,
      {RouteInformationReportingType type = RouteInformationReportingType.none}) async {
    final replace = type == RouteInformationReportingType.neglect ||
        (type == RouteInformationReportingType.none && _valueInEngine.location == routeInformation.location);

    print('_handleInternal: ${routeInformation.location}');
    await SystemNavigator.selectMultiEntryHistory();
    await SystemNavigator.routeInformationUpdated(
      location: routeInformation.location!,
      state: routeInformation.state,
      replace: replace,
    );

    _value = routeInformation;
    _valueInEngine = routeInformation;
  }

  @override
  RouteInformation get value => _value;
  RouteInformation _value;

  RouteInformation _valueInEngine =
      RouteInformation(location: WidgetsBinding.instance.platformDispatcher.defaultRouteName);

  void _platformReportsNewRouteInformation(RouteInformation routeInformation) {
    if (_value == routeInformation) {
      return;
    }
    _value = routeInformation;
    _valueInEngine = routeInformation;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) {
      WidgetsBinding.instance.addObserver(this);
    }
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      WidgetsBinding.instance.removeObserver(this);
    }
  }

  @override
  void dispose() {
    // In practice, this will rarely be called. We assume that the listeners
    // will be added and removed in a coherent fashion such that when the object
    // is no longer being used, there's no listener, and so it will get garbage
    // collected.
    if (hasListeners) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    assert(hasListeners);
    _platformReportsNewRouteInformation(routeInformation);
    return true;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    assert(hasListeners);
    _platformReportsNewRouteInformation(RouteInformation(location: route));
    return true;
  }
}
