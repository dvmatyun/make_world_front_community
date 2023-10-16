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
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for widget HomePage
class _HomePageState extends State<HomePage> {
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
                MyRouterDelegate.of(context).setNewRoutePath(AppConfigAim.custom(LoginPage.routeName));
              });
            },
            child: const Text('Go to login'),
          ),
          TextButton(
            onPressed: () async {
              Router.navigate(context, () {
                MyRouterDelegate.of(context).setNewRoutePath(AppConfigAim.custom(ShaderPage.routeName));
              });
            },
            child: const Text('Go to shader'),
          ),
        ],
      ),
    );
  }
}
