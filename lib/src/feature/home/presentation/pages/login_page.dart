import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/navigator_aim.dart';

/// {@template login_page}
/// LoginPage widget
/// {@endtemplate}
class LoginPage extends StatefulWidget {
  /// {@macro login_page}
  const LoginPage({super.key});

  static const String routeName = '/login';

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
                NavigatorAim.of(context).pushNamed(context, HomePage.routeName);
              });
            },
            child: const Text('Go to home'),
          ),
        ],
      ),
    );
  }
}
