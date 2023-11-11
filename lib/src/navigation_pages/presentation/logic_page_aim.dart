import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';

abstract class PageArgumentSyncWidget extends StatefulWidget {
  const PageArgumentSyncWidget({super.key});

  IAppConfigAim<Map<String, String?>?> get navigatorState;

  String get route;
}

abstract class PageArgumentSyncState<T extends PageArgumentSyncWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    syncArgumentToState(widget.navigatorState.args);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncArgumentToState(widget.navigatorState.args);
  }

  void syncArgumentToState(Map<String, String?>? args);
}
