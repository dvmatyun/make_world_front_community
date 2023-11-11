import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';

/// {@template login_page}
/// LoginPage widget
/// {@endtemplate}
class LoginPage extends StatefulWidget {
  /// {@macro login_page}
  const LoginPage({super.key});

  static const String routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// State for widget LoginPage
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    const name = 'Login page';
    return ScaffoldAim(
      appBarWidget: const Text(name),
      metaName: name,
      body: Column(
        children: [
          const Text('Go home here'),
          TextButton(
            onPressed: () async {
              Router.navigate(context, () {
                RouterDelegateAim.of(context).setNewRoutePath(AppConfigAim.route(HomePage.routeName));
              });
            },
            child: const Text('Go to home'),
          ),
        ],
      ),
    );
  }
}
