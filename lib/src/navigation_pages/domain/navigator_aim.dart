import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/presentation/material_navigator_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/imperative_page_builder_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/material_app_config_aim.dart';

abstract class INavigatorBaseAim<T> {
  MaterialAppNavigatorConfigAim<T> get config;

  void navigate(BuildContext context, IAppConfigAim<T> route);
  void pushNamed(BuildContext context, String route, {T? args});

  void changeState(BuildContext context, T args);
  void addToState(BuildContext context, T args);
  void removeFromState(BuildContext context, T args);
}

abstract class NavigatorAim<T> extends INavigatorBaseAim<T> implements IImperativePageBuilderAim<T> {
  static NavigatorAim of(BuildContext context) {
    final material = MaterialNavigatorAim.maybeOf(context);
    assert(material != null, 'MaterialNavigatorAim not found');
    return material!.navigator;
  }
}
