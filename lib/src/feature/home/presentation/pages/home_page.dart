import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/feature/shaders/presentation/shader_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/navigator_aim.dart';
import 'package:make_world_front_community/src/navigation_pages/presentation/logic_page_aim.dart';

/// {@template login_page}
/// HomePage widget
/// {@endtemplate}
class HomePage extends PageArgumentSyncWidget {
  /// {@macro login_page}
  const HomePage({required this.navigatorState, super.key});

  @override
  final IAppConfigAim<MapString> navigatorState;

  static const String routeName = '/home';
  @override
  String get route => routeName;

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for widget HomePage
class _HomePageState extends PageArgumentSyncState<HomePage> {
  int counter = 0;
  static const _counterKey = 'counter';

  @override
  void syncArgumentToState(MapString args) {
    final counterStr = args?[_counterKey] ?? '0';
    counter = int.tryParse(counterStr) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    const name = 'Home page';
    return ScaffoldAim(
      appBarWidget: const Text(name),
      metaName: name,
      body: Column(
        children: [
          const Text('Do a login here'),
          TextButton(
            onPressed: () {
              NavigatorAim.of(context).pushNamed(context, LoginPage.routeName);
            },
            child: const Text('Go to login'),
          ),
          TextButton(
            onPressed: () {
              NavigatorAim.of(context).pushNamed(context, ShaderPage.routeName);
            },
            child: const Text('Go to shader'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              final counterNew = counter + 1;
              Router.neglect(context, () {
                NavigatorAim.of(context).changeState(context, {_counterKey: '$counterNew'});
              });
            },
            child: Text('increase counter (value=$counter)'),
          ),
        ],
      ),
    );
  }
}
