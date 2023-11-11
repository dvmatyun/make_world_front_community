import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/feature/shaders/presentation/shader_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';

/// {@template login_page}
/// HomePage widget
/// {@endtemplate}
class HomePage extends StatefulWidget {
  /// {@macro login_page}
  const HomePage({required this.args, super.key});

  final IAppConfigAim<Map<String, String?>?> args;
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for widget HomePage
class _HomePageState extends State<HomePage> {
  int counter = 0;
  static const _counterKey = 'counter';

  @override
  void initState() {
    super.initState();
    //args
    final counterStr = widget.args.args?[_counterKey] ?? '0';
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
            onPressed: () async {
              Router.navigate(context, () {
                RouterDelegateAim.of(context).setNewRoutePath(const AppConfigMapAim.route(LoginPage.routeName));
              });
            },
            child: const Text('Go to login'),
          ),
          TextButton(
            onPressed: () async {
              Router.navigate(context, () {
                RouterDelegateAim.of(context).setNewRoutePath(const AppConfigMapAim.route(ShaderPage.routeName));
              });
            },
            child: const Text('Go to shader'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              counter += 1;
              Router.neglect(context, () {
                RouterDelegateAim.of(context).setNewRoutePath(
                  AppConfigMapAim.route(HomePage.routeName, args: {_counterKey: '$counter'}),
                );
              });
              if (mounted) {
                setState(() {});
              }
            },
            child: Text('increase counter (value=$counter)'),
          ),
        ],
      ),
    );
  }
}
