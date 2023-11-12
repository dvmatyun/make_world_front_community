import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation_pages/data/navigator_aim_base.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/imperative_page_builder_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/navigator_aim.dart';

class NavigatorAimImpl<T> extends NavigatorAimBase<T> implements NavigatorAim<T> {
  const NavigatorAimImpl({
    required super.config,
    required IImperativePageBuilderAim<T>? imperativePageBuilder,
  }) : _imperativePageBuilder = imperativePageBuilder;

  final IImperativePageBuilderAim<T>? _imperativePageBuilder;

  @override
  T getModalNameArgs(String name) {
    assert(_imperativePageBuilder != null, 'imperativePageBuilder must be passed in order to use getModalName()');
    return _imperativePageBuilder!.getModalNameArgs(name);
  }

  @override
  Future<Object?> pushImperativePage(BuildContext context, String name) {
    assert(
        _imperativePageBuilder != null, 'imperativePageBuilder must be passed in order to use showModalBottomSheet()');
    return _imperativePageBuilder!.pushImperativePage(context, name);
  }

  @override
  String? needToPushNewModal(BuildContext context, T? args) {
    if (_imperativePageBuilder == null) {
      return null;
    }
    return _imperativePageBuilder!.needToPushNewModal(context, args);
  }
}
