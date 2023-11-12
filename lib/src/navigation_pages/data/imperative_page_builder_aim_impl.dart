import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/navigation/data/router_delegate_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/imperative_page_builder_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/navigator_aim.dart';

const _modalRouteName = 'modal';

abstract class ImperativePageBuilderBaseAim implements IImperativePageBuilderAim<MapString> {
  @override
  MapString? getModalNameArgs(String name) {
    return {_modalRouteName: name};
  }

  String? _modalWindowOnScreen;

  @override
  String? needToPushNewModal(BuildContext context, MapString? args) {
    if (args == null || _modalWindowOnScreen != null) {
      return null;
    }
    final modalValue = args[_modalRouteName];
    return modalValue;
  }

  @override
  Future<Object?> pushImperativePage(BuildContext context, String name) async {
    final routeArgs = getModalNameArgs(name);
    final navigator = NavigatorAim.of(context)..addToState(context, routeArgs);
    _modalWindowOnScreen = name;
    final value = await buildImperativePage(context, routeArgs);
    final args = navigator.config.routerDelegate.typedConfig.args as MapString?;
    final modalValue = args?[_modalRouteName];
    if (modalValue == name) {
      _modalWindowOnScreen = null;
      navigator.removeFromState(context, routeArgs);
    }
    return value;
  }

  Future<Object?> buildImperativePage(BuildContext context, MapString routeArgs);
}

class ExampleImperativePageBuilderAim extends ImperativePageBuilderBaseAim {
  @override
  Future<Object?> buildImperativePage(BuildContext context, MapString routeArgs) async {
    final modalName = routeArgs?[_modalRouteName];
    final value = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: FractionallySizedBox(
                heightFactor: 0.8,
                child: Stack(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ScaffoldAim(body: Text('Test body for modal "$modalName"')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
    );
    return value;
  }
}
