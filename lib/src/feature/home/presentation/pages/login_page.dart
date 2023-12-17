import 'dart:async';

import 'package:flutter/material.dart';
import 'package:make_world_front_community/design_elements/page/scaffold_aim.dart';
import 'package:make_world_front_community/src/feature/example_navigation/example_route_handler_base_aim.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
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
  bool _isLoading = false;
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
              final navigator = NavigatorAim.of(context);
              setState(() {
                _isLoading = true;
              });
              await $exampleUserService.login('username', 'password');
              setState(() {
                _isLoading = false;
              });
              await Future<void>.delayed(const Duration(milliseconds: 100));
              final handler = navigator.config.customRouteHandler;
              unawaited(
                navigator.navigate(
                  context,
                  handler.initialPlatformRoute ?? const AppConfigMapAim(HomePage.routeName),
                ),
              );
            },
            child: _isLoading ? const CircularProgressIndicator.adaptive() : const Text('Go to home'),
          ),
        ],
      ),
    );
  }
}
