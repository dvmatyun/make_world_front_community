import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/feature/shaders/presentation/shimmer_aim.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';

/// {@template login_page}
/// ShaderPage widget
/// {@endtemplate}
class ShaderPage extends StatefulWidget {
  /// {@macro login_page}
  const ShaderPage({super.key});

  static const String routeName = 'shader';

  @override
  State<ShaderPage> createState() => _ShaderPageState();
}

/// State for widget ShaderPage
class _ShaderPageState extends State<ShaderPage> {
  @override
  Widget build(BuildContext context) {
    const name = 'Shader page';
    return ScaffoldAim(
      appBarWidget: const Text(name),
      metaName: name,
      body: Column(
        children: [
          const Text(name),
          TextButton(
            onPressed: () async {
              Router.navigate(context, () {
                MyRouterDelegate.of(context).setNewRoutePath(AppConfigAim.custom(HomePage.routeName));
              });
            },
            child: const Text('Go to home'),
          ),
          const SizedBox(height: 16),
          const ShimmerAim(
            color: Colors.red,
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
