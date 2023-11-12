import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/feature/shaders/presentation/shader_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/router_delegate_aim.dart';
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
    super.syncArgumentToState(args);
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
          Row(
            children: [
              TextButton(
                onPressed: () {
                  final counterNew = counter + 1;
                  NavigatorAim.of(context).addToState(context, {_counterKey: '$counterNew'});
                },
                child: Text('increase counter (value=$counter)'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  NavigatorAim.of(context).removeFromState(context, {_counterKey: ''});
                },
                child: const Text('Clear counter'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  show(context, 'modal window #1');
                },
                child: const Text('Show modal #1'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  show(context, 'modal window #2');
                },
                child: const Text('Show modal #2'),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Shows this dialog on top of all screens.
  Future<Object?> show(BuildContext context, String name) async {
    final navigator = NavigatorAim.of(context);
    final value = await navigator.pushImperativePage(context, name);
    return value;
  }
}
