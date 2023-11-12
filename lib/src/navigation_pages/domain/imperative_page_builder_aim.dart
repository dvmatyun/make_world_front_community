import 'package:flutter/material.dart';

abstract class IImperativePageBuilderAim<T> {
  /// Just a helper method to build the args by name
  T getModalNameArgs(String name);

  /// Decide if you need to push a new modal page depending on new route args
  String? needToPushNewModal(BuildContext context, T? args);

  /// Push a new modal page
  Future<Object?> pushImperativePage(BuildContext context, String name);
}
